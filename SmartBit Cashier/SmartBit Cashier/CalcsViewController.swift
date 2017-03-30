//
//  CalcsViewController
//  PlayGame
//
//  Created by Acaraga on 27.10.16.
//  Copyright © 2016 indio. All rights reserved.
//

import UIKit
//import RealmSwift\
import Firebase
import SwiftyJSON

var   ref = FIRDatabase.database().reference()

var promoCode : Int? = nil
//var totalFloat: Float? = nil
//var bonusArray: [(Float, Float, Float)] = []  // баллы, сумма, %
//var bonusSelect: (Float, Float, Float)? = nil // баллы, сумма, %
//var clientInfo: (Double, String, Double)? = nil // СчетБаллы, имя, скидка
var ready2Purchase : Bool = false
var cashBack : Bool = false

var opTotal : Double? = nil
var opScoresDelta : Double? = nil
var scoresPay : Double? = nil
var opCash : Double? = nil

var currentUserKey = ""
var currentQrKey = ""

let aquaColor : UIColor = UIColor.init(red: 15.0/255, green: 128.0/255, blue: 255.0/255, alpha: 1.0)

class CalcsViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var txtSumm: UITextField!
    @IBOutlet weak var txtDiscount: UITextField!
    @IBOutlet weak var txtScores: UITextField!
    @IBOutlet weak var txtPayScores: UITextField!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblPercent: UILabel!
    @IBOutlet weak var lblLevelBase: UILabel!
    @IBOutlet weak var navClientName: UINavigationItem!
    @IBOutlet weak var btnCalc: UIButton!
    @IBOutlet weak var btnPurchase: UIButton!
 
  //  let realm = try! Realm()
 
    override func viewDidLoad() {

    super.viewDidLoad()
        
        // Define identifier
        let notificationName = Notification.Name("UIKeyboardDidShowNotification")
        
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidShow), name: notificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: Notification.Name("UIKeyboardWillHideNotification"), object: nil)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CalcsViewController.didTapScrollView))
        tapGestureRecognizer.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func didTapScrollView() {
        self.view.endEditing(true)
    }
    
        
    func keyboardDidShow(notification: NSNotification) {
    }
    
    func keyboardWillHide(notification: NSNotification) {
        let summStr : String = txtSumm.text!
        let newSummStr = summStr.replacingOccurrences(of: ",", with: ".")
        opTotal  =  Double(newSummStr)
        
        if opTotal != nil {
            //btnCalc.backgroundColor = aquaColor
            //btnCalc.isUserInteractionEnabled = true
            txtPayScores.isUserInteractionEnabled = true
            
        } else {
            txtPayScores.isUserInteractionEnabled = false
        }

        let scoresStr : String = txtPayScores.text!
        let newScoresStr = scoresStr.replacingOccurrences(of: ",", with: ".")
        scoresPay  =   Double(newScoresStr)
        
        if scoresPay == nil {
            btnPurchase.backgroundColor = UIColor.gray
            btnPurchase.isUserInteractionEnabled = false
            //txtPayScores.isUserInteractionEnabled = true
            
        } else {
            btnPurchase.backgroundColor = lightColor
            btnPurchase.isUserInteractionEnabled = true
            opCash = opTotal! - scoresPay!
            opScoresDelta = opCash! * (Double(levelBase)! / 100) - scoresPay!
            let skidka = 100 - opCash! / opTotal! * 100
            self.lblTotal.text = "Итого к оплате: \(opCash!) руб."
            self.lblPercent.text = String(format:"Скидка конечная: %.1f", skidka) + "%"
                       // bonusSelect = nil
            ready2Purchase = true
        }

        
        
    }
    




    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
//    @IBAction func btnScanPressed(_ sender: Any) {
//        performSegue(withIdentifier: "scanSegue", sender: self)
//        
//    }
//===========================================================================
    override func viewDidAppear(_ animated: Bool) {
//===========================================================================
        txtSumm.text = ""
        txtDiscount.text = ""
        txtScores.text = ""
        txtPayScores.text = ""
        lblTotal.text = "Итого к оплате: ---"
        lblPercent.text = "Скидка конечная: --"
//        btnCalc.backgroundColor = UIColor.gray
        btnCalc.isUserInteractionEnabled = false
        btnPurchase.backgroundColor = UIColor.gray
        btnPurchase.isUserInteractionEnabled = false
        txtSumm.isUserInteractionEnabled = false

        if promoCode != nil {
        FIRDatabase.database().reference().child("qrcodes4bonus").observeSingleEvent(of: .value, with: { (snapshot) in
            if let u_value = snapshot.value {
                
                let json = JSON (u_value)
//                
//                let cname = json["name"].stringValue
//                self.navClientName.title = cname
//      
//                let baseDiscountPolicy = json["baseDiscountPolicy"].stringValue
                
                for (ukey, subjson) in json {
                    for (qrkey , sub2json) in subjson {
                        let code = sub2json["qrcode"].stringValue
                        let nick = sub2json["nick"].stringValue
                        let operated = sub2json["operated"].stringValue

                        if  code == String(promoCode!) && operated == "" {
                        currentUserKey = ukey
                        currentQrKey = qrkey
                        print ("*** 1st QR Found! for UserKey: \(ukey)")
                        //=================================================================================
                        self.getUserBalanceByKey(key: ukey, complition: { (uBal) in
                            self.txtScores.text = String(uBal)
                            self.txtDiscount.text = levelBase
                            if baseDiscountPolicy == "APPLY_DISCOUNT" {
                                self.lblLevelBase.text = "Базовая скидка, \(levelBase)%"
                                cashBack = false
                            } else if baseDiscountPolicy == "CHARGE_SCORES" {
                                self.lblLevelBase.text = "Вознаграждение баллами (cashback \(levelBase)%)"
                                cashBack = true
                            }
                            self.navClientName.title = nick
                            self.txtSumm.isUserInteractionEnabled = true
                    
                        })
                        }
                    }
                    
//                    if key == "marketingSettings" {
//                        print (subjson)
//                        let levelBase = subjson["discountBase"].stringValue
//                        print (" *** LevelBase: \(levelBase)")
//                        
//                        if baseDiscountPolicy == "APPLY_DISCOUNT" {
//                            self.lblBaseDiscount.text = "Базовая скидка, \(levelBase)%"
//                            cashBack = false
//                        } else if baseDiscountPolicy == "CHARGE_SCORES" {
//                            self.lblBaseDiscount.text = "Вознаграждение баллами (cashback):\(levelBase)%"
//                            cashBack = true
//                        }
                    
                }
            }
        })
        }
//                for (key, subjson) in json {
//                    //print (subjson)
//                    if subjson["login"].stringValue == fireUser?.email {// если пользователь - я сам
//                        currentUserNick = ( subjson["name"].stringValue + " " + subjson["surname"].stringValue)
//                        currentUserEmail = fireUser!.email!
//                        // ====== вычисление баланса пользователя по ключу  ===============
//                        currentUserKey = key
//                        //print ("*** AND The KEY for me is: \(key)")
//                        
//                        self.getUserBalanceByKey(key: currentUserKey, complition: { (myBalance) in
//                            currentUserBalance = myBalance
//                            self.navBar.title = "Мои баллы: \(currentUserBalance)"
//                            
//                        })
//                        
//                    }
//                }
//            }
//        })
//        
        
        
//        if promoCode != nil && bonusSelect == nil {
//
//            let manager: ManagerData = ManagerData()
//            
//            manager.loadJSON { (baseDiscountPolicy, levelBase) in
//                
//                if baseDiscountPolicy == "APPLY_DISCOUNT" {
//                    self.lblBaseDiscount.text = "Базовая скидка, \(levelBase)%"
//                    cashBack = false
//                } else if baseDiscountPolicy == "CHARGE_SCORES" {
//                    self.lblBaseDiscount.text = "Вознаграждение баллами (cashback), \(levelBase)%"
//                    cashBack = true
//                    
//                }
//                
//                
//            
//                
//                manager.loadСustomerJSON( promoCodeStr: String(promoCode!)) { (scoresget, clientName, discountRate) in
//                    
//                    if discountRate == -1 {
//                        
//                        let alert = UIAlertController(title: "Ошибка", message: "\(clientName)",
//                            preferredStyle: .alert)
//                        
//                        let cancelAction: UIAlertAction = UIAlertAction(title: "ок", style: .cancel) { action -> Void in
//                        }
//                        alert.addAction(cancelAction)
//                        self.present(alert, animated: true, completion: nil)
//                        
//                    } else {
//                    
//                        
//                        clientInfo = (scoresget, clientName, discountRate)
//                    self.txtScores.text = "\(scoresget)"
//                    self.navClientName.title = clientName
//                    self.txtDiscount.text = "\(discountRate)"
//                    self.txtSumm.isUserInteractionEnabled = true
//                    }
//                        }
//                     }
//        }
//        if bonusSelect != nil {
//
//            txtSumm.text = "\(summIn!)"
//            txtDiscount.text = cashBack ? "\((Float(summIn!) - bonusSelect!.0) * Float(clientInfo!.2) * 0.01) руб.":"\(clientInfo!.2)% (\(clientInfo!.2 * summIn! * 0.01) руб.)"
//            txtScores.text = "\(clientInfo!.0)"
//            txtPayScores.text = "\(bonusSelect!.0)"
//            btnCalc.backgroundColor = aquaColor
//            btnCalc.isUserInteractionEnabled = true
//            btnPurchase.backgroundColor = aquaColor
//            btnPurchase.isUserInteractionEnabled = true
//
//            self.lblTotal.text = "Итого к оплате: \(bonusSelect!.1) руб."
//            self.lblPercent.text = "Скидка конечная: \(bonusSelect!.2)% "
//           // bonusSelect = nil
//            ready2Purchase = true
//        
//        }
}
    //============вычисление баланса пользователя по ключу===================
    func getUserBalanceByKey (key: String, complition: @escaping (Float) -> ()) -> () {
        //=======================================================================
        var sumBalance: Float = 0
        
        FIRDatabase.database().reference().child("operations/\(key)").observe(.value, with: { (snapshot) in
            
            if let u_value = snapshot.value {
                sumBalance = 0
                let json = JSON (u_value)
                for (_, subjson) in json {
                    //print (subjson)
                    sumBalance += subjson["scoresDelta"].floatValue
                }
            }
            complition (sumBalance)
            print ("*** AND The Balance for me is: \(sumBalance)")
        })
    }
   
    
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    func ClearFields() {
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        ready2Purchase = false
//        bonusArray.removeAll(keepingCapacity: false)
//        bonusSelect = nil
//        clientInfo = nil
//        summIn = nil
        promoCode = nil
        opTotal = nil
        opScoresDelta = nil
        opCash = nil
        
        currentUserKey = ""
        currentQrKey = ""

        
        txtSumm.text = ""
        txtSumm.isUserInteractionEnabled = false
        txtDiscount.text = ""
        txtScores.text = ""
        txtPayScores.text = ""
        lblTotal.text = "Итого к оплате: ---"
        lblPercent.text = "Скидка конечная: --"
        btnCalc.backgroundColor = UIColor.gray
        btnCalc.isUserInteractionEnabled = false
        btnPurchase.backgroundColor = UIColor.gray
        btnPurchase.isUserInteractionEnabled = false
        
        
        
    }
    
    
    
//=============================================================================
    @IBAction func btnCalcPressed(_ sender: Any) {
//=============================================================================
        
        
//        self.calcFinalDiscount()
        
        self.performSegue(withIdentifier: "scoresSegue", sender: self)
        
        btnPurchase.isUserInteractionEnabled = true
        btnPurchase.backgroundColor = lightColor

    }
    
    
//@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @IBAction func btnPurchasePressed(_ sender: Any) {
//@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    if ready2Purchase {
    
    ref.child("operations/\(currentUserKey)").childByAutoId().setValue(
        [ "cash": String(opCash!),
          "scoresDelta": String( opScoresDelta!),
          "scoresPay" : String(scoresPay!),
          "total": String(opTotal!),
          "code": String(promoCode!),
          "dateCreated": String(describing: Date()) ])
    //  print (resp)
        let scoresGet = opCash! * (Double(levelBase)! / 100)
        if setCode4bonusOperated(ukey: currentUserKey, qrkey: currentQrKey) {
            let alert = UIAlertController(title: "Операция успешно проведена", message: "Потрачено \(scoresPay!) баллов, начислено \(scoresGet) баллов", preferredStyle: .alert)
            
            let cancelAction: UIAlertAction = UIAlertAction(title: "ок", style: .cancel) { action -> Void in
            }
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
            
            self.ClearFields()
            txtSumm.isUserInteractionEnabled = false
            
            
        }
        }
    }
//=========================Погашение кода=============================
    func setCode4bonusOperated (ukey: String, qrkey: String) -> Bool {
//====================================================================
        
        if ukey != "" && qrkey != "" {
            
            ref.child("qrcodes4bonus/\(ukey)/\(qrkey)").setValue(["operated": String(describing: Date()),
                                                                  "qrcode" : promoCode!])
        
    }
        return true
}
//    let manager: ManagerData = ManagerData()
//    
//    
//        manager.loadPurchaseJSON( scores : txtPayScores.text!, total : txtSumm.text!, cash :
//        String(bonusSelect!.1), code: String(promoCode!)) { (surname, scoresDelta, errStr) in
//            
//    print( "@@@\(scoresDelta)@@@")
//            if scoresDelta != nil {
//            let alert = UIAlertController(title: "Операция успешно проведена", message: "Клиент \(surname!) : потрачено \(scoresDelta!) баллов", preferredStyle: .alert)
//            
//            let cancelAction: UIAlertAction = UIAlertAction(title: "ок", style: .cancel) { action -> Void in
//            }
//            alert.addAction(cancelAction)
//                self.present(alert, animated: true, completion: nil)
//             
//            self.ClearFields()
//                
//                
//
//            } else
//            {
//                let alert = UIAlertController(title: "Ошибка", message: "\(errStr)",
//                    preferredStyle: .alert)
//                
//                let cancelAction: UIAlertAction = UIAlertAction(title: "ок", style: .cancel) { action -> Void in
//                }
//                alert.addAction(cancelAction)
//                self.present(alert, animated: true, completion: nil)
//                self.ClearFields()
//            }
//    }
    
        
    
    @IBAction func btnStopPressed(_ sender: Any) {
        self.ClearFields()
        self.dismiss(animated: true, completion: nil)
    }

}

