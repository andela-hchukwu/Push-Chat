//
//  SNSService.swift
//  Push Chat
//
//  Created by Henry Chukwu on 7/30/19.
//  Copyright © 2019 Henry Chukwu. All rights reserved.
//

import Foundation
import AWSSNS

class SNSService {

    private init() {}
    static let shared = SNSService()

    let topicArn = ""

    func configure() {
        let credentialsProvider = AWSStaticCredentialsProvider(accessKey: "",
                                                               secretKey: "")
        let serviceConfiguration = AWSServiceConfiguration(region: .usWest1,
                                                           credentialsProvider: credentialsProvider)

        AWSServiceManager.default()?.defaultServiceConfiguration = serviceConfiguration
    }

    func register() {
        let arn = ""

        guard let platformEndpointRequest = AWSSNSCreatePlatformEndpointInput() else { return }
        platformEndpointRequest.customUserData = User.current.username
        platformEndpointRequest.token = User.current.token
        platformEndpointRequest.platformApplicationArn = arn

        AWSSNS.default().createPlatformEndpoint(platformEndpointRequest).continue ({ (task) -> Any? in
            guard let endpoint = task.result?.endpointArn else { return nil }
            print(endpoint)
            self.subscribe(to: endpoint)
            return nil
        })
    }

    func subscribe(to endpoint: String) {
        guard let subscribeRequest = AWSSNSSubscribeInput() else { return }
        subscribeRequest.topicArn = topicArn
        subscribeRequest.protocols = "application"
        subscribeRequest.endpoint = endpoint

        AWSSNS.default().subscribe(subscribeRequest).continue ({ (task) -> Any? in
            print(task.error ?? "successfully subscribed")
            return nil
        })

    }

    func publish(_ message: Message) {
        guard let publishRequest = AWSSNSPublishInput() else { return }
        publishRequest.messageStructure = "json"

        let dict = ["default": message.body,
                    "APNS_SANDBOX": "{\"aps\":{\"alert\": {\"title\":\"\(message.sender)\", \"body\": \"\(message.body)\"}, \"sound\":\"default\", \"category\":\"\(NotificationCategoryID.reply.rawValue)\"} }"]

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: [])
            publishRequest.message = String(data: jsonData, encoding: .utf8)
            publishRequest.topicArn = topicArn

            AWSSNS.default().publish(publishRequest).continue ({ (task) -> Any? in
                print(task.error ?? "Publish message")

                return nil
            })
        } catch {
            print(error)
        }
    }
}
