//
//  HTTPTasks.swift
//
//  Created by Artem Sidorenko on 18/04/2019.
//  Copyright © 2019 Artem Sidorenko. All rights reserved.
//

import Foundation

public typealias HTTPHeaders = [String: String]

public enum HTTPTask {
  case request
  
  case requestParameters(bodyParameters: Parameters?,
    model: Encodable?,
    bodyEncoding: ParameterEncoding,
    urlParameters: Parameters?)
  
  case requestParametersAndHeaders(bodyParameters: Parameters?,
    model: Encodable?,
    bodyEncoding: ParameterEncoding,
    urlParameters: Parameters?,
    additionHeaders: HTTPHeaders?)
}
