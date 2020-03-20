//
//  Coordinator.swift
//  Github-repo-search
//
//  Created by Suman Chatterjee on 12/03/2020.
//  Copyright © 2020 Suman Chatterjee. All rights reserved.
//

import Foundation
import UIKit

protocol Coordinator {
  func start()
}

final class ApplicationCoordinator:Coordinator {
  private let presenter:UINavigationController
  private let window:UIWindow
  
  init(_ window:UIWindow) {
    self.window = window
    self.presenter = UINavigationController()
    self.window.rootViewController = self.presenter
  }
  
  func start() {
    let vc = GitHubRepoListTableViewController()
    let vm = GitHubListViewModel()
    vc.viewModel = vm
    presenter.pushViewController(vc, animated: false)
    window.makeKeyAndVisible()
  }
  
}
