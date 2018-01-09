//
//  ViewController.swift
//  king-tide
//
//  Created by Alexandra Saldana on 11/21/17.
//  Copyright © 2017 Alexandra Saldana. All rights reserved.
//

import UIKit

class TideViewCotroller: UIViewController {

  @IBOutlet weak var depthTextField: UITextField!
  @IBOutlet weak var salinityTextField: UITextField!
  @IBOutlet weak var descriptionTextField: UITextField!

  @IBOutlet weak var feetMesuramentControl: UISegmentedControl!
  @IBOutlet weak var salinityMesuramentControl: UISegmentedControl!


  override func viewDidLoad() {
    super.viewDidLoad()

    NotificationCenter.default.addObserver(self, selector: #selector(self.clear(notification:)), name: Notification.Name.postSuccess, object: nil)
  }
  @objc func clear(notification: Notification) {

    DispatchQueue.main.async {
      self.depthTextField.text = nil
      self.salinityTextField.text = nil
      self.descriptionTextField.text = nil
    }


  }


  @IBAction func submitBtn(_ sender: Any) {

    guard let depth = Float(depthTextField.text!) else { return  }
    guard let salinity = Int(salinityTextField.text!) else { return  }

    let description = descriptionTextField.text ?? " "

    let mesurament = feetMesuramentControl.isEnabledForSegment(at: 0) ? "feet": "inches"
    let mesuramentSalinity = salinityMesuramentControl.isEnabledForSegment(at: 0) ? "ppm": "ppt"

    print("\(depth) \(salinity) \(description) \(mesurament)\(mesuramentSalinity)")


    let para = [
        "depth": "\(depth)",
        "salinity": "\(salinity)",
        "units_depth": mesurament,
        "units_salinity": mesuramentSalinity,
        "latitude": "13",
        "longitude": "45",
        "description": description
        ] as [String : String]

    DispatchQueue.main.async {
      PostRequest.post(param: para)
    }


  }



}

