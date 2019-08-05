//
//  UNService.swift
//  Push Chat
//
//  Created by Henry Chukwu on 7/30/19.
//  Copyright © 2019 Henry Chukwu. All rights reserved.
//

import UIKit
import UserNotifications

class UNService: NSObject {

    private override init() {}

    static let shared = UNService()
    let unCenter = UNUserNotificationCenter.current()

    func authorize() {
        let options: UNAuthorizationOptions = [.sound, .badge, .carPlay, .alert]
        unCenter.requestAuthorization(options: options) { (granted, error) in
            print(error ?? "no unauthorization error")
            guard granted else { return }

            DispatchQueue.main.async {
                self.configure()
            }
        }
    }

    func configure() {
        unCenter.delegate = self

        let application = UIApplication.shared
        application.registerForRemoteNotifications()

        setupActionsAndCategories()
    }

    func setupActionsAndCategories() {
        let replyAction = UNTextInputNotificationAction(identifier: NotificationActionID.reply.rawValue,
                                                        title: "Reply",
                                                        options: .authenticationRequired,
                                                        textInputButtonTitle: "Send",
                                                        textInputPlaceholder: "Enter message")

        let replyCategory = UNNotificationCategory(identifier: NotificationCategoryID.reply.rawValue,
                                                   actions: [replyAction],
                                                   intentIdentifiers: [],
                                                   options: [])

        unCenter.setNotificationCategories([replyCategory])
    }
}

extension UNService: UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {

        print("open notification settings")

    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("un did receive noitification")

        if let message = Message(userInfo: response.notification.request.content.userInfo) {
            print(message)
            post(message)
        }

        if NotificationActionID(rawValue: response.actionIdentifier) == .reply {
            postReply(from: response)
        }

        completionHandler()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("un will receive notification")

        let userInfo = notification.request.content.userInfo
        if let message = Message(userInfo: userInfo),
            message.sender != User.current.username {
            print(message)
            post(message)
        }

        completionHandler([])
    }

    func post(_ message: Message) {
        NotificationCenter.default.post(name: NSNotification.Name("internalNotification.newMessage"), object: message)
    }

    func postReply(from response: UNNotificationResponse) {
        guard let textResponse = response as? UNTextInputNotificationResponse else { return }
        let reply = textResponse.userText
        NotificationCenter.default.post(name: NSNotification.Name("internalNotification.reply"), object: reply)
    }

}
