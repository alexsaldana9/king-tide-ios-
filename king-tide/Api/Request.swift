//
//  Request.swift
//  king-tide
//
//  Created by Erick Barbosa on 12/9/17.
//  Copyright © 2017 Alexandra Saldana. All rights reserved.
//

import Foundation


class PostRequest {

 static func post(param: [String: Any])  {

    let jsonData = try? JSONSerialization.data(withJSONObject: param)

    // create post request
    let url = URL(string: "https://localhost:3000/readings/all")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"

    // insert json data to the request
    request.httpBody = jsonData

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      guard let data = data, error == nil else {
        print(error?.localizedDescription ?? "No data")
         NotificationCenter.default.post(name: Notification.Name.postFail, object: nil)
        return
      }

      let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
      if let responseJSON = responseJSON as? [String: Any] {
        print(responseJSON)
        NotificationCenter.default.post(name: Notification.Name.postSuccess, object: nil)
      }
    }

    task.resume()
  }

}
