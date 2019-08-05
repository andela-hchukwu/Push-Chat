//
//  ViewController.swift
//  Push Chat
//
//  Created by Henry Chukwu on 7/23/19.
//  Copyright © 2019 Henry Chukwu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var messages = [Message]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self

        User.current.signIn()

        SNSService.shared.configure()

        PersistenceService.shared.getMessages { messages in
            self.messages = messages
            self.tableView.reloadData()
        }

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleNewMessage(_:)),
                                               name: NSNotification.Name("internalNotification.newMessage"),
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleReply(_:)),
                                               name: NSNotification.Name("internalNotification.reply"),
                                               object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if !User.current.isSignedIn() {
            AlertService.signIn(in: self) {
                SNSService.shared.register()
            }
        }
    }

    @IBAction func onComposeTapped() {
        AlertService.composeAlert(in: self) { message in
            print(message)
            self.insert(message)
            SNSService.shared.publish(message)
        }
    }

    func insert(_ message: Message) {
        messages.append(message)

        let indexPath = IndexPath(row: messages.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)

        PersistenceService.shared.save(messages)
    }

    @objc func handleNewMessage(_ sender: Notification) {
        guard let message = sender.object as? Message else { return }
        insert(message)
    }

    @objc func handleReply(_ sender: Notification) {
        guard let reply = sender.object as? String else { return }
        let message = Message(body: reply)
        insert(message)
    }

}

extension ViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell") as? MessageCell
            else { return UITableViewCell() }

        let message = messages[indexPath.row]
        cell.configure(with: message)

        return cell
    }


}
