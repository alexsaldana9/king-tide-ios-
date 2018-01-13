//
//  Base.swift
//  king-tide
//
//  Created by Erick Barbosa on 1/13/18.
//  Copyright © 2018 Alexandra Saldana. All rights reserved.
//

import Foundation

class Base {
  internal let baseUrlString = "https://mighty-inlet-65561.herokuapp.com/"

  lazy var session: URLSession = {
    let config = URLSessionConfiguration.default
    config.allowsCellularAccess = true
    config.waitsForConnectivity = true
    config.timeoutIntervalForRequest = 40
    config.httpAdditionalHeaders = ["apikey" : ApiKey.key]
    return URLSession(configuration: config)
  }()

  func validate(data: Data?,error: Error?) -> Data? {
    guard let data = data, error == nil else {
      print(error?.localizedDescription ?? "No data")
      return nil
    }
    return data

  }
  func isValidResponse(response: URLResponse) -> Bool {
    print(response)
    if let response = response as? HTTPURLResponse {
      if response.statusCode == 200 {
        return true
      }
    }
    return false
  }

   func encodeParameters(parameters: [String: String]) -> String {

    let parameterArray = parameters.map { (arg) -> String in
      let (key, value) = arg
      return "\(key)=\(value)"
    }

    return parameterArray.joined(separator: "&")
  }


}
