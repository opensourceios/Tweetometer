//
//  FabricSetUp.swift
//  TweetsCounter
//
//  Created by Patrick Balestra on 2/27/16.
//  Copyright © 2016 Patrick Balestra. All rights reserved.
//

import UIKit
import SafariServices

class LinkOpener {
    
    /// Store preferred user client from the settings
    var client = SettingsManager.sharedManager.preferredTwitterClient
    /// User detail coordinator needed to present a SafariViewController on the current view controller
    var coordinator: UserDetailCoordinator?
    /// Describes the URL Scheme components
    var urlComponents = NSURLComponents()
    
    /// Opens the a Twitter user in the default client.
    ///
    /// - parameter user: Screen-name of the user.
    func openUser(user: String) {
        switch client {
        case .Tweetbot:
            urlComponents.scheme = "tweetbot"
            urlComponents.path = "/user_profile/\(user)"
        case .Twitter:
            urlComponents.scheme = "twitter"
            urlComponents.path = "/user?screen_name=\(user)"
        case .Web:
            let url = NSURL(string: "https://www.twitter.com/\(user)")
            if let url = url, let coordinator = coordinator {
                coordinator.presentSafari(url)
                return
            }
        }
                
        // Try to open the URL
        if let stringURL = urlComponents.string?.stringByRemovingPercentEncoding, let url = NSURL(string: stringURL) {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    /// Initializes a Safari view controller object to present in the future.
    ///
    /// - parameter url: URL of the page to load in Safari.
    ///
    /// - returns: The view controller to be used.
    func openInSafari(url: NSURL) -> SFSafariViewController {
        return SFSafariViewController(URL: url)
    }
}