//
//  ElasticUser.swift
//  Elasticswift
//
//  Created by tady on 12/4/14.
//  Copyright (c) 2014 tady. All rights reserved.
//

import Foundation
import Alamofire

class ElasticUser {
    var username: String
    var token: String

    init(username: String, token: String) {
        self.username = username
        self.token = token

        let ud = NSUserDefaults.standardUserDefaults()
        ud.setObject(self.username, forKey: "username")
        ud.setObject(self.token, forKey: "token")
        ud.synchronize()
    }

    class func currentUser() -> ElasticUser? {
        let ud = NSUserDefaults.standardUserDefaults()
        if let username = ud.objectForKey("username") as? String {
            let token = ud.objectForKey("token") as String
            let user = ElasticUser(username: username, token: token)
            println("currentUser = \(username)")
            return user
        } else {
            return nil
        }
    }

    class func logOut() {
        let ud = NSUserDefaults.standardUserDefaults()
        ud.removeObjectForKey("username")
        ud.removeObjectForKey("token")
        ud.synchronize()
    }

    class func signUp(username: String, password: String, block: (user: ElasticUser?) -> Void) {
        let params = [
            "authenticator": "index",
            "username": username,
            "password": password,
            "roles": "[\"user\"]"
        ]

        println("signUp...")

        let res = Alamofire.request(.PUT, "http://localhost:9200/_auth/account", parameters: params, encoding: .JSON)
            .responseJSON { (_, _, json, _) -> Void in
                let sjson = JSON(json!)
                println(sjson["status"])
                if sjson["status"] == 200 {
                    self.logIn(username, password: password, { (user2: ElasticUser?) in
                        block(user: user2)
                    })
                }
        }
    }

    class func logIn(username: String, password: String, block: (user: ElasticUser?) -> Void) {
        let params = [
            "username": username,
            "password": password
        ]

        println("logIn...")

        let res = Alamofire.request(.POST, "http://localhost:9200/login", parameters: params, encoding: .JSON)
            .responseJSON { (_, _, json, _) -> Void in
                let sjson = JSON(json!)
                println(sjson["status"])
                if sjson["status"] == 200 {
                    let user: ElasticUser? = ElasticUser(username: username, token: sjson["token"].string!)
                    block(user: user)
                } else {
                    block(user: nil)
                }
        }
    }


    func signUpInBackgroundWithBlock(block: (success: Bool!, error: NSError!)->Void) {


        block(success: true, error: NSError())
    }
}