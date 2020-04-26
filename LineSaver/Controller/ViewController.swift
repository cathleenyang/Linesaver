//
//  ViewController.swift
//  LineSaver
//
//  Created by Cat  on 4/10/20.
//  Copyright © 2020 Cat . All rights reserved.
//

import UIKit
import AVFoundation

extension UITextField {
    func setIcon(_ image: UIImage) {
        let iconView = UIImageView(frame: CGRect(x:10, y:5, width:20, height:20))
        iconView.image = image
        let iconContainerView: UIView = UIView(frame:CGRect(x:20, y:0, width: 30, height: 30))
        iconContainerView.addSubview(iconView)
        
        leftView = iconContainerView
        leftViewMode = .always
    }
}

class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate{

    var video = AVCaptureVideoPreviewLayer()
    @IBOutlet weak var myTextField: UITextField!
    @IBOutlet weak var myImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // creating session
//        let session = AVCaptureSession()
//
//        //define capture device
//        let captureDevice = AVCaptureDevice.default(for: .video)
        
    }

    @IBAction func buttonClick(_ sender: Any) {
        if let myString = myTextField.text {
            // ascii encoding from string -> data
            let data = myString.data(using: .utf8, allowLossyConversion: false)
            let filter = CIFilter(name: "CIQRCodeGenerator")
            filter?.setValue(data, forKey: "inputMessage")
            let img = UIImage(ciImage: (filter?.outputImage)!)
            myImageView.image = img
        }
    }
    
}

