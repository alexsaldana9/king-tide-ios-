//
//  PostPhoto.swift
//  king-tide
//
//  Created by Erick Barbosa on 1/13/18.
//  Copyright © 2018 Alexandra Saldana. All rights reserved.
//

import Foundation

class PostPhoto: Base {

  
  func uploadPhoto(photoData: Data, id: Int,category: Int) {

    let url = URL(string: "\(baseUrlString)photos/")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    let body: [String:String] = ["reading_id":"\(id)","category":"\(category)","image":photoData.base64EncodedString()]
    request.setValue("multipart/form-data", forHTTPHeaderField: "Content-Type")
    //request.addValue("application/json", forHTTPHeaderField: "Accept")

    //    do {
    //      request.httpBody = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
    //    } catch {
    //      print("json error")
    //    }


    request.httpBody = encodeParameters(parameters: body).data(using: .utf8)

    let task = session.dataTask(with: request) { data, response, error in
      
      let success = Notification.Name.Photo.success
      let fail = Notification.Name.Photo.fail

      if self.isValidResponse(response: response!){
        NotificationCenter.default.post(name: success, object: nil)
      } else {
        NotificationCenter.default.post(name: fail, object: nil)
      }
    }

    task.resume()
  }

}
