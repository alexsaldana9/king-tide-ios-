//
//  MapLocation.swift
//  king-tide
//
//  Created by Erick Barbosa on 1/12/18.
//  Copyright © 2018 Alexandra Saldana. All rights reserved.
//

import UIKit
import MapKit

class MapLocation: UIViewController, MKMapViewDelegate {

  @IBOutlet weak var confirmButton: UIButton!
  @IBOutlet weak var mapView: MKMapView!
  var param: [String:String] = [:]
  var annotation = MKPointAnnotation()

  private var initialLocation = CLLocationCoordinate2D(
    latitude: 25.758994654048518, longitude: -80.193096070435473)

  override func viewDidLoad() {
    super.viewDidLoad()

    centerMapOnLocation(location: initialLocation)
    let tapRecognizer = UITapGestureRecognizer(target: self,
                                               action: #selector
                                                (self.handleTap(_:)))

    mapView.addGestureRecognizer(tapRecognizer)
    self.confirmButton.isEnabled = false
    self.confirmButton.alpha = 0.2


  }
  @IBAction func ConfirmTapped(_ sender: UIButton) {
    
    PostReading().post(param: param)

    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let controller = storyboard.instantiateViewController(
      withIdentifier :"TakePicture") as! TakePicture
    self.present(controller, animated: true)
  }
  @objc func handleTap(_ gestureReconizer: UILongPressGestureRecognizer) {

    let location = gestureReconizer.location(in: mapView)
    let coordinate = mapView.convert(location,toCoordinateFrom: mapView)
    mapView.removeAnnotation(annotation)

    annotation.coordinate = coordinate
    mapView.addAnnotation(annotation)
    centerMapOnLocation(location: annotation.coordinate)
  }
  func centerMapOnLocation(location: CLLocationCoordinate2D) {
    self.initialLocation = location
    mapView.setCenter(location, animated: true)
    self.confirmButton.alpha = 1
    self.confirmButton.isEnabled = true
  }


}
