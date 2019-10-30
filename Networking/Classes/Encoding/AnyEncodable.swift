//
//  AnyEncodable.swift
//  Networking
//
//  Created by Artem Sidorenko on 30.10.2019.
//  Copyright © 2019 Artem Sidorenko. All rights reserved.
//

import Foundation

public struct AnyEncodable: Encodable {
  
  private let encodable: Encodable
  
  public init(_ encodable: Encodable) {
    self.encodable = encodable
  }
  
  public func encode(to encoder: Encoder) throws {
    try encodable.encode(to: encoder)
  }
}
