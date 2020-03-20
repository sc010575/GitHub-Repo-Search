//
//  GitHubDataProvider.swift
//  Github-repo-search
//
//  Created by Suman Chatterjee on 11/03/2020.
//  Copyright © 2020 Suman Chatterjee. All rights reserved.
//

import Foundation

protocol GitHubDataProviderUseCase {
  typealias ResultType = Result<GitHubRepoLIst, AppError>
  func gitHubDataProvider(_ type: ApiType, params: [String: String], completion: @escaping (ResultType) -> Void)
}

class GitHubDataProvider: GitHubDataProviderUseCase {
  let netWork: NetworkUseCase

  init(_networkCase: NetworkUseCase = Network()) {
    self.netWork = _networkCase
  }

  func gitHubDataProvider(_ type: ApiType, params: [String: String], completion: @escaping (ResultType) -> Void) {
    guard let baseUrl = baseUrl else { return }
    netWork.send(baseUrl, type: type, parameters: params) { result in
    DispatchQueue.global(qos: .background).async {
        let modelResult: ResultType
        switch result {
        case .success(let data):
          guard let data = data else { return }
          let model: Result<GitHubRepoLIst, Error> = Serialize.parse(data)
          switch model {
          case .success(let repoList):
            modelResult = .success(repoList)
          case .failure(_):
            modelResult = .failure(.dataError(message: "Json parsing error"))
          }
        case .failure(let error):
          modelResult = .failure(.dataError(message: error.localizedDescription))
        }
        DispatchQueue.main.async {
          completion(modelResult)
        }
     }
    }
  }
}

