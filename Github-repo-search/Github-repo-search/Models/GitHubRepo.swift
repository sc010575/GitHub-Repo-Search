//
//  GitHubRepo.swift
//  Github-repo-search
//
//  Created by Suman Chatterjee on 11/03/2020.
//  Copyright © 2020 Suman Chatterjee. All rights reserved.
//

import Foundation

struct GitHubRepo: Decodable {
  
  struct Owner: Decodable {
    let login: String
    let avatarUrl: String?
  }

  
  let name: String
  let description: String?
  var createdAt: String
  let stargazersCount: Int
  let owner: Owner
}

struct GitHubRepoLIst: Decodable {
  let totalCount:Int
  let items: [GitHubRepo]
}


//struct Owner: Decodable {
//  let login: String
//  let avatarUrl: String?
//}

