//
//  CompanyData.swift
//  Weather092016
//
//  Created by Acaraga on 10.10.16.
//  Copyright © 2016 home. All rights reserved.
//

import Foundation
import RealmSwift

class CompanyData: Object{
    dynamic var companyName: String = ""
    dynamic var promoCode: String = ""
    dynamic var levelBase: Double = 0
    dynamic var level1: Double = 0
    dynamic var level2: Double = 0
    dynamic var level3: Double = 0
    
    
    override static func primaryKey() -> String? {
        return "companyName"
    }

}
