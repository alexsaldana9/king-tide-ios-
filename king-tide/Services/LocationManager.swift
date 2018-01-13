//
//  LocationManager.swift
//  king-tide
//
//  Created by Erick Barbosa on 1/13/18.
//  Copyright © 2018 Alexandra Saldana. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationServiceDelegate: class {
  func authFailed(with status: CLAuthorizationStatus)
  func authSuccess(with status: CLAuthorizationStatus)
}

class LocationManager: NSObject {

  weak var delegate: LocationServiceDelegate?
  static let shared = LocationManager()
  var manager = CLLocationManager()
  var location: CLLocation?

  init(distanaceFilter: CLLocationAccuracy = kCLLocationAccuracyBest) {
    super.init()
    manager.desiredAccuracy = distanaceFilter
    manager.delegate = self
    manager.startUpdatingLocation()
  }

  func authorize() {

    let status = CLLocationManager.authorizationStatus()
    switch status {
    case .notDetermined:
      manager.requestAlwaysAuthorization()
    case .authorizedAlways, .authorizedWhenInUse:
      delegate?.authSuccess(with: status)
    case .restricted, .denied:
      delegate?.authFailed(with: status)
    }

  }

  func isAuthorized() -> Bool {
    let status = CLLocationManager.authorizationStatus()
    switch status {
    case .notDetermined, .restricted, .denied:
      return false
    case .authorizedAlways, .authorizedWhenInUse:
      return true
    }
  }
}
extension LocationManager: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager,
                       didUpdateLocations locations: [CLLocation]) {
    self.location = locations.first
  }
}
