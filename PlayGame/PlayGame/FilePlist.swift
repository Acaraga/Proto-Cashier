//
//  FilePlist.swift
//  PlayGame
//
//  Created by Acaraga on 18.11.16.
//  Copyright © 2016 indio. All rights reserved.
//

import Foundation

class FilePlist {
    var apiKey: String? {
        get {
            return UserDefaults.standard.object(forKey: "apiKey") as! String?
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "apiKey")
            UserDefaults.standard.synchronize()
        }
    }
    var extId: String? {
        get {
            return UserDefaults.standard.object(forKey: "extId") as! String?
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "extId")
            UserDefaults.standard.synchronize()
        }
    }

}
