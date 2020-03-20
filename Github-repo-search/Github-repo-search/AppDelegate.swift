//
//  AppDelegate.swift
//  Github-repo-search
//
//  Created by Suman Chatterjee on 16/01/2020.
//  Copyright © 2020 Suman Chatterjee. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {


  var window: UIWindow?
  var coordinator:Coordinator?
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    let window = UIWindow(frame: UIScreen.main.bounds)
    self.window = window
    coordinator = ApplicationCoordinator(window)
    coordinator?.start()
    return true
  }
}

