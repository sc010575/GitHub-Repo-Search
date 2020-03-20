//
//  GitHubRepoTest.swift
//  Github-repo-searchTests
//
//  Created by Suman Chatterjee on 11/03/2020.
//  Copyright © 2020 Suman Chatterjee. All rights reserved.
//

import XCTest
@testable import Github_repo_search

class Fixture {
  static func getData(from fileName:String, type:String = "json") -> Data? {
    
    guard let path = Bundle(for: Fixture.self).path(forResource: fileName, ofType: type),
      let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else  {
        return nil
    }
    return data
  }
}

class GitHubRepoTest: XCTestCase {
  
    func testModel() {
      if let data = Fixture.getData(from: "gitHubQuery") {
        let gitHubRepo:Result<[GitHubRepo],Error> = Serialize.parse(data)
        switch gitHubRepo {
        case .success(let repo):
          XCTAssertEqual(repo.count, 2)
        case .failure(let error):
          print(error.localizedDescription)
        }
        
      }
      
    }

}
