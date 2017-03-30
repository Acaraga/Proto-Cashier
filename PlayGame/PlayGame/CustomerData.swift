//
//  CustomerData.swift
//  PlayGame
//
//  Created by Acaraga on 03.11.16.
//  Copyright © 2016 indio. All rights reserved.
//

import Foundation
import RealmSwift

class CustomerData: Object{
    dynamic var scores: Double = 0
    dynamic var skype: String = ""
    dynamic var level: Int = 0
    dynamic var phone: String = ""
    dynamic var id: Int = 0
    dynamic var surname: String = ""
    dynamic var instagram: String = ""
    dynamic var birthday: String = ""
    dynamic var gender: String = ""
    dynamic var participant: Bool = false
    dynamic var name: String = ""
    dynamic var discountRate: Double = 0

    override static func primaryKey() -> String? {
        return "id"
    }
    
}
