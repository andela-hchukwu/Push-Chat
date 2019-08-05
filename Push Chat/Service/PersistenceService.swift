//
//  PersistenceService.swift
//  Push Chat
//
//  Created by Henry Chukwu on 7/23/19.
//  Copyright © 2019 Henry Chukwu. All rights reserved.
//

import Foundation

class PersistenceService {

    private init() {}
    static let shared = PersistenceService()
    let userDefaults = UserDefaults.standard

    func save(_ messages: [Message]) {
        var dictArray = [[String: String]]()

        for message in messages {
            dictArray.append(message.dictionaryRepresentation())
        }

        userDefaults.set(dictArray, forKey: "messages")
    }

    func getMessages(completion: @escaping ([Message]) -> Void) {
        guard let dictArray = userDefaults.array(forKey: "messages") as? [[String: String]] else { return }

        var messages = [Message]()

        for dict in dictArray {
            guard let message = Message(dict: dict) else { continue }
            messages.append(message)
        }

        DispatchQueue.main.async {
            completion(messages)
        }
    }
}
