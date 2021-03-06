//
//  MenuOptionsDataSource.swift
//  TweetsCounter
//
//  Created by Patrick Balestra on 2/5/16.
//  Copyright © 2016 Patrick Balestra. All rights reserved.
//

import UIKit

struct Option {
    let image: String
    let title: String
}

enum MenuOptions: Int {
    case Refresh
    case Logout
    case Settings
}

final class MenuOptionsDataSource {
    
    var options: [Option]
    
    init () {
        self.options = [Option(image: "refresh", title: "Refresh"),
                        Option(image: "logout", title: "Logout"),
                        Option(image: "settings", title: "Settings")]
    }
}
