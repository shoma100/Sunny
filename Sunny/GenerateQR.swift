//
//  GenerateQR.swift
//  Sunny
//
//  Created by 原涼馬 on 2019/12/18.
//  Copyright © 2019 石井翔真. All rights reserved.
//

import UIKit
import Firebase

class GenerateQR: UIViewController {
    override func viewDidLoad() {
        let user = Auth.auth().currentUser
        //URLをNSDataに変換し、QRコードを作成します。
        //Converts a url to NSData.
        let url = user?.uid
        let data = url!.data(using: String.Encoding.utf8)!

        //QRコードを生成します。
        //Generate QR code.
        let qr = CIFilter(name: "CIQRCodeGenerator", parameters: ["inputMessage": data, "inputCorrectionLevel": "M"])!
        let sizeTransform = CGAffineTransform(scaleX: 10, y: 10)
        let qrImage = qr.outputImage!.transformed(by: sizeTransform)
        let context = CIContext()
        let cgImage = context.createCGImage(qrImage, from: qrImage.extent)
        let uiImage = UIImage(cgImage: cgImage!)

        //作成したQRコードを表示します
        //Display QR code
        let qrImageView = UIImageView()
        qrImageView.contentMode = .scaleAspectFit
        qrImageView.frame = self.view.frame
        qrImageView.image = uiImage
        self.view.addSubview(qrImageView)
    }
    @IBAction func backTo(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
