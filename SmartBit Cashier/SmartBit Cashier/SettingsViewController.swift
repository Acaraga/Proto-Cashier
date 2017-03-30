//
//  SettingsViewController.swift
//  PlayGame
//
//  Created by Acaraga on 18.11.16.
//  Copyright © 2016 indio. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var txtApiKey: UITextField!
    @IBOutlet weak var txtExtId: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        let loadStatus: FilePlist = FilePlist()
//        
//        if loadStatus.apiKey != nil {
//            
        txtApiKey.text = apiKeyStr
        txtExtId.text = extIdStr
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func btnDoneClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func btnSaveClick(_ sender: Any) {
        let ac = UIAlertController(title: "Изменение настроек", message: "Введите сервисный пин-код", preferredStyle:  .alert)
        let alertOkAction = UIAlertAction(title: "OK", style: .default, handler: { (_) in
            let textField = ac.textFields![0] // Force unwrapping because we know it exists.
            let pinCode : Int? = Int(textField.text!)
            print("\(pinCode)")
            if pinCode == 9998 {
                let loadStatus: FilePlist = FilePlist()
                
                loadStatus.apiKey = self.txtApiKey.text
                loadStatus.extId = self.txtExtId.text
                apiKeyStr = self.txtApiKey.text!
                extIdStr = self.txtExtId.text!
                
            }
            self.dismiss(animated: true)
        })
        
        ac.addAction(alertOkAction)
        let alertCancelAction = UIAlertAction(title: "Отмена", style: .cancel , handler: nil)
        ac.addAction(alertCancelAction)
        
        ac.addTextField { (codeTextField) in
            codeTextField.placeholder = ""
            
        }
        
        present(ac, animated: true, completion: nil)
    }

    
        
        
    
}
