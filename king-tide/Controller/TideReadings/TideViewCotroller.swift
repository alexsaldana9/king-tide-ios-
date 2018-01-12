//
//  ViewController.swift
//  king-tide
//
//  Created by Alexandra Saldana on 11/21/17.
//  Copyright © 2017 Alexandra Saldana. All rights reserved.
//

import UIKit
import CoreLocation
import Photos

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
    self.view.addGestureRecognizer(
      UITapGestureRecognizer(target: self.view,
                             action: #selector(UIView.endEditing(_:))))

    NotificationCenter.default.addObserver(self, selector:
      #selector(self.clear(notification:)), name:
      Notification.Name.Readings.success, object: nil)

    locationManager.requestWhenInUseAuthorization()


    if CLLocationManager.locationServicesEnabled() {
      locationManager.delegate = self
      locationManager.desiredAccuracy = kCLLocationAccuracyBest
      locationManager.startUpdatingLocation()
    }
  }


  func locationManager(_ manager: CLLocationManager,
                       didUpdateLocations locations: [CLLocation]) {
    self.location = locations.first
  }

  //  func locationManager(_ manager: CLLocationManager,
  //                       didChangeAuthorization status: CLAuthorizationStatus) {
  //    if(status == CLAuthorizationStatus.denied) {
  //      //show map so the user can pin location on the map
  //    }
  //  }


  @objc func clear(notification: Notification) {

    DispatchQueue.main.async {
      self.depthTextField.text = nil
      self.salinityTextField.text = nil
      self.descriptionTextField.text = "take pic"// remove
    }

  }

  @IBAction func submitBtn(_ sender: Any) {

    guard let param = getParam() else { return }

    if isAuthorized() {

      ApiRequest().post(param: param)

      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      let controller = storyboard.instantiateViewController(
        withIdentifier :"TakePicture") as! TakePicture
      self.present(controller, animated: true)

    } else {
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      let controller = storyboard.instantiateViewController(
        withIdentifier :"MapLocation") as! MapLocation
      controller.param = param
      self.present(controller, animated: true)
    }

  }
  func getParam() -> [String:String]? {
    guard let depth = Float(depthTextField.text!) else { return  nil}
    guard let salinity = Int(salinityTextField.text!) else { return nil }

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
    ]
    return param
  }
  func isAuthorized() -> Bool {

    if CLLocationManager.locationServicesEnabled() {
      switch CLLocationManager.authorizationStatus() {
      case .notDetermined, .restricted, .denied:
        return false
      case .authorizedAlways, .authorizedWhenInUse:
        return true
      }
    }
    return false
  }


}
