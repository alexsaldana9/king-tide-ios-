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

  let imagePicker = UIImagePickerController()

  let locationManager = CLLocationManager()
  var location: CLLocation?

  override func viewDidLoad() {
    super.viewDidLoad()

    NotificationCenter.default.addObserver(self, selector:
      #selector(self.clear(notification:)), name:
      Notification.Name.postSuccess, object: nil)

    locationManager.requestWhenInUseAuthorization()

    if CLLocationManager.locationServicesEnabled() {
      locationManager.delegate = self
      locationManager.desiredAccuracy = kCLLocationAccuracyBest
      locationManager.startUpdatingLocation()
    }
  }

  @IBAction func takePicButton(_ sender: UIButton) {
    let alertViewController = UIAlertController(title: "", message: "Choose your option", preferredStyle: .actionSheet)
    let camera = UIAlertAction(title: "Camera", style: .default, handler: { (alert) in
      self.openCamera()
    })
    let gallery = UIAlertAction(title: "Gallery", style: .default) { (alert) in
      self.openGallery()
    }
    let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (alert) in

    }
  }
  func openCamera() {
    guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
      print("This device doesn't have a camera.")
      return
    }

    imagePicker.sourceType = .camera
    imagePicker.cameraDevice = .rear
    imagePicker.mediaTypes = UIImagePickerController
      .availableMediaTypes(for:.camera)!
    imagePicker.delegate = self

    present(imagePicker, animated: true)
  }

  func openGallery() {
    guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
      print("can't open photo library")
      return
    }

    imagePicker.sourceType = .photoLibrary
    imagePicker.delegate = self

    present(imagePicker, animated: true)
  }

  func locationManager(_ manager: CLLocationManager,
                       didUpdateLocations locations: [CLLocation]) {
    self.location = locations.first
  }

  func locationManager(_ manager: CLLocationManager,
                       didChangeAuthorization status: CLAuthorizationStatus) {
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
extension TideViewCotroller: UIImagePickerControllerDelegate,
                             UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController,
                             didFinishPickingMediaWithInfo info: [String : Any]) {
    defer {
      picker.dismiss(animated: true)
    }

    print(info)
    // get the image
    guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage
      else { return }
  }

  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    defer { picker.dismiss(animated: true) }
    print("did cancel")
  }
}

