//
//  GitHubRepoListTableViewController.swift
//  Github-repo-search
//
//  Created by Suman Chatterjee on 11/03/2020.
//  Copyright © 2020 Suman Chatterjee. All rights reserved.
//

import UIKit

let identifier = "cellId"
class GitHubRepoListTableViewController: UITableViewController, AlertDisplayer {

  var viewModel: GitHubListViewModelUseCase!
//  private var cellVMs = [GitHubCellViewModel]()

  override func viewDidLoad() {
    super.viewDidLoad()
    setupCellVMs()
  }

  private func setupCellVMs() {
    tableView.register(GitHubRepoListCell.self, forCellReuseIdentifier: identifier)
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 150
    tableView.prefetchDataSource = self
    tableView.tableFooterView = UIView()
    getSearchData()
  }

  private func getSearchData() {
    viewModel.getGitHubSearchData { (result) in
      switch result {
      case .success(let newIndexPathsToReload):
        guard let newIndexPathsToReload = newIndexPathsToReload else {
          self.tableView.reloadData()
          return
        }
//        let indexPathsToReload = self.visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
//        self.tableView.reloadRows(at: indexPathsToReload, with: .automatic)
        if self.viewModel.currentPage > 1 {
          let indexPathsToReload = self.visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
          self.tableView.reloadRows(at: indexPathsToReload, with: .automatic)
        } else {
          self.tableView.reloadData()
        }

      case .failure(let apperror):
        print(apperror.localizedDescription)
//        let title = "Warning"
//        let action = UIAlertAction(title: "OK", style: .default)
//        self.displayAlert(with: title, message: apperror.localizedDescription, actions: [action])
      }
    }
  }


  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.totalCount
  }


  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? GitHubRepoListCell else { return UITableViewCell() }
    if let cellDetail = viewModel.gitHubCellViewModel(at: indexPath.row) {
      cell.configureCell(cellDetail)
    }

    return cell
  }

  /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

  /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

  /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

  /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

}

extension GitHubRepoListTableViewController: UITableViewDataSourcePrefetching {
  func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
    if indexPaths.contains(where: isLoadingCell) {
      getSearchData()
    }
  }
}


private extension GitHubRepoListTableViewController {
  func isLoadingCell(for indexPath: IndexPath) -> Bool {
    return indexPath.row >= viewModel.currentCount
  }

  func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
    let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
    let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
    return Array(indexPathsIntersection)
  }
}
