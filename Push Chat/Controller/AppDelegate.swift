//
//  AppDelegate.swift
//  Push Chat
//
//  Created by Henry Chukwu on 7/23/19.
//  Copyright © 2019 Henry Chukwu. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        UNService.shared.authorize()
        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("did register for notifications")

        let token = deviceToken.reduce(""){ $0 + String(format: "%02X", $1) }
        print(token)
        User.current.token = token
    }


}

