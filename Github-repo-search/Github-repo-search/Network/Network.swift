//
//  Network.swift
//  Github-repo-search
//
//  Created by Suman Chatterjee on 11/03/2020.
//  Copyright © 2020 Suman Chatterjee. All rights reserved.
//

import Foundation


enum AppError: Error {
    case networkError(message: String)
    case dataError(message: String)
    case jsonError(message: String)
}

protocol NetworkUseCase {
  typealias ResultType = Result<Data?,AppError>
  func send(_ baseUrl:URL,type:ApiType?,parameters:[String:String], completion: @escaping(ResultType) -> Void)
}

final class Network : NetworkUseCase {
  func send(_ baseUrl:URL,type:ApiType? = nil,parameters:[String:String] = [:], completion: @escaping (ResultType) -> Void) {
    let requestBuilder = RequestBuilder(baseUrl: baseUrl,params: parameters)
    guard let urlRequest = requestBuilder.buildRequest(type) else { return }
    
    let configaration = URLSessionConfiguration.default
    let session = URLSession(configuration: configaration)
    let task = session.dataTask(with: urlRequest) { (data, response, error) in
      var result:ResultType
      if let error = error {
        result = .failure(.dataError(message: error.localizedDescription))
      }else {
        if let response = response as? HTTPURLResponse , let data = data, 200..<300 ~= response.statusCode {
          
          result = .success(data)
        }else {
          result = .failure(.dataError(message: "Server error"))
        }
      }
      DispatchQueue.main.async {
        completion(result)
      }
    }
    task.resume()
  }
  
  
}
