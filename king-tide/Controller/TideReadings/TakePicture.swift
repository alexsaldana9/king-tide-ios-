//
//  TakePicture.swift
//  king-tide
//
//  Created by Erick Barbosa on 1/12/18.
//  Copyright © 2018 Alexandra Saldana. All rights reserved.
//

import UIKit
import Photos

class TakePicture: UIViewController {

  let imagePicker = UIImagePickerController()
  @IBOutlet weak var takePicButton: UIButton!


  override func viewDidLoad() {
    super.viewDidLoad()
    imagePicker.delegate = self
  }

  
  @IBAction func takePicTapped(_ sender: UIButton) {
    let alert = UIAlertController(title: "Title",
                                  message: "Choose your option",
                                  preferredStyle: .actionSheet)

    let camera = UIAlertAction(title: "Camera", style: .default,
                               handler: { (alert) in
                                self.openCamera()
    })
    let gallery = UIAlertAction(title: "Gallery", style: .default,
                                handler: { (alert) in
                                  self.openGallery()
    })

    alert.addAction(camera)
    alert.addAction(gallery)
    self.present(alert, animated: true, completion: nil)
  }

  func openCamera() {
    guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
      print("This device doesn't have a camera.")
      return
    }
    imagePicker.sourceType = .camera
    imagePicker.cameraDevice = .rear
    imagePicker.cameraCaptureMode = .photo

    present(imagePicker, animated: true)
  }

  func openGallery() {
    guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
      print("can't open photo library")
      return
    }
    imagePicker.sourceType = .photoLibrary
    present(imagePicker, animated: true)
  }

}

extension TakePicture: UIImagePickerControllerDelegate,
UINavigationControllerDelegate {

  @objc func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [String : Any]) {
    defer {
      picker.dismiss(animated: true)
    }

    guard let image = info[UIImagePickerControllerOriginalImage]
      as? UIImage else { return }
    let imageData:Data = UIImageJPEGRepresentation(image, 0.7)!
    let id = ApiRequest.tideModel?.id
    let category = 1
    ApiRequest().uploadPhoto(photoData: imageData, id:id!, category: category)
  }

  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    defer { picker.dismiss(animated: true) }
    print("did cancel")
  }
}
