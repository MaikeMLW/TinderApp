//
//  RandomUserApiTests.swift
//  TinderAppTests
//
//  Created by Timofey on 8/7/22.
//

import XCTest
@testable import TinderApp
import SwiftUI

class RandomUserApiTests: XCTestCase {
  
  var sut: RandomUserApi!
  
  override func setUpWithError() throws {
    sut = RandomUserApi()
  }
  
  override func tearDownWithError() throws {
    sut = nil
  }
  
  func testApiLoadsAndDecodeUsersWithRightCount() {
    var users = [UserCardModel]()
    let loadExpectation = expectation(description: "load expectation")
    sut.fetchPeopleWithParametrs(count: 7) { result in
      switch result {
      case .success(let downloaded):
        users = downloaded
        loadExpectation.fulfill()
      case .failure(let error):
        print(error)
        // fails if coordinates not nil
        XCTFail()
      }
    }
    wait(for: [loadExpectation], timeout: 3)
    XCTAssertTrue(users.count == 7)
  }
  
}
