//
//  JSONParameterEncoder.swift
//
//  Created by Artem Sidorenko on 18/04/2019.
//  Copyright © 2019 Artem Sidorenko. All rights reserved.
//

import Foundation

public struct JSONParameterEncoder: ParameterEncoder {
  public func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
    do {
      let jsonAsData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
      supplementRequest(&urlRequest, jsonAsData)
    } catch {
      throw NetworkError.encodingFailed
    }
  }
  
  public func encode(urlRequest: inout URLRequest, with model: Encodable) throws {
    do {
      let encodable = AnyEncodable(model)
      let jsonAsData = try JSONEncoder().encode(encodable)
     supplementRequest(&urlRequest, jsonAsData)
    } catch {
      throw NetworkError.encodingFailed
    }
  }
  
  fileprivate func supplementRequest(_ urlRequest: inout URLRequest, _ data: Data) {
    urlRequest.httpBody = data
    if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
      urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
    }
  }
}
