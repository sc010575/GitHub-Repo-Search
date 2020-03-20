//
//  GitHubListViewModel.swift
//  Github-repo-search
//
//  Created by Suman Chatterjee on 11/03/2020.
//  Copyright © 2020 Suman Chatterjee. All rights reserved.
//

import Foundation
import UIKit

extension String {
  func dateConvert() -> String {
    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    let showDate = inputFormatter.date(from: self)
    inputFormatter.dateFormat = "MM/dd/yyyy"
    let createdAt = inputFormatter.string(from: showDate!)
    return createdAt
  }
}

struct GitHubCellViewModel {
  let name: String
  let description: String
  var createdAt: String
  let starCount: Int
  let userName: String
  let avatarUrl: String?
  private let network: NetworkUseCase

  init(_ repo: GitHubRepo, network: NetworkUseCase = Network()) {
    self.name = repo.name
    self.description = repo.description ?? ""
    self.createdAt = repo.createdAt.dateConvert()
    self.starCount = repo.stargazersCount
    self.userName = repo.owner.login
    self.avatarUrl = repo.owner.avatarUrl
    self.network = network
  }

  func getAvaterImage(completion: @escaping (Result<UIImage?, AppError>) -> Void) {
    guard let urlStr = avatarUrl, let url = URL(string: urlStr) else { return }
    network.send(url, type: nil, parameters: [:]) { (result) in
      switch result {
      case .success(let data):
        completion(.success(UIImage(data: data!)))
      case .failure(let appError):
        completion(.failure(appError))
      }
    }
  }
}

//MARK:- GitHubListViewModel
protocol GitHubListViewModelUseCase {
  var gitHubRepos: [GitHubCellViewModel] { get set }
  var totalCount: Int { get  }
  var currentCount: Int { get  }
  var currentPage: Int { get set }
  func gitHubCellViewModel(at index: Int) -> GitHubCellViewModel?
  func getGitHubSearchData(completion: @escaping (Result<[IndexPath]?, AppError>) -> Void)
}

final class GitHubListViewModel: GitHubListViewModelUseCase {
  var gitHubRepos = [GitHubCellViewModel]()
  let gitHubDataProvider: GitHubDataProviderUseCase!
  private var daysBehindFromToday: String {
    let fromDate = Calendar.current.date(byAdding: .day, value: -90, to: Date())
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    let thatDate = formatter.string(from: fromDate ?? Date())
    return thatDate
  }

  private var total = 0
  var currentPage = 0
  private var isFetchInProgress = false


  let queryString = "swift"
  let created = "created"

  init(_ gitHubDataProvider: GitHubDataProviderUseCase = GitHubDataProvider()) {
    self.gitHubDataProvider = gitHubDataProvider
  }
  func getGitHubSearchData(completion: @escaping (Result<[IndexPath]?, AppError>) -> Void) {

    guard !isFetchInProgress else {
      return
    }
    isFetchInProgress = true

    let params = ["q": "\(queryString)+\(created):>\(daysBehindFromToday)", "per_page": "10", "page": "\(currentPage)"]
    gitHubDataProvider.gitHubDataProvider(ApiType.search, params: params) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let repoList):
        self.currentPage += 1
        self.isFetchInProgress = false
        self.gitHubRepos.append(contentsOf: repoList.items.map { GitHubCellViewModel($0) })
        self.total = repoList.totalCount

//        if self.currentPage > 1 {
          let indexPathsToReload = self.calculateIndexPathsToReload(from: repoList.items)
          completion(.success(indexPathsToReload))
//        } else {
//          completion(.failure(<#T##AppError#>))
//        }
//
//        let cellViewModels = repoList.items.map { GitHubCellViewModel($0) }
//        completion(.success(cellViewModels))
      case .failure(let appError):
        self.isFetchInProgress = false
        completion(.failure(appError))
      }
    }
  }

  var totalCount: Int {
    return total
  }

  var currentCount: Int {
    return gitHubRepos.count
  }

  func gitHubCellViewModel(at index: Int) -> GitHubCellViewModel? {
    return gitHubRepos.indices.contains(index) ?  gitHubRepos[index] : nil
  }


  private func calculateIndexPathsToReload(from newList: [GitHubRepo]) -> [IndexPath] {
    let startIndex = currentCount - newList.count
    let endIndex = startIndex + newList.count
    return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
  }

}



