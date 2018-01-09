//
//  Request.swift
//  king-tide
//
//  Created by Erick Barbosa on 12/9/17.
//  Copyright © 2017 Alexandra Saldana. All rights reserved.
//

import Foundation


class PostRequest {
   private static  func encodeParameters(parameters: [String: String]) -> String {
    let parameterArray = parameters.map { (arg) -> String in
        
        let (key, value) = arg
        return "\(key)=\(value)"
        }
        
        return parameterArray.joined(separator: "&")
    }

  static func post(param: [String: String])  {

    //configuration
    let config = URLSessionConfiguration.default
    config.allowsCellularAccess = true
    config.waitsForConnectivity = true
    config.timeoutIntervalForRequest = 40
    config.httpAdditionalHeaders = ["apikey" : "supersecret"]
    let defaultSession = URLSession(configuration: config)


    // create post request
    let url = URL(string: "https://mighty-inlet-65561.herokuapp.com/readings/")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    
//"depth=\(4)&salinity=\(45)&units_depth=feet&units_salinity=ppm&description=ok".data(using: .utf8)
    request.httpBody = encodeParameters(parameters: param).data(using: .utf8)

    let task = defaultSession.dataTask(with: request) { data, response, error in
      guard let data = data, error == nil else {
        print(error?.localizedDescription ?? "No data")
        NotificationCenter.default.post(name: Notification.Name.postFail, object: nil)
        return
      }
      if let response = response as? HTTPURLResponse {
        print(response)
        NotificationCenter.default.post(name: Notification.Name.postSuccess, object: nil)
      }

      //      let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
      //      if let responseJSON = responseJSON as? [String: Any] {
      //        print(responseJSON)
      //        NotificationCenter.default.post(name: Notification.Name.postSuccess, object: nil)
      //      }
    }

    task.resume()
  }

}
