//
//  Tweets.swift
//  TweetsCounter
//
//  Created by Patrick Balestra on 12/1/15.
//  Copyright © 2015 Patrick Balestra. All rights reserved.
//

import Foundation
import TwitterKit

enum TwitterRequestError: ErrorType {
    case NotAuthenticated
    case Unknown
}

final class TwitterSession {
    
    var client: TWTRAPIClient?
    var user: TWTRUser?
    
    ///  Check the session user ID to see if there is an user logged in.
    func isUserLoggedIn() throws -> String {
        if let userID = Twitter.sharedInstance().sessionStore.session()?.userID {
            client = TWTRAPIClient(userID: userID)
            return userID
        } else {
            throw TwitterRequestError.NotAuthenticated
        }
    }
}