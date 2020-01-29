//
//  camera.swift
//  Sunny
//
//  Created by 原涼馬 on 2019/12/24.
//  Copyright © 2019 石井翔真. All rights reserved.
//
import UIKit
import AVFoundation
import ARKit
class CameraViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate {
    
    @IBAction func swipe(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nextView = storyboard.instantiateViewController(withIdentifier: "login") as! LoginViewController
        //右に遷移する
         let transition = CATransition()
         transition.duration = 0.5
        transition.type = CATransitionType.push

        //kCATransitionFromLeftにすれば左に遷移します
        transition.subtype = CATransitionSubtype.fromLeft
        view.window!.layer.add(transition, forKey: kCATransition)
        self.present(nextView, animated: false, completion: nil)
    }
//    @IBAction func shutter(_ sender: Any) {
//        //コンテキスト開始
//        UIGraphicsBeginImageContextWithOptions(UIScreen.main.bounds.size, false, 0.0)
//        //viewを書き出す
//        self.view.drawHierarchy(in: self.view.bounds, afterScreenUpdates: true)
//        // imageにコンテキストの内容を書き出す
//        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
//        //コンテキストを閉じる
//        UIGraphicsEndImageContext()
//        // imageをカメラロールに保存
//        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
//    }
    
    
    // ARSCNView
    @IBOutlet var sceneView: ARSCNView!
    // Face Tracking の起点となるノードとジオメトリを格納するノード
    private var faceNode = SCNNode()
    private var virtualFaceNode = SCNNode()
    
    // シリアルキューの設定
    private let serialQueue = DispatchQueue(label: "com.test.FaceTracking.serialSceneKitQueue")
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Face Tracking が使えなければ、これ以下の命令を実行を実行しない
        guard ARFaceTrackingConfiguration.isSupported else { return }
    
        // Face Tracking アプリの場合、画面を触らない状況が続くため画面ロックを止める
        UIApplication.shared.isIdleTimerDisabled = true
        
        // ARSCNView と ARSession のデリゲート、周囲の光の設定
        sceneView.delegate = self
        sceneView.session.delegate = self
        sceneView.automaticallyUpdatesLighting = true
        
        // virtualFaceNode に ARSCNFaceGeometry を設定する
        let device = sceneView.device!
        let maskGeometry = ARSCNFaceGeometry(device: device)!
        
        maskGeometry.firstMaterial?.diffuse.contents = UIColor.lightGray
        maskGeometry.firstMaterial?.lightingModel = .physicallyBased
        
        virtualFaceNode.geometry = maskGeometry
        
        // トラッキングの初期化を実行
        resetTracking()
        
        // タップジェスチャ設定を呼び出す
        self.addTapGesture()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override func prefersHomeIndicatorAutoHidden() -> Bool {
//        return true
//    }

    // この ViewController が表示された場合にトラッキングの初期化する
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        resetTracking()
    }

    // この ViewController が非表示になった場合にセッションを止める
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    // Face Tracking の設定を行い
    // オプションにトラッキングのリセットとアンカーを全て削除してセッション開始
    func resetTracking() {
        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    // Face Tracking の起点となるノードの初期設定
    private func setupFaceNodeContent() {
        // faceNode 以下のチルドノードを消す
        for child in faceNode.childNodes {
            child.removeFromParentNode()
        }
        
        // マスクのジオメトリの入った virtualFaceNode をノードに追加する
        faceNode.addChildNode(virtualFaceNode)
    }
    
    // MARK: - ARSCNViewDelegate
    /// ARNodeTracking 開始
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        faceNode = node
        serialQueue.async {
            self.setupFaceNodeContent()
        }
    }
    
    /// ARNodeTracking 更新。ARSCNFaceGeometry の内容を変更する
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor else { return }

        let geometry = virtualFaceNode.geometry as! ARSCNFaceGeometry
        geometry.update(from: faceAnchor.geometry)
    }
    
    // MARK: - ARSessionDelegate
    /// エラーと中断処理
    func session(_ session: ARSession, didFailWithError error: Error) {
        guard error is ARError else { return }
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        DispatchQueue.main.async {
            // 中断復帰後トラッキングを再開させる
            self.resetTracking()
        }
    }

}


// MARK: - UIImagePickerController

extension CameraViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    // タップジェスチャ設定
    func addTapGesture(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        sceneView.addGestureRecognizer(tapGesture)
    }
    
    // タップジェスチャ動作時の関数
    @objc func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        
        if (UIImagePickerController.isSourceTypeAvailable(.photoLibrary) != false) {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .photoLibrary
            self.present(picker, animated:true, completion:nil)
        }else{
            print("fail")
        }
    }
    
    // フォトライブラリで画像選択時の処理
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // オリジナルサイズの画像を選択
        let pickesImage = info[.originalImage] as! UIImage
        
        // マスクにテクスチャを反映させる
        virtualFaceNode.geometry?.firstMaterial?.diffuse.contents = pickesImage
        // UIImagePickerController を閉じる
        dismiss(animated: true, completion: nil)
    }
    
    // フォトライブラリでキャンセルタップ時の処理
    @objc func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // UIImagePickerController を閉じる
        dismiss(animated: true, completion: nil)
    }
    
    //回転用クラス
    func imageRotatedByDegrees(oldImage: UIImage, deg degrees: CGFloat) -> UIImage {
        //Calculate the size of the rotated view's containing box for our drawing space
        let rotatedViewBox: UIView = UIView(frame: CGRect(x: 0, y: 0, width: oldImage.size.width, height: oldImage.size.height))
        let t: CGAffineTransform = CGAffineTransform(rotationAngle: degrees * CGFloat.pi / 180)
        rotatedViewBox.transform = t
        let rotatedSize: CGSize = rotatedViewBox.frame.size
        //Create the bitmap context
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap: CGContext = UIGraphicsGetCurrentContext()!
        //Move the origin to the middle of the image so we will rotate and scale around the center.
        bitmap.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
        //Rotate the image context
        bitmap.rotate(by: (degrees * CGFloat.pi / 180))
        //Now, draw the rotated/scaled image into the context
        bitmap.scaleBy(x: 1.0, y: -1.0)
        bitmap.draw(oldImage.cgImage!, in: CGRect(x: -oldImage.size.width / 2, y: -oldImage.size.height / 2, width: oldImage.size.width, height: oldImage.size.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}

