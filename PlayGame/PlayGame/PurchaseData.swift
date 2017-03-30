//
//  PurchaseData.swift
//  PlayGame
//
//  Created by Acaraga on 04.11.16.
//  Copyright © 2016 indio. All rights reserved.
//

import Foundation
import RealmSwift

class PurchaseData: Object{
    dynamic var scores: Float = 0
    dynamic var total: Float = 0
    dynamic var cash: Float = 0
    dynamic var code: Int = 0
    dynamic var invoiceNumber: String = ""
    
    override static func primaryKey() -> String? {
        return "code"
    }
    
}
