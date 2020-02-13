//
//  QrcodeReadViewController.swift
//  Test
//
//  Created by 石井翔真 on 2019/12/16.
//  Copyright © 2019 石井翔真. All rights reserved.
//
//QRコード読み取り画面
 
import Foundation
import AVFoundation
import UIKit
import Firebase
import MercariQRScanner
            
class QrcodeReadViewController: UIViewController {
    var alertController: UIAlertController!
    let ref = Database.database().reference()
    var data = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let qrScannerView = QRScannerView(frame: view.bounds)
        view.addSubview(qrScannerView)
        qrScannerView.configure(delegate: self)
        qrScannerView.startRunning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        let qrScannerView = QRScannerView(frame: view.bounds)
        view.addSubview(qrScannerView)
        qrScannerView.configure(delegate: self)
        qrScannerView.stopRunning()
    }
}

extension QrcodeReadViewController: QRScannerViewDelegate {
    
    
    func qrScannerView(_ qrScannerView: QRScannerView, didFailure error: QRScannerError) {
        print(error)
    }
    
    func qrScannerView(_ qrScannerView: QRScannerView, didSuccess code: String) {
        print(code)
        
        //QRコードの内容が空かどうかの確認
        if code == "" { return }
        
        if !(code.pregMatche(pattern: "[.#$¥[¥]]")) {
            
            ref.child("user").child(code).observe(.value) { (snapshot) in
                
                if snapshot.exists() {
                    print(snapshot.value)
                    self.data = code
                    self.performSegue(withIdentifier: "toAddFriend", sender: nil)
                } else {
                    self.alert(title: "エラー", message: "ユーザが存在しません")
                    self.viewDidLoad()
                }
            }
            
        }else{
            self.alert(title: "エラー", message: "不正なデータです")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            // identifierが取れなかったら処理やめる
            return
        }
        
        if(identifier == "toAddFriend") {
            // NavigationControllerへの遷移の場合
            
            // segueから遷移先のNavigationControllerを取得
            let vc = segue.destination as! AddFriendAuthViewController
            // 次画面のテキスト表示用のStringに、本画面のテキストフィールドのテキストを入れる
            vc.id = self.data
        }
    }
    
    func alert(title:String, message:String) {
        alertController = UIAlertController(title: title,
                                            message: message,
                                            preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK",
                                                style: .default,
                                                handler: nil))
        present(alertController, animated: true)
    }
}


//final class QrcodeReadViewController: UIViewController {
//    // MARK: - Outlets
//    @IBOutlet var qrScannerView: QRScannerView! {
//        didSet {
//            qrScannerView.configure(delegate: self, input: .init(isBlurEffectEnabled: true))
//        }
//    }
//    @IBOutlet var flashButton: FlashButton!
//
//    // MARK: - LifeCycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//    }
//
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        qrScannerView.stopRunning()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        qrScannerView.startRunning()
//    }
//
//    // MARK: - Actions
//    @IBAction func tapFlashButton(_ sender: UIButton) {
//        qrScannerView.setTorchActive(isOn: !sender.isSelected)
//    }
//}
//
//// MARK: - QRScannerViewDelegate
//extension QrcodeReadViewController: QRScannerViewDelegate {
//    func qrScannerView(_ qrScannerView: QRScannerView, didFailure error: QRScannerError) {
//        print(error.localizedDescription)
//    }
//
//    func qrScannerView(_ qrScannerView: QRScannerView, didSuccess code: String) {
//        if let url = URL(string: code), (url.scheme == "http" || url.scheme == "https") {
//            openWeb(url: url)
//        } else {
//            showAlert(code: code)
//        }
//    }
//
//    func qrScannerView(_ qrScannerView: QRScannerView, didChangeTorchActive isOn: Bool) {
//        flashButton.isSelected = isOn
//    }
//}
//
//// MARK: - Private
//private extension QrcodeReadViewController {
//    func openWeb(url: URL) {
//        UIApplication.shared.open(url, options: [:], completionHandler: { _ in
//            self.qrScannerView.rescan()
//        })
//    }
//
//    func showAlert(code: String) {
//        let alertController = UIAlertController(title: code, message: nil, preferredStyle: .actionSheet)
//        let copyAction = UIAlertAction(title: "Copy", style: .default) { [weak self] _ in
//            UIPasteboard.general.string = code
//            self?.qrScannerView.rescan()
//        }
//        alertController.addAction(copyAction)
//        let searchWebAction = UIAlertAction(title: "Search Web", style: .default) { [weak self] _ in
//            UIApplication.shared.open(URL(string: "https://www.google.com/search?q=\(code)")!, options: [:], completionHandler: nil)
//            self?.qrScannerView.rescan()
//        }
//        alertController.addAction(searchWebAction)
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { [weak self] _ in
//            self?.qrScannerView.rescan()
//        })
//        alertController.addAction(cancelAction)
//        present(alertController, animated: true, completion: nil)
//    }
//}
//class QrcodeReadViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
//
//    // カメラやマイクの入出力を管理するオブジェクトを生成
//    private let session = AVCaptureSession()
//    var data = ""
//
//    var alertController: UIAlertController!
//    let ref = Database.database().reference()
//
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view, typically from a nib.
//
//        // カメラやマイクのデバイスそのものを管理するオブジェクトを生成（ここではワイドアングルカメラ・ビデオ・背面カメラを指定）
//        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera],
//                                                                mediaType: .video,
//                                                                position: .back)
//
//        // ワイドアングルカメラ・ビデオ・背面カメラに該当するデバイスを取得
//        let devices = discoverySession.devices
//
//        //　該当するデバイスのうち最初に取得したものを利用する
//        if let backCamera = devices.first {
//            do {
//                // QRコードの読み取りに背面カメラの映像を利用するための設定
//                let deviceInput = try AVCaptureDeviceInput(device: backCamera)
//
//                if self.session.canAddInput(deviceInput) {
//                    self.session.addInput(deviceInput)
//
//                    // 背面カメラの映像からQRコードを検出するための設定
//                    let metadataOutput = AVCaptureMetadataOutput()
//
//                    if self.session.canAddOutput(metadataOutput) {
//                        self.session.addOutput(metadataOutput)
//
//                        metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
//                        metadataOutput.metadataObjectTypes = [.qr]
//
//                        // 背面カメラの映像を画面に表示するためのレイヤーを生成
//                        let previewLayer = AVCaptureVideoPreviewLayer(session: self.session)
//                        previewLayer.frame = self.view.bounds
//                        previewLayer.videoGravity = .resizeAspectFill
//                        self.view.layer.addSublayer(previewLayer)
//
//                        // 読み取り開始
//                        self.session.startRunning()
//                    }
//                }
//            } catch {
//                print("Error occured while creating video device input: \(error)")
//            }
//        }
//    }
//
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
//        for metadata in metadataObjects as! [AVMetadataMachineReadableCodeObject] {
//
//            // QRコードのデータかどうかの確認
//            if metadata.type != .qr { continue }
//
//            // QRコードの内容が空かどうかの確認
//            if metadata.stringValue == nil { continue }
//
//            if let val = metadata.stringValue {
//                if !(val.pregMatche(pattern: "[.#$¥[¥]]")) {
//
//                    ref.child("user").child(val).observe(.value) { (snapshot) in
//
//                        if((snapshot.value) != nil){
//                            self.data = metadata.stringValue!
//                            self.performSegue(withIdentifier: "toAddFriend", sender: nil)
//                            self.session.stopRunning()
//                        } else {
//                            self.alert(title: "エラー", message: "ユーザが存在しません")
//                        }
//                    }
//
//                }else{
//                    self.alert(title: "エラー", message: "不正なデータです")
//                }
//            }
//
//            // URLかどうかの確認
//            if let url = URL(string: metadata.stringValue!) {
//
//                // QRコードに紐付いたURLをSafariで開く
//                UIApplication.shared.open(url, options: [:], completionHandler: nil)
//
//                break
//
//            }
//
//        }
//    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        guard let identifier = segue.identifier else {
//            // identifierが取れなかったら処理やめる
//            return
//        }
//
//        if(identifier == "toAddFriend") {
//            // NavigationControllerへの遷移の場合
//
//            // segueから遷移先のNavigationControllerを取得
//            let vc = segue.destination as! AddFriendAuthViewController
//            // 次画面のテキスト表示用のStringに、本画面のテキストフィールドのテキストを入れる
//            vc.id = self.data
//        }
//    }
//
//    func alert(title:String, message:String) {
//        alertController = UIAlertController(title: title,
//                                            message: message,
//                                            preferredStyle: .alert)
//        alertController.addAction(UIAlertAction(title: "OK",
//                                                style: .default,
//                                                handler: nil))
//        present(alertController, animated: true)
//    }
//
//
//}
