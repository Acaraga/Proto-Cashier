//
//  StartViewController.swift
//  PlayGame
//
//  Created by Acaraga on 18.11.16.
//  Copyright © 2016 indio. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON

var apiKeyStr : String = ""
var extIdStr : String = ""
var levelBase : String = ""
var baseDiscountPolicy : String = ""

class StartViewController: UIViewController {

    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var imgStart: UIImageView!
    @IBOutlet weak var lblLevelBase: UILabel!
    @IBOutlet weak var lblCompany: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let loadStatus: FilePlist = FilePlist()
        
        if loadStatus.apiKey != nil {
            
            apiKeyStr = loadStatus.apiKey!
            extIdStr = loadStatus.extId!
        } else {
            let alert = UIAlertController(title: "Ошибка", message: "Не задан API-KEY",
                                          preferredStyle: .alert)
            
            let cancelAction: UIAlertAction = UIAlertAction(title: "ок", style: .cancel) { action -> Void in
            }
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
//===========================================================================
    override func viewWillAppear(_ animated: Bool) {
//===========================================================================
        if apiKeyStr != "" {
            btnStart.isUserInteractionEnabled = true
            imgStart.alpha = 1
            
            FIRDatabase.database().reference().child("companyData/\(apiKeyStr)").observeSingleEvent(of: .value, with: { (snapshot) in
                if let u_value = snapshot.value {
                    
                    let json = JSON (u_value)
                    
                    let cname = json["name"].stringValue
                    self.lblCompany.text = cname
                    
                    baseDiscountPolicy = json["baseDiscountPolicy"].stringValue
                    
                    for (key, subjson) in json {
                        
                        if key == "marketingSettings" {
                            //print (subjson)
                            levelBase = subjson["discountBase"].stringValue
                            print (" *** LevelBase: \(levelBase)")
                            
                            if baseDiscountPolicy == "APPLY_DISCOUNT" {
                                self.lblLevelBase.text = "Базовая скидка, \(levelBase)%"
                                cashBack = false
                            } else if baseDiscountPolicy == "CHARGE_SCORES" {
                                self.lblLevelBase.text = "Вознаграждение баллами (cashback \(levelBase)%)"
                                cashBack = true
                            }
                        }
                    }
                }
            })
     
            
        } else {
            btnStart.isUserInteractionEnabled = false
           
            imgStart.alpha = 0.2
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnStartPressed(_ sender: Any) {

        performSegue(withIdentifier: "scanSegue", sender: self)

    }

}
