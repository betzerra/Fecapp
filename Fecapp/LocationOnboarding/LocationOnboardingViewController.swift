//
//  LocationOnboardingViewController.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 08/05/2022.
//

import Combine
import Foundation
import UIKit
import CoreLocation

class LocationOnboardingViewController: UIViewController {
    let viewModel = LocationOnboardingViewModel()
    let locationManager: LocationManager

    var cancellables = [AnyCancellable]()

    init(locationManager: LocationManager) {
        self.locationManager = locationManager
        super.init(nibName: nil, bundle: nil)
    }

    override func loadView() {
        super.loadView()
        view = LocationOnboardingView(viewModel: viewModel)

        viewModel
            .events
            .receive(on: RunLoop.main)
            .sink { [weak self] event in
                switch event {
                case .accept:
                    self?.locationManager.requestAuthorization()

                case .cancel:
                    self?.dismiss(animated: true)
                }
            }
            .store(in: &cancellables)

        locationManager
            .$authorizationStatus
            .receive(on: RunLoop.main)
            .sink { [weak self] status in
                guard let status = status else {
                    return
                }

                switch status {
                case .authorizedAlways, .authorizedWhenInUse:
                    self?.dismiss(animated: true)

                case .denied, .notDetermined, .restricted:
                    break

                @unknown default:
                    assertionFailure("@unknown default")
                }
            }
            .store(in: &cancellables)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
