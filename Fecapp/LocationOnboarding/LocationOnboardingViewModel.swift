//
//  LocationOnboardingViewModel.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 08/05/2022.
//

import Combine
import Foundation
import UIKit

enum LocationOnboardingViewModelEvents {
    case accept
    case cancel
}

private let symbolPointSize: CGFloat = 64

class LocationOnboardingViewModel {
    let events: AnyPublisher<LocationOnboardingViewModelEvents, Never>
    private let _events = PassthroughSubject<LocationOnboardingViewModelEvents, Never>()

    let image: UIImage? = {
        let symbolConfiguration = UIImage.SymbolConfiguration(
            pointSize: symbolPointSize,
            weight: .medium
        )

        return UIImage(
            systemName: "location.circle",
            withConfiguration: symbolConfiguration
        )
    }()

    var acceptAction: UIAction {
        UIAction { [weak self] _ in
            self?._events.send(.accept)
        }
    }

    var cancelAction: UIAction {
        UIAction { [weak self] _ in
            self?._events.send(.cancel)
        }
    }

    let titleText = "Necesitamos saber tu ubicación"
    let subtitleText = "Para mostrarte cafeterías cerca tuyo, necesitamos saber dónde estás."
    let acceptText = "Continuar"
    let cancelText = "No quiero compartir"

    init() {
        events = _events.eraseToAnyPublisher()
    }
}
