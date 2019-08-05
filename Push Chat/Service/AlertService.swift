//
//  AlertService.swift
//  Push Chat
//
//  Created by Henry Chukwu on 7/23/19.
//  Copyright © 2019 Henry Chukwu. All rights reserved.
//

import UIKit

class AlertService {

    private init() {}

    static func signIn(in vc: UIViewController, completion: @escaping () -> Void) {
        let alert = UIAlertController(title: "Sign in", message: nil, preferredStyle: .alert)
        alert.addTextField { usernametF in
            usernametF.placeholder = "Enter your username"
        }
        let signin = UIAlertAction(title: "Sign in", style: .default) { _ in
            guard let username = alert.textFields?.first?.text else { return }
            User.current.username = username
            completion()
        }
        alert.addAction(signin)
        vc.present(alert, animated: true)
    }

    static func composeAlert(in vc: UIViewController, completion: @escaping (Message) -> Void) {
        let alert = UIAlertController(title: "Compose Message", message: "What is on your mind?", preferredStyle: .alert)
        alert.addTextField { (messageBodyTF) in
            messageBodyTF.placeholder = "Enter message"
        }
        let send = UIAlertAction(title: "Send", style: .default) { _ in
            guard let messageBody = alert.textFields?.first?.text else { return }
            let message = Message(body: messageBody)
            completion(message)
        }
        alert.addAction(send)
        vc.present(alert, animated: true)

    }
}
