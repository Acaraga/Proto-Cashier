//
//  CalcsViewController
//  PlayGame
//
//  Created by Acaraga on 27.10.16.
//  Copyright © 2016 indio. All rights reserved.
//

import UIKit
import RealmSwift

var promoCode : Int? = nil
//var totalFloat: Float? = nil
var bonusArray: [(Float, Float, Float)] = []  // баллы, сумма, %
var bonusSelect: (Float, Float, Float)? = nil // баллы, сумма, %
var clientInfo: (Double, String, Double)? = nil // СчетБаллы, имя, скидка
var summIn : Double? = nil
var ready2Purchase : Bool = false
var cashBack : Bool = false


let aquaColor : UIColor = UIColor.init(red: 15.0/255, green: 128.0/255, blue: 255.0/255, alpha: 1.0)

class CalcsViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var txtSumm: UITextField!
    @IBOutlet weak var txtDiscount: UITextField!
    @IBOutlet weak var txtScores: UITextField!
    @IBOutlet weak var txtPayScores: UITextField!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblPercent: UILabel!
    @IBOutlet weak var lblBaseDiscount: UILabel!
    @IBOutlet weak var navClientName: UINavigationItem!
    @IBOutlet weak var btnCalc: UIButton!
    @IBOutlet weak var btnPurchase: UIButton!
 
    let realm = try! Realm()
 
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
        summIn  =  Double(newSummStr)
        
        if summIn != nil {
            btnCalc.backgroundColor = aquaColor
            btnCalc.isUserInteractionEnabled = true
        } else {
            btnCalc.backgroundColor = UIColor.gray
            btnCalc.isUserInteractionEnabled = false
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
 //=============================================================================
    override func viewDidAppear(_ animated: Bool) {
 //=============================================================================
        txtSumm.text = ""
        txtDiscount.text = ""
        txtScores.text = ""
        txtPayScores.text = ""
        lblTotal.text = "Итого к оплате: ---"
        lblPercent.text = "Скидка конечная: --"
        btnCalc.backgroundColor = UIColor.gray
        btnCalc.isUserInteractionEnabled = false
        btnPurchase.backgroundColor = UIColor.gray
        btnPurchase.isUserInteractionEnabled = false
        txtSumm.isUserInteractionEnabled = false
        
        if promoCode != nil && bonusSelect == nil {

            let manager: ManagerData = ManagerData()
            
            manager.loadJSON { (baseDiscountPolicy, levelBase) in
                
                if baseDiscountPolicy == "APPLY_DISCOUNT" {
                    self.lblBaseDiscount.text = "Базовая скидка, \(levelBase)%"
                    cashBack = false
                } else if baseDiscountPolicy == "CHARGE_SCORES" {
                    self.lblBaseDiscount.text = "Вознаграждение баллами (cashback), \(levelBase)%"
                    cashBack = true
                    
                }
                
                
            
                
                manager.loadСustomerJSON( promoCodeStr: String(promoCode!)) { (scoresget, clientName, discountRate) in
                    
                    if discountRate == -1 {
                        
                        let alert = UIAlertController(title: "Ошибка", message: "\(clientName)",
                            preferredStyle: .alert)
                        
                        let cancelAction: UIAlertAction = UIAlertAction(title: "ок", style: .cancel) { action -> Void in
                        }
                        alert.addAction(cancelAction)
                        self.present(alert, animated: true, completion: nil)
                        
                    } else {
                    
                        
                        clientInfo = (scoresget, clientName, discountRate)
                    self.txtScores.text = "\(scoresget)"
                    self.navClientName.title = clientName
                    self.txtDiscount.text = "\(discountRate)"
                    self.txtSumm.isUserInteractionEnabled = true
                    }
                        }
                     }
        }
        if bonusSelect != nil {

            txtSumm.text = "\(summIn!)"
            txtDiscount.text = cashBack ? "\((Float(summIn!) - bonusSelect!.0) * Float(clientInfo!.2) * 0.01) руб.":"\(clientInfo!.2)% (\(clientInfo!.2 * summIn! * 0.01) руб.)"
            txtScores.text = "\(clientInfo!.0)"
            txtPayScores.text = "\(bonusSelect!.0)"
            btnCalc.backgroundColor = aquaColor
            btnCalc.isUserInteractionEnabled = true
            btnPurchase.backgroundColor = aquaColor
            btnPurchase.isUserInteractionEnabled = true

            self.lblTotal.text = "Итого к оплате: \(bonusSelect!.1) руб."
            self.lblPercent.text = "Скидка конечная: \(bonusSelect!.2)% "
           // bonusSelect = nil
            ready2Purchase = true
        
        }
}
 //=============================================================================
    func calcFinalDiscount() {
 //=============================================================================
//        let summStr : String = txtSumm.text!
//        let newSummStr = summStr.replacingOccurrences(of: ",", with: ".")
//        let summ : Float? =  Float(newSummStr)
        
        bonusArray.removeAll(keepingCapacity: false)
        
        let summ : Float? =  Float(summIn!)
        let discount : Float? = cashBack ? 0:Float((clientInfo?.2)!)
        let scores : Float? =  Float((clientInfo?.0)!)
//        var payScores : Int? = nil
        var total : Float? = 0
        var percent : Float = 0
        
        total = summ! - (summ! * discount! * 0.01) - Float(scores!)
        percent = total! / summ! * 100
        if total != nil {
            
            var j : Int = 0
            
            if Int(scores!) > Int(summ!) { j  = Int(summ! - (summ! * discount! * 0.01))
            } else {
                j = Int(scores!)
            }
            
            for i in (0...j).reversed() {
                total = summ! - (summ! * discount! * 0.01) - Float(i)
                percent = 100 - total! / summ! * 100
                
                if Float(lroundf(percent)) == percent {
                    print("FOUND! .....\(i) total: \(total) perc:\(percent) <> \(round(percent)) =  \((percent) - (round(percent)))")
                    bonusArray.append((Float(i), Float(total!),Float(percent)))
                    }
                }
            }
        bonusSelect =  bonusArray.last
        
    
}
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    func ClearFields() {
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        ready2Purchase = false
        bonusArray.removeAll(keepingCapacity: false)
        bonusSelect = nil
        clientInfo = nil
        summIn = nil
        promoCode = nil
        
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
        
        
        self.calcFinalDiscount()
        
        self.performSegue(withIdentifier: "scoresSegue", sender: self)
        
        btnPurchase.isUserInteractionEnabled = true
        btnPurchase.backgroundColor = aquaColor

    }
    
    
//@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @IBAction func btnPurchasePressed(_ sender: Any) {
//@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    if ready2Purchase {
    
    let manager: ManagerData = ManagerData()
    
    
        manager.loadPurchaseJSON( scores : txtPayScores.text!, total : txtSumm.text!, cash :
        String(bonusSelect!.1), code: String(promoCode!)) { (surname, scoresDelta, errStr) in
            
    print( "@@@\(scoresDelta)@@@")
            if scoresDelta != nil {
            let alert = UIAlertController(title: "Операция успешно проведена", message: "Клиент \(surname!) : потрачено \(scoresDelta!) баллов", preferredStyle: .alert)
            
            let cancelAction: UIAlertAction = UIAlertAction(title: "ок", style: .cancel) { action -> Void in
            }
            alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
             
            self.ClearFields()
                
                

            } else
            {
                let alert = UIAlertController(title: "Ошибка", message: "\(errStr)",
                    preferredStyle: .alert)
                
                let cancelAction: UIAlertAction = UIAlertAction(title: "ок", style: .cancel) { action -> Void in
                }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
                self.ClearFields()
            }
    }
    }
        
            }
    
    @IBAction func btnStopPressed(_ sender: Any) {
        self.ClearFields()
        self.dismiss(animated: true, completion: nil)
    }

}

