//
//  QRScannerViewController.swift
//  LineSaver
//
//  Created by Cat  on 4/27/20.
//  Copyright © 2020 Cat . All rights reserved.
//

import UIKit
import AVFoundation

class QRScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    var video = AVCaptureVideoPreviewLayer()
    @IBOutlet weak var square: UIImageView!
    
    @IBOutlet weak var usernameCheckInButton: RoundedButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // creating session
        let session = AVCaptureSession()
        
        // define capture device
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        
        do {
            guard let captureDevice = captureDevice else {return}
            // input constant 
            let input = try AVCaptureDeviceInput(device: captureDevice)
            session.addInput(input)
        } catch {
            print("ERROR")
        }
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        video = AVCaptureVideoPreviewLayer(session: session)
        // get height of the tab view
        //let tabBarHeight = self.tabBarController?.tabBar.frame.height ?? 49.0
        //let frameWithTabBar = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - tabBarHeight)
        video.frame = view.layer.bounds
        view.layer.addSublayer(video)
        
        self.view.bringSubviewToFront(square)
        self.view.bringSubviewToFront(usernameCheckInButton)
        // TODO: add button to the front as well 
        session.startRunning()
        
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count != 0 {
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject {
                // if it's of type QR code
                if object.type == AVMetadataObject.ObjectType.qr {
                    // This is where i'll decode the JSON object, grab the username & confirm
                    // that it's this user's turn to be checked in
                    let decoder = JSONDecoder()
                    // let data = jsonString?.data(using: .utf8, allowLossyConversion: false)
                    guard let dataString = object.stringValue else {return}
                    guard let data = dataString.data(using: .utf8, allowLossyConversion: false) else {return}
                    do {
                        let user:User = try decoder.decode(User.self, from: data)
                        let alert = UIAlertController(title: "Check In Successful", message: "\(user.username) was checked in", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Retake", style: .default, handler: nil))
                        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (nil) in
                            UIPasteboard.general.string = object.stringValue
                        }))
                        present(alert, animated: true, completion: nil)
                    }
                    catch {
                        print(error)
                        exit(1)
                    }
                    
                }
            }
            
        }
    }
}
