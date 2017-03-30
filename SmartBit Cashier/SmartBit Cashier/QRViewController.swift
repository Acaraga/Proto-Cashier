//
//  QRViewController.swift
//  PlayGame
//
//  Created by Acaraga on 01.11.16.
//  Copyright © 2016 indio. All rights reserved.
//

import AVFoundation
import UIKit

class QRViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()
        
        let videoCaptureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed();
            return;
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession);
        previewLayer.frame.origin.x = view.layer.frame.origin.x;
        previewLayer.frame.origin.y = view.layer.frame.origin.y + 45;
        previewLayer.frame.size.height = view.layer.bounds.height - 100;
        previewLayer.frame.size.width = view.layer.bounds.width;
        
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        view.layer.addSublayer(previewLayer);
        captureSession.startRunning();
        //self.squareView.bringSubview(toFront: view)

    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.isRunning == false) {
            captureSession.startRunning();
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning();
        }
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            let readableObject = metadataObject as! AVMetadataMachineReadableCodeObject;
            
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: readableObject.stringValue);
            
        }

        self.performSegue(withIdentifier: "calcSegue", sender: self)
    }
    
    func found(code: String) {
        print(code)
        promoCode = Int(code)
        //self.performSegue(withIdentifier: "calcSegue", sender: self)

    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    @IBAction func btnStopClick(_ sender: Any) {
        dismiss(animated: true)
    }
    @IBAction func btnManualPressed(_ sender: UIButton) {
        let ac = UIAlertController(title: "Ручной ввод кода", message: "Введите код на скидку (6 цифр)", preferredStyle:  .alert)
        let alertOkAction = UIAlertAction(title: "OK", style: .default, handler: { (_) in
            let textField = ac.textFields![0] // Force unwrapping because we know it exists.
            if Int(textField.text!) != nil {
                promoCode = Int(textField.text!)
                
                print("\(promoCode!)")
                
                self.performSegue(withIdentifier: "calcSegue", sender: self)
                
            } else {
                self.dismiss(animated: true, completion: nil)
            }
           
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
