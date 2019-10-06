//
//  Router.swift
//
//  Created by Artem Sidorenko on 18/04/2019.
//  Copyright © 2019 Artem Sidorenko. All rights reserved.
//

import Foundation

public typealias NetworkRouterCompletion = (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void

public protocol NetworkRouter: class {
  associatedtype EndPoint: IEndPoint
  
  func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion)
  func cancel()
}

public class Router<EndPoint: IEndPoint>: NetworkRouter {
  private var task: URLSessionTask?
  
  public func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion) {
    DispatchQueue.global(qos: .userInitiated).async {
      
      let session = URLSession.shared
      
      do {
        let request = try self.buildRequest(from: route)
        if let cachedResponse = URLCache.shared.cachedResponse(for: request) {
          completion(cachedResponse.data, cachedResponse.response, nil)
        } else {
          self.task = session.dataTask(with: request, completionHandler: { data, response, error in
            if error != nil {
              completion(nil, nil, error)
            }
            if let response = response as? HTTPURLResponse {
              if let data = data, response.statusCode < 300 {
                let cachedData = CachedURLResponse(response: response, data: data, storagePolicy: .allowedInMemoryOnly)
                URLCache.shared.storeCachedResponse(cachedData, for: request)
              }
              
              completion(data, response, error)
            }
          })
        }
      } catch {
        completion(nil, nil, error)
      }
      self.task?.resume()
    }
  }
  
  public func cancel() {
    self.task?.cancel()
  }
  
  fileprivate func buildRequest(from route: EndPoint) throws -> URLRequest {
    var request = URLRequest(url: route.baseURL.appendingPathComponent(route.path),
                             cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                             timeoutInterval: 15.0)
    
    request.httpMethod = route.httpMethod.rawValue
    request.setValue("XMLHttpRequest", forHTTPHeaderField: "X-Requested-With")
    
    do {
      switch route.task {
      case .request:
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
      case .requestParameters(let bodyParameters,
                              let bodyEncoding,
                              let urlParameters):
        try self.configureParameters(bodyParameters: bodyParameters,
                                     bodyEncoding: bodyEncoding,
                                     urlParameters: urlParameters,
                                     request: &request)
      case .requestParametersAndHeaders(let bodyParameters,
                                        let bodyEncoding,
                                        let urlParameters,
                                        let additionalHeaders):
        self.addAdditionalHeaders(additionalHeaders, request: &request)
        try self.configureParameters(bodyParameters: bodyParameters,
                                     bodyEncoding: bodyEncoding,
                                     urlParameters: urlParameters,
                                     request: &request)
      }
      return request
    } catch {
      throw error
    }
  }
  
  fileprivate func configureParameters(bodyParameters: Parameters?,
                                       bodyEncoding: ParameterEncoding,
                                       urlParameters: Parameters?,
                                       request: inout URLRequest) throws {
    do {
      try bodyEncoding.encode(urlRequest: &request,
                              bodyParameters: bodyParameters, urlParameters: urlParameters)
    } catch {
      throw error
    }
  }
  
  fileprivate func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
    guard let headers = additionalHeaders else { return }
    for (key, value) in headers {
      request.setValue(value, forHTTPHeaderField: key)
    }
  }
}
