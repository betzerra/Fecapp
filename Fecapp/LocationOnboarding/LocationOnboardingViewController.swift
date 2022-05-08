//
//  LocationOnboardingViewController.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 08/05/2022.
//

import Foundation
import UIKit

class LocationOnboardingViewController: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    override func loadView() {
        super.loadView()
        view = LocationOnboardingView(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
