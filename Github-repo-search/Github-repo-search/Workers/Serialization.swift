//
//  Serialization.swift
//  Github-repo-search
//
//  Created by Suman Chatterjee on 11/03/2020.
//  Copyright © 2020 Suman Chatterjee. All rights reserved.
//

import Foundation

protocol Serializable {
  typealias ResultType = Result<model,Error>
  associatedtype model
  static func parse(_ data:Data) -> ResultType
}


class Serialize<T:Decodable>:Serializable {
  typealias model = T
  
  static func parse(_ data: Data) -> Result<T, Error> {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    do{
      let serializedModel = try decoder.decode(model.self, from: data)
      return .success(serializedModel)
    }catch(let error) {
      return .failure(error)
    }
  }
}
