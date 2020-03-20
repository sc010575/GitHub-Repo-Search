//
//  RequestBuilderTest.swift
//  Github-repo-searchTests
//
//  Created by Suman Chatterjee on 11/03/2020.
//  Copyright © 2020 Suman Chatterjee. All rights reserved.
//

import XCTest
@testable import Github_repo_search


class RequestBuilderTest: XCTestCase {

    func testRequestBuilder() {
      let dateString = "2020-01-15"
      let queryString = "swift"
      let created = "created"
      let params = ["q": "\(queryString+created+":>"+dateString)", "per_page":"2","page":"1"]
      let url = URL(string: "https://api.github.com/")!
      let reqBuilderOnTest = RequestBuilder(baseUrl:url , params: params, timeInterval: 50)
      let request = reqBuilderOnTest.buildRequest(ApiType.search, Method: "GET")
      XCTAssertEqual(reqBuilderOnTest.baseUrl.absoluteString, "https://api.github.com/")
      XCTAssertEqual(request?.url?.pathComponents.count, 3)
  
  }
}
