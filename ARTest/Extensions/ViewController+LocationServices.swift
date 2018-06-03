//
//  ViewController+LocationServices.swift
//  ARTest
//
//  Functions related to getting user location
//
//  Created by Victor Hao on 6/2/18.
//  Copyright © 2018 Victor Hao. All rights reserved.
//

import UIKit
import ARCL
import CoreLocation

extension ViewController: CLLocationManagerDelegate {
    
    func startReceivingLocationChanges() {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if authorizationStatus != .authorizedWhenInUse && authorizationStatus != .authorizedAlways {
            // User has not authorized access to location information.
            return
        }
        // Do not start services that aren't available.
        if !CLLocationManager.locationServicesEnabled() {
            // Location services is not available.
            return
        }
        // Configure and start the service.
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // Need to update frequently
        locationManager.distanceFilter = 3  // In meters.
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        // Heading settings
        locationManager.headingFilter = 10
        locationManager.startUpdatingHeading()
        getNearbyObjectInfo()
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted, .denied:
            // user did not all location services
            startReceivingLocationChanges()
            break
            
        case .authorizedWhenInUse:
            startReceivingLocationChanges()
            break
            
        case .notDetermined, .authorizedAlways:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager,  didUpdateLocations locations: [CLLocation]) {
        let lastLocation = locations.last!
        
        // update a class variable which stores the most recent location for immediate use
        currentLocation = lastLocation
        getNearbyObjectInfo()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let error = error as? CLError, error.code == .denied {
            // Location updates are not authorized.
            manager.stopUpdatingLocation()
            return
        }
        // Notify the user of any errors.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        currentHeading = newHeading
    }
    
}
