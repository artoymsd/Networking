//
//  ParameterEncoding.swift
//
//  Created by Artem Sidorenko on 18/04/2019.
//  Copyright © 2019 Artem Sidorenko. All rights reserved.
//

import Foundation

public typealias Parameters = [String: Any]

public protocol ParameterEncoder {
  func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws
}

public enum ParameterEncoding {
  case urlEncoding
  case jsonEncoding
  case urlAndJsonEncoding
  
  public func encode(urlRequest: inout URLRequest,
                     bodyParameters: Parameters?,
                     model: Encodable?,
                     urlParameters: Parameters?) throws {
    do {
      switch self {
        
      case .urlEncoding:
        guard let urlParameters = urlParameters else { return }
        try URLParameterEncoder().encode(urlRequest: &urlRequest, with: urlParameters)
        
      case .jsonEncoding:
        if let bodyParameters = bodyParameters {
          try JSONParameterEncoder().encode(urlRequest: &urlRequest, with: bodyParameters)
        } else if let model = model {
          try JSONParameterEncoder().encode(urlRequest: &urlRequest, model: model)
        } else { return }
        
      case .urlAndJsonEncoding:
        guard let bodyParameters = bodyParameters,
          let urlParameters = urlParameters else { return }
        try URLParameterEncoder().encode(urlRequest: &urlRequest, with: urlParameters)
        try JSONParameterEncoder().encode(urlRequest: &urlRequest, with: bodyParameters)
      }
    } catch {
      throw error
    }
  }
}

public enum NetworkError: String, Error {
  case parametersNil  = "Parameters were nil."
  case encodingFailed = "Parameter encoding failed."
  case missingURL     = "URL is nil."
}
