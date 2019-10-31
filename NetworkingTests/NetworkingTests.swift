//
//  NetworkingTests.swift
//  NetworkingTests
//
//  Created by Artem Sidorenko on 31.10.2019.
//  Copyright © 2019 Artem Sidorenko. All rights reserved.
//

import XCTest
@testable import Networking

class NetworkingTests: XCTestCase {
  
  var encodableModel: UploadReceipt?
  
  struct UploadReceipt: Encodable {
    var bundleId: String
    var deviceId: String
    var receipt: String
    var appsFlyerId: String
    
    enum CodingKeys: String, CodingKey {
      case bundleId    = "bundle_id"
      case deviceId    = "apple_device_id"
      case receipt     = "receipt"
      case appsFlyerId = "af_id"
    }
    
    public func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(bundleId, forKey: .bundleId)
      try container.encode(deviceId, forKey: .deviceId)
      try container.encode(receipt, forKey: .receipt)
      try container.encode(appsFlyerId, forKey: .appsFlyerId)
    }
  }
  
  override func setUp() {
    encodableModel = .init(bundleId: "test", deviceId: "sdfsd", receipt: "sdfsdf", appsFlyerId: "dsfsdf")
  }
  
  override func tearDown() {
    encodableModel = nil
  }
  
  func testJsonModelEncoding() {
    var urlRequest: URLRequest = URLRequest(url: URL(string: "https://google.com")!)
    try? JSONParameterEncoder().encode(urlRequest: &urlRequest, model: AnyEncodable(encodableModel))
    
  
     
  }
  
  func testExample() {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
  }
  
  func testPerformanceExample() {
    // This is an example of a performance test case.
    measure {
      // Put the code you want to measure the time of here.
    }
  }
  
}
