//
//  URLEncodable.swift
//  ALNetworking
//
//  Created by Artem Sidorenko on 23.01.2020.
//

import Foundation

public protocol URLEncodable {
  func queryParams() -> [String: String?]
}
