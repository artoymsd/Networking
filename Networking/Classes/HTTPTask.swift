//
//  HTTPTasks.swift
//
//  Created by Artem Sidorenko on 18/04/2019.
//  Copyright © 2019 Artem Sidorenko. All rights reserved.
//

import Foundation

public typealias HTTPHeaders = [String: String]

public enum HTTPTask {
  case request(
    bodyParameters: Parameters? = nil,
    bodyModel: Encodable? = nil,
    bodyEncoding: ParameterEncoding = .urlEncoding,
    urlParameters: Parameters? = nil,
    urlModel: URLEncodable? = nil,
    additionHeaders: HTTPHeaders? = nil
  )
}
