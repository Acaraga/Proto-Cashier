//
//  ManagerData.swift
//
//
//  Created by nov_ on 10/6/16.
//  Copyright © 2016 home. All rights reserved.
//

import Foundation
//import RealmSwift
import Alamofire
import SwiftyJSON


class ManagerData{
    
    
    
//====================== Данный метод отправляет ПУШ-уведомление =====================
    func sendFCM( toToken:String, title: String, body: String, complition: @escaping (String, Double) -> ()) -> () {
//====================================================================================
        
        //            let dt = NSDate()
        let serverKey = "AAAAaxqjESE:APA91bEDDZPKU7S6QmPTitDe4fmO5EDOD7PmVcducHcmNLvnVV6aT818A1s9vOuxTRETXzUMon_MMGeuPZQPcdX5sN_hlCLh7sr6bQInSpp3BGOes9TwJGXek6Kj7tGRcT7lkYFY53wf"
        let headers: HTTPHeaders = ["Content-type": "application/json", "Authorization":"key=\(serverKey)"]
        
        
        //curl -H "Content-type: application/json" -H "Authorization:key=AAAAaxqjESE:APA91bEDDZPKU7S6QmPTitDe4fmO5EDOD7PmVcducHcmNLvnVV6aT818A1s9vOuxTRETXzUMon_MMGeuPZQPcdX5sN_hlCLh7sr6bQInSpp3BGOes9TwJGXek6Kj7tGRcT7lkYFY53wf"  -X POST -d '{ "data": { "score": "5x1","time": "15:10"},"to" : "dTA0aQIUUeY:APA91bFF3GoPDL9KIwnlDGD5L3Q8tcs6YB9UkTACpIpvVIrcz1dFDjpJA1B3MOyXvMNBtfi-lYJ5GjOuDZ-MuugqcQNABfMHfbrSuxvkxcvxnbAAlVlRn5Ba1gb2ad7sRfPxGQ3J9Gax"}' https://fcm.googleapis.com/fcm/send
        
        let parameters: Parameters = [
            "data": [
                "title": "\(title)",
                "body": "\(body)"],
            
            "time_to_live": 900,
            
            "to": "\(toToken)",
            "priority": "high",
            "notification": ["title": "\(title)",
                "text": "\(body)",
                "sound": "default",
                "time": 1489006800,
                "icon": "https://eralash.ru.rsz.io/sites/all/themes/eralash_v5/logo.png?width=40&height=40",
                "click_action": "http://eralash.ru/"]
            
            
            
        ]
        
        Alamofire.request("https://fcm.googleapis.com/fcm/send", method: .post, parameters: parameters, encoding: JSONEncoding.default,  headers : headers).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                //                print("value: \(value)")
                let json = JSON(value)
                //                 print("JSON: \(json)")
                let subjson = json["results"]
                //                 print("subJSON: \(subjson[0])")
                complition(subjson[0]["message_id"].stringValue, json["success"].doubleValue )
                
            case .failure(let error):
                print("*** ERROR: \(error.localizedDescription)")
            }
        }
    }
    
}
