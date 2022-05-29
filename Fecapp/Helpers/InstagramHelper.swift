//
//  InstagramHelper.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 29/05/2022.
//

import Foundation
import UIKit

class InstagramHelper {
    static func openInstagram(username: String) {
        let appURL = URL(string: "instagram://user?username=\(username)")!
        let application = UIApplication.shared

        if application.canOpenURL(appURL) {
            application.open(appURL)
        } else {
            // if Instagram app is not installed, open URL inside Safari
            let webURL = URL(string: "https://instagram.com/\(username)")!
            application.open(webURL)
        }
    }
}
