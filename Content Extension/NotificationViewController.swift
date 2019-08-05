//
//  NotificationViewController.swift
//  Content Extension
//
//  Created by Henry Chukwu on 8/5/19.
//  Copyright © 2019 Henry Chukwu. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet weak var tableView: UITableView!

    var messages = [Message]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
    }
    
    func didReceive(_ notification: UNNotification) {
        let userinfo = notification.request.content.userInfo
        guard let message = Message(userInfo: userinfo) else { return }
        messages.append(message)
        tableView.reloadData()
    }

}

extension NotificationViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell") as? MessageCell else { return UITableViewCell() }

        let message = messages[indexPath.row]
        cell.configure(with: message)

        return cell
    }


}
