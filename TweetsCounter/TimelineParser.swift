//
//  TimelineParser.swift
//  TweetsCounter
//
//  Created by Patrick Balestra on 1/28/16.
//  Copyright © 2016 Patrick Balestra. All rights reserved.
//

import UIKit
import Unbox

enum JSONError: ErrorType {
    case UnknownError
}

public final class TimelineParser {
    
    typealias JSONTweets = [AnyObject]
    
    /// Final timeline object passed to our view model
    var timeline: Timeline?
    
    /// Initializers receiving the JSON array of tweets.
    ///
    /// - parameter jsonTweets: Array of JSON tweets.
    ///
    /// - returns: A class instance.
    init(jsonTweets: JSONTweets) {
        do {
            let tweets = try parseTweets(jsonTweets)
            let users = parseUsersFromTweets(tweets)
            timeline = buildTimelineFromTweets(tweets, users: users)
        } catch {
            
        }
    }
    
    /// Parse JSON array of Tweets to decode them to Tweet objects.
    ///
    /// - parameter jsonTweets: Array of JSON tweets.
    ///
    /// - throws: Error if JSON parsing fails.
    //
    /// - returns: Array of Tweet objects.
    private func parseTweets(jsonTweets: JSONTweets) throws -> [Tweet] {
        var tweets = [Tweet]()
        // Parse JSON tweets to Tweet objects
        for tweet in jsonTweets {
            if let tweet = tweet as? Dictionary<String, AnyObject> {
                do {
                    let tweet: Tweet = try Unbox(tweet)
                    tweets.append(tweet)
                } catch {
                    print("Error in unboxing tweet: \(tweet) with error: \(error)")
                    throw JSONError.UnknownError
                }
            }
        }
        return tweets
    }
    
    /// Creates an array of users from the tweets objects.
    ///
    /// - parameter tweets: All the received tweets.
    ///
    /// - returns: Array containing the authors of tweets.
    private func parseUsersFromTweets(tweets: [Tweet]) -> [User] {
        var users = [User]()
        // Build array of tweet authors
        for tweet in tweets {
            if let a = tweet.author where !users.contains(a) {
                users.append(a)
            }
        }
        return users
    }
    
    /// Merge array of tweets and users to find who has the most tweets.
    ///
    /// - parameter tweets: Array containing tweets.
    /// - parameter users:  Array containing users.
    ///
    /// - returns: A Timeline object containing an array of users.
    private func buildTimelineFromTweets(tweets: [Tweet], users: [User]) -> Timeline {
        // Build list of authors with array of tweets in each user
        var orderedUsers = users.flatMap { (user) -> User? in
            var user = user
            let allTweetsOfUser = tweets.flatMap({ (tweet) -> Tweet? in
                if tweet.author == user {
                    return tweet
                }
                return nil
            })
            user.tweets = allTweetsOfUser
            return user
        }
        
        // Sort users by highest number of tweets
        orderedUsers.sortInPlace { user1, user2 in
            return user1.tweets?.count > user2.tweets?.count
        }
        
        let timeline = Timeline(users: orderedUsers)
        return timeline
    }
}
