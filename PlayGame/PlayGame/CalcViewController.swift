//
//  ViewController.swift
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
var ready2go : Bool = false

class ViewController: UIViewController {

    @IBOutlet weak var txtSumm: UITextField!
    @IBOutlet weak var txtDiscount: UITextField!
    @IBOutlet weak var txtScores: UITextField!
    @IBOutlet weak var txtPayScores: UITextField!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblPercent: UILabel!

    let realm = try! Realm()
 
    override func viewDidLoad() {

    super.viewDidLoad()

     }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func btnScanPressed(_ sender: Any) {
        performSegue(withIdentifier: "scanSegue", sender: self)
        
    }
 //=============================================================================
    override func viewDidAppear(_ animated: Bool) {
 //=============================================================================
        txtPayScores.text = ""
        lblTotal.text = "Итого к оплате: ---"
        lblPercent.text = "Скидка конечная: --"
        
        if promoCode != nil && bonusSelect == nil {

            let manager: ManagerData = ManagerData()
            
            manager.loadJSON { (levelBase) in
                self.txtDiscount.text = String(levelBase)
            
                
                manager.loadСustomerJSON( promoCodeStr: String(promoCode!)) { (scoresget) in
                    self.txtScores.text = "\(scoresget)"
                    self.calcFinalDiscount()
                   // promoCode = nil
                        }
                     }
                }
        if bonusSelect != nil {
           
            self.txtPayScores.text = "\(bonusSelect!.0)"
            self.lblTotal.text = "Итого к оплате: \(bonusSelect!.1) руб."
            self.lblPercent.text = "Скидка конечная: \(bonusSelect!.2)% "
           // bonusSelect = nil
            ready2go = true
        }
        
}
 //=============================================================================
    func calcFinalDiscount() {
 //=============================================================================
        var summ : Float? =  Float(txtSumm.text!)
        var discount : Float? =  Float(txtDiscount.text!)
        var scores : Float? =  Float(txtScores.text!)
        var payScores : Int? = nil
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
    
    
    
//@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @IBAction func btnPurchasePressed(_ sender: Any) {
//@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    if ready2go {
    
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
                ready2go = false
                bonusArray.removeAll(keepingCapacity: false)
                bonusSelect = nil

            } else
            {
                let alert = UIAlertController(title: "Ошибка", message: "\(errStr)",
                    preferredStyle: .alert)
                
                let cancelAction: UIAlertAction = UIAlertAction(title: "ок", style: .cancel) { action -> Void in
                }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
              
            }
    }
    }
            }
    

}

