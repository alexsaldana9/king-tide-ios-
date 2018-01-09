//
//  ViewController.swift
//  king-tide
//
//  Created by Alexandra Saldana on 11/21/17.
//  Copyright © 2017 Alexandra Saldana. All rights reserved.
//

import UIKit
import CoreLocation

class TideViewCotroller: UIViewController,CLLocationManagerDelegate {

  @IBOutlet weak var depthTextField: UITextField!
  @IBOutlet weak var salinityTextField: UITextField!
  @IBOutlet weak var descriptionTextField: UITextField!

  @IBOutlet weak var feetMesuramentControl: UISegmentedControl!
  @IBOutlet weak var salinityMesuramentControl: UISegmentedControl!


  let locationManager = CLLocationManager()
  var location: CLLocation?

  override func viewDidLoad() {
    super.viewDidLoad()

    NotificationCenter.default.addObserver(self, selector: #selector(self.clear(notification:)), name: Notification.Name.postSuccess, object: nil)

    locationManager.requestWhenInUseAuthorization()

    if CLLocationManager.locationServicesEnabled() {
      locationManager.delegate = self
      locationManager.desiredAccuracy = kCLLocationAccuracyBest
      locationManager.startUpdatingLocation()
    }
  }
  // Print out the location to the console
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    self.location = locations.first
  }

  // If we have been deined access give the user the option to change it
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    if(status == CLAuthorizationStatus.denied) {
      //show map so the user can pin location on the map
    }
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

    let mesurament = feetMesuramentControl
      .isEnabledForSegment(at: 0) ? "feet": "inches"

    let mesuramentSalinity = salinityMesuramentControl
      .isEnabledForSegment(at: 0) ? "ppm": "ppt"

    let latitude = location?.coordinate.latitude ?? 0
    let longitude = location?.coordinate.longitude ?? 0
    let param = [
      "depth": "\(depth)",
      "salinity": "\(salinity)",
      "units_depth": mesurament,
      "units_salinity": mesuramentSalinity,
      "latitude": "\(latitude)",
      "longitude": "\(longitude)",
      "description": description
      ] as [String : String]

    DispatchQueue.main.async {
      ApiRequest.post(param: param)
    }

  }

}

