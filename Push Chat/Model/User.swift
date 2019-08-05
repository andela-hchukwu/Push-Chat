//
//  User.swift
//  Push Chat
//
//  Created by Henry Chukwu on 7/23/19.
//  Copyright © 2019 Henry Chukwu. All rights reserved.
//

import Foundation

class User {

    private init() {}
    static let current = User()

    var username = "" {
        didSet {
            UserDefaults.standard.set(username, forKey: "username")
        }
    }

    var token = "" {
        didSet {
            UserDefaults.standard.set(token, forKey: "token")
        }
    }

    func signIn() {
        let userDefaults = UserDefaults.standard
        guard let username = userDefaults.string(forKey: "username"),
            let token = userDefaults.string(forKey: "token")
                else { return }

        self.username = username
        self.token = token
    }

    func isSignedIn() -> Bool {
        return UserDefaults.standard.value(forKey: "username") != nil &&
            UserDefaults.standard.value(forKey: "token") != nil
    }
}
