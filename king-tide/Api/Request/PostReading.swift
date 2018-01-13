//
//  PostReading.swift
//  king-tide
//
//  Created by Erick Barbosa on 1/13/18.
//  Copyright © 2018 Alexandra Saldana. All rights reserved.
//

import Foundation

class PostReading: Base {


  internal func post(param: [String: String])  {

    let url = URL(string: "\(baseUrlString)readings/")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"

    request.httpBody = encodeParameters(parameters: param).data(using: .utf8)

    let task = session.dataTask(with: request) { data, response, error in
      guard let data = data, error == nil else {
        print(error?.localizedDescription ?? "No data")
        return 
      }
      let success = Notification.Name.Readings.success
      let fail = Notification.Name.Readings.fail

      if self.isValidResponse(response: response!){
        ReadingResponse.shared.tideModel = TideResponse.init(data: data)
        NotificationCenter.default.post(name: success, object: nil)
      } else {
        NotificationCenter.default.post(name: fail, object: nil)
      }

    }

    task.resume()
  }

}


