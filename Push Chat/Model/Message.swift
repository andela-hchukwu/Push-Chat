//
//  Message.swift
//  Push Chat
//
//  Created by Henry Chukwu on 7/23/19.
//  Copyright © 2019 Henry Chukwu. All rights reserved.
//

import Foundation

struct Message{
    private(set) var sender: String = User.current.username
    let body: String

    init(body: String) {
        self.body = body
    }

    init?(dict: [String: String]) {
        guard let sender = dict["sender"],
            let body = dict["body"]
            else { return nil }

        self.sender = sender
        self.body = body
    }

    init?(userInfo: [AnyHashable: Any]) {
        guard let aps = userInfo["aps"] as? [String: Any],
            let alert = aps["alert"] as? [String: Any],
            let sender = alert["title"] as? String,
            let body = alert["body"] as? String
            else { return nil }

        self.sender = sender
        self.body = body
    }

    func dictionaryRepresentation() -> [String: String] {
        let dict: [String: String] = ["sender": sender,
                                      "body": body]

        return dict
    }
}
