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
  public init() {}
  
  public func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion) {
    DispatchQueue.global(qos: .userInitiated).async {
      let session = URLSession(configuration: URLSessionConfiguration.default)
      
      do {
        let request = try self.buildRequest(from: route)
        
        self.task = session.dataTask(with: request, completionHandler: { data, response, error in
          if error != nil {
            completion(nil, nil, error)
          }
          
          if let response = response as? HTTPURLResponse {
            completion(data, response, error)
          }
        })
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
    var request = prepareRequest(route.baseURL.appendingPathComponent(route.path), method: route.httpMethod)
    do {
      switch route.task {
      case .request:
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
      case .requestParameters(let bodyParameters,
                              let model,
                              let bodyEncoding,
                              let urlParameters):
        try self.configureParameters(bodyParameters: bodyParameters,
                                     model: model,
                                     bodyEncoding: bodyEncoding,
                                     urlParameters: urlParameters,
                                     request: &request)
      case .requestParametersAndHeaders(let bodyParameters,
                                        let model,
                                        let bodyEncoding,
                                        let urlParameters,
                                        let additionalHeaders):
        self.addAdditionalHeaders(additionalHeaders, request: &request)
        try self.configureParameters(bodyParameters: bodyParameters,
                                     model: model,
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
                                       model: Encodable?,
                                       bodyEncoding: ParameterEncoding,
                                       urlParameters: Parameters?,
                                       request: inout URLRequest) throws {
    do {
      try bodyEncoding.encode(urlRequest: &request,
                              bodyParameters: bodyParameters, model: model, urlParameters: urlParameters)
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
  
  fileprivate func prepareRequest(_ url: URL, method: HTTPMethod = .get) -> URLRequest {
    var request = URLRequest(url: url,
                             cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                             timeoutInterval: 15.0)
    request.httpMethod = method.rawValue
    request.setValue("XMLHttpRequest", forHTTPHeaderField: "X-Requested-With")
    return request
  }
}
