//
//  RequestBuilder.swift
//  Github-repo-search
//
//  Created by Suman Chatterjee on 11/03/2020.
//  Copyright © 2020 Suman Chatterjee. All rights reserved.
//

import Foundation

enum ApiType:String {
  case search = "search/repositories"
  case image = "u"
}

let baseUrl = URL(string:"https://api.github.com")

protocol Requestable {
  var baseUrl:URL { get }
  var parameters:[String:String] {get set}
  var timeOutValue:TimeInterval { get }
  func buildRequest(_ apiType:ApiType?,Method:String) -> URLRequest?
}

final class RequestBuilder:Requestable {
  let baseUrl: URL
  var parameters: [String : String]
  let timeOutValue: TimeInterval
  
  init(baseUrl:URL,params:[String:String] = [:], timeInterval:TimeInterval = 30) {
    self.baseUrl = baseUrl
    self.parameters = params
    self.timeOutValue = timeInterval
  }
  
  func buildRequest(_ apiType: ApiType? = nil, Method: String = "GET") -> URLRequest? {
    
    let url = apiType != nil ? baseUrl.appendingPathComponent(apiType?.rawValue ?? ""): baseUrl
    guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return nil }
    let queryItems = parameters.compactMap { URLQueryItem(name: $0.key, value: $0.value) }
    
    if !queryItems.isEmpty {
      components.queryItems = queryItems
    }
    guard let finalUrl = components.url else { return nil }
    return URLRequest(url: finalUrl , cachePolicy: .useProtocolCachePolicy, timeoutInterval: timeOutValue)
  }
  
  
}
