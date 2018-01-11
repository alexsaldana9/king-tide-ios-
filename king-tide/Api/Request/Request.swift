//
//  Request.swift
//  king-tide
//
//  Created by Erick Barbosa on 12/9/17.
//  Copyright © 2017 Alexandra Saldana. All rights reserved.
//

import Foundation


class ApiRequest {

  internal let baseUrlString = "https://mighty-inlet-65561.herokuapp.com/"

  lazy private var session: URLSession = {
    let config = URLSessionConfiguration.default
    config.allowsCellularAccess = true
    config.waitsForConnectivity = true
    config.timeoutIntervalForRequest = 40
    config.httpAdditionalHeaders = ["apikey" : ApiKey.key]
    return URLSession(configuration: config)
  }()

  func validate(data: Data?,response: URLResponse?,error: Error?,
                notification: (success:Notification.Name,fail: Notification.Name)) {
    guard let data = data, error == nil else {
      print(error?.localizedDescription ?? "No data")
      NotificationCenter.default.post(name: notification.fail, object: nil)
      return
    }

//    let jsonStr = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
//    print(jsonStr)

    if let response = response as? HTTPURLResponse {
      if response.statusCode == 200 {
        let tideModel = TideResponse.init(data: data)
        print(tideModel)
        NotificationCenter.default.post(name: notification.success, object: nil)
      }

    }

  }
  func uploadPhoto(photoData: Data) {
    let url = URL(string: "\(baseUrlString)readings/id/photo")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"

    let task = session.uploadTask(with: request, from: photoData) { (data, response, error) in
      let success = Notification.Name.Photo.success
      let fail = Notification.Name.Photo.fail
      self.validate(data: data, response: response, error: error, notification:(success,fail) )

    }

    task.resume()
  }

  private func encodeParameters(parameters: [String: String]) -> String {

    let parameterArray = parameters.map { (arg) -> String in
      let (key, value) = arg
      return "\(key)=\(value)"
    }

    return parameterArray.joined(separator: "&")
  }

  internal func post(param: [String: String])  {

    // create post request
    let url = URL(string: "\(baseUrlString)readings/")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    
    request.httpBody = encodeParameters(parameters: param).data(using: .utf8)

    let task = session.dataTask(with: request) { data, response, error in
      let success = Notification.Name.Readings.success
      let fail = Notification.Name.Readings.fail
      self.validate(data: data, response: response, error: error, notification:(success,fail) )

    }

    task.resume()
  }

}
