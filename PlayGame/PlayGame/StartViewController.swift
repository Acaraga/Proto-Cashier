//
//  StartViewController.swift
//  PlayGame
//
//  Created by Acaraga on 18.11.16.
//  Copyright © 2016 indio. All rights reserved.
//

import UIKit

var apiKeyStr : String = ""
var extIdStr : String = ""


class StartViewController: UIViewController {

    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var imgStart: UIImageView!
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

    override func viewWillAppear(_ animated: Bool) {
        if apiKeyStr != "" {
        btnStart.isUserInteractionEnabled = true
                    imgStart.alpha = 1
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
