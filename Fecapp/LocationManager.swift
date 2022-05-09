//
//  LocationManager.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 08/05/2022.
//

import Foundation
import Combine
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    @Published var lastLocation: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus?

    let locationManager = CLLocationManager()

    override init() {
        super.init()
        locationManager.delegate = self
    }

    func requestAuthorization() {
        locationManager.requestAlwaysAuthorization()
    }

    func requestLocation() {
        LogService.info("Request location")
        locationManager.requestLocation()
    }

    func fetchAuthorizationStatus() -> CLAuthorizationStatus {
        guard let authorizationStatus = authorizationStatus else {
            return locationManager.authorizationStatus
        }

        return authorizationStatus
    }

    // MARK: - CLLocationManagerDelegate
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        LogService.info("Location changed")
        lastLocation = locations.first
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        LogService.logError(error)
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {

        authorizationStatus = status

        switch status {
        case .notDetermined, .restricted, .denied:
            break

        case .authorizedAlways, .authorizedWhenInUse, .authorized:
            locationManager.requestLocation()

        @unknown default:
            assertionFailure("@unknown default")
        }
    }
}
