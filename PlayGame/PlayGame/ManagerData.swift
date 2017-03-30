//
//  ManagerData.swift
//  Weather092016
//
//  Created by kirill lukyanov on 10/6/16.
//  Copyright © 2016 home. All rights reserved.
//

import Foundation
import RealmSwift
import Alamofire
import SwiftyJSON

class ManagerData{
        let realm = try! Realm()


//====================== Данный метод получает информацию о скидке в компании
    func loadJSON( preparation: @escaping (String, Double) -> ()) -> () {
//===========================================================================
        
        let dt = NSDate()
        let headers: HTTPHeaders = ["X-Api-Key": apiKeyStr, "X-Origin-Request-Id":"a8d03734-5b63-4f04-9c69-46a3e1db3788", "X-Timestamp" : dt.description]
        
        Alamofire.request("https://udsgame.com/v1/partner/company", headers : headers).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                let companyData : CompanyData = CompanyData()
                
                companyData.companyName = json["name"].stringValue
                companyData.promoCode = json["promoCode"].stringValue
                companyData.levelBase = json["marketingSettings"]["discountBase"].doubleValue
                companyData.level1 = json["marketingSettings"]["discountLevel1"].doubleValue
                companyData.level2 = json["marketingSettings"]["discountLevel2"].doubleValue
                companyData.level3 = json["marketingSettings"]["discountLevel3"].doubleValue
                
                                print("JSON: \(json)")

                preparation(json["baseDiscountPolicy"].stringValue, json["marketingSettings"]["discountBase"].doubleValue )
     
                try! self.realm.write {
                self.realm.add( companyData, update: true)
                      }
                case .failure(let error):
                print(error.localizedDescription)
            }
        }
       // return resultData
    }

//================= Данный метод получает информацию о баллах клиента в компании =============
    func loadСustomerJSON( promoCodeStr: String, preparation: @escaping (Double, String, Double) -> ()) -> () {
//============================================================================================
        
        let dt = NSDate()
        let headers: HTTPHeaders = ["X-Api-Key": apiKeyStr, "X-Origin-Request-Id":"a8d03734-5b63-4f04-9c69-46a3e1db3788", "X-Timestamp" : dt.description]
        
        Alamofire.request("https://udsgame.com/v1/partner/customer?code=" + promoCodeStr, headers : headers).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                let customerData : CustomerData = CustomerData()
                
                customerData.scores = json["scores"].doubleValue
                customerData.id = json["id"].intValue
                customerData.surname = json["surname"].stringValue
                customerData.name    = json["name"].stringValue
                customerData.skype    = json["skype"].stringValue
                customerData.birthday    = json["birthday"].stringValue
                customerData.level = json["level"].intValue
                customerData.phone    = json["phone"].stringValue
                customerData.instagram    = json["instagram"].stringValue
                customerData.gender    = json["gender"].stringValue
                customerData.participant    = json["participant"].boolValue
                customerData.discountRate    = json["discountRate"].doubleValue

                print("JSON: \(json)")
                
                preparation(json["scores"].doubleValue, "\(customerData.name) \(customerData.surname)", customerData.discountRate )
                
                try! self.realm.write {
                    self.realm.add( customerData, update: true)
                }
            case .failure(let error):
                print("WTF! \(error.localizedDescription)")
                preparation( -1 , "\(error.localizedDescription)", -1)
            }
        }
        // return resultData
    }

//================= Данный метод совершает продажу =======================================
    func loadPurchaseJSON( scores: String, total: String, cash: String, code: String, preparation: @escaping (String?, Float?, String) -> ()) -> () {
//====================================================================================
//        
//        Alamofire.request("http://mywebsite.com/post-request", method: .post, parameters: [:], encoding: "myBody", headers: [:])
//        
        let dt = NSDate()
        let headers: HTTPHeaders = ["X-Api-Key": apiKeyStr, "X-Origin-Request-Id":"a8d03734-5b63-4f04-9c69-46a3e1db3788", "X-Timestamp" : dt.description]
        

        let parameters: Parameters = [
            "scores": scores,
            "total": total,
            "cash": cash,
            "cashierExternalId": extIdStr,
            "code": code,
            "invoiceNumber": "P\(code)",

        ]
        print("Paramz: \(parameters)")
        // All three of these calls are equivalent
        Alamofire.request("https://udsgame.com/v1/partner/purchase", method: .post, parameters: parameters, headers: headers).validate().responseJSON { response in
                        switch response.result {
                        case .success(let value):
            
                            let json = JSON(value)
//                            JSON: {
//                                "operation" : {
//                                    "scoresNew" : 8.380000000000001,
//                                    "marketingSettings" : {
//                                        "discountLevel2" : 3,
//                                        "discountBase" : 12,
//                                        "discountLevel1" : 7,
//                                        "maxScoresDiscount" : null,
//                                        "discountLevel3" : 2
//                                    },
//                                    "id" : 2340467,
//                                    "dateCreated" : "2016-11-06T23:59:49.999Z",
//                                    "cash" : 880,
//                                    "cashier" : null,
//                                    "customer" : {
//                                        "id" : 824633945991,
//                                        "name" : "Horror",
//                                        "surname" : "Show"
//                                    },
//                                    "total" : 1000,
//                                    "scoresDelta" : 0
//                                }
//                            }
                            print("JSON: \(json)")
                            
                            let surname : String? = "\(json["operation"]["customer"]["name"].stringValue) \(json["operation"]["customer"]["surname"].stringValue)"
                            
                            preparation(surname, json["operation"]["scoresDelta"].floatValue, "\(response.description) ")
            //
            //                try! self.realm.write {
            //                    self.realm.add( customerData, update: true)
            //                }
                        case .failure(let error):
                            print("\(error.localizedDescription)")
                            preparation(nil, nil, error.localizedDescription)
                            
                        }
            //        }

        }
    }
//        Alamofire.upload(Data, to: "https://udsgame.com/v1/partner/purchase", method: .post, headers: headers)
//        Alamofire.request("https://udsgame.com/v1/partner/purchase", method: .post , parameters: [:], encoding: nil, headers: headers).validate().responseJSON { response in
//            switch response.result {
//            case .success(let value):
//                
//                let json = JSON(value)
//                let customerData : CustomerData = CustomerData()
//                
//                customerData.scores = json["scores"].doubleValue
//                customerData.id = json["id"].intValue
//                customerData.surname = json["surname"].stringValue
//                customerData.name    = json["name"].stringValue
//                customerData.skype    = json["skype"].stringValue
//                customerData.birthday    = json["birthday"].stringValue
//                customerData.level = json["level"].intValue
//                customerData.phone    = json["phone"].stringValue
//                customerData.instagram    = json["instagram"].stringValue
//                customerData.gender    = json["gender"].stringValue
//                customerData.participant    = json["participant"].boolValue
//                
//                print("JSON: \(json)")
//                
//                preparation(json["scores"].doubleValue)
//                
//                try! self.realm.write {
//                    self.realm.add( customerData, update: true)
//                }
//            case .failure(let error):
//                print(error)
//            }
//        }
//        // return resultData
//    }


}
