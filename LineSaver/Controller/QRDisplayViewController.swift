//
//  QRDisplayViewController.swift
//  LineSaver
//
//  Created by Cat  on 5/5/20.
//  Copyright © 2020 Cat . All rights reserved.
//

import UIKit

class QRDisplayViewController: UIViewController {

    @IBOutlet weak var QRImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // let jsonString = String(data: jsonData, encoding: .utf8)
        // let data = jsonString?.data(using: .utf8, allowLossyConversion: false)
        // Do any additional setup after loading the view.
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(FBAuthService.shared.currentLSUser) 
            let filter = CIFilter(name: "CIQRCodeGenerator")
            filter?.setValue(data, forKey: "inputMessage")
            let img = UIImage(ciImage: (filter?.outputImage)!)
            QRImageView.layer.magnificationFilter = CALayerContentsFilter(rawValue: kCISamplerFilterNearest)
            QRImageView.image = img
        }
        catch {
            print("encoding error")
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
