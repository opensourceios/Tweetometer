//
//  Tweet.swift
//  TweetsCounter
//
//  Created by Patrick Balestra on 12/24/15.
//  Copyright © 2015 Patrick Balestra. All rights reserved.
//

import Foundation
import TwitterKit
import Unbox

struct Tweet: Equatable, Hashable, Unboxable {
    
    var tweetID: String
    var createdAt: NSDate
    var text: String
    var language: String
    var screenName: String
    var retweetsCount: Int
    var likesCount: Int
    
    var author: User?
    
    var hashValue: Int {
        get {
            return tweetID.hashValue
        }
    }
    
    init(unboxer: Unboxer) {
        
        let retweeted: Bool = unboxer.unbox("retweeted")
        if retweeted {
            // TODO
            print("Retweeted")
        }
        
        createdAt = unboxer.unbox("created_at", formatter: NSDateFormatter.twitterDateFormatter())
        tweetID =  unboxer.unbox("id_str")
        text = unboxer.unbox("text")
        language = unboxer.unbox("lang")
        
        author = unboxer.unbox("user")
        if let author = author {
            screenName = author.screenName
        } else {
            screenName = ""
            print("Failed to unbox author user with JSON")
        }
        
        retweetsCount = unboxer.unbox("retweet_count")
        likesCount = unboxer.unbox("favorite_count")
    }
    
}

func == (lhs: Tweet, rhs: Tweet) -> Bool {
    return lhs.tweetID == rhs.tweetID
}