//
//  AccountSetViewController.swift
//  Sunny
//
//  Created by 原涼馬 on 2019/12/16.
//  Copyright © 2019 石井翔真. All rights reserved.
//

import UIKit
import Firebase

class AccountSetViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let ref = Database.database().reference()
    let user = Auth.auth().currentUser
    var accountImgURL:URL!
    let imagePicker = UIImagePickerController()
    let storage = Storage.storage()
    @IBOutlet weak var unm: UILabel!
    @IBOutlet weak var accountImg: UIImageView!
    
    
    override func viewDidLoad(){
        imagePicker.delegate = self
        
        // 角を丸くする
        accountImg.contentMode = .scaleAspectFill
        accountImg.layer.cornerRadius = accountImg.frame.width/2
        accountImg.clipsToBounds = true
        
        accountImg.isUserInteractionEnabled = true
        accountImg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.imageTaped(_:))))
        
        if let user = Auth.auth().currentUser {
            if let accountImgURL = user.photoURL {
                do {
                    let url = URL(string: accountImgURL.absoluteString)
                    let data = try Data(contentsOf: url!)
                    self.accountImg.image = UIImage(data: data)
                } catch {
                    print(error)
                }
            } else {
                self.accountImg.image = UIImage(named: "AppIcon")
            }
        }
        
        ref.child("user").child(user!.uid).observe(.value) { (snapshot) in
            let data = snapshot.value as? [String : AnyObject] ?? [:]
            let name = data["name"] as? String
            _ = data["id"] as? String
            self.unm.text = name!
        }
    }
    
    @objc func imageTaped(_ sender : UITapGestureRecognizer) {
        imagePicker.allowsEditing = true //画像の切り抜きが出来るようになります。
        imagePicker.sourceType = .photoLibrary //画像ライブラリを呼び出します
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func logout() {
        do {
            //do-try-catchの中で、FIRAuth.auth()?.signOut()を呼ぶだけで、ログアウトが完了
            try Auth.auth().signOut()
            
            //先頭のNavigationControllerに遷移
            let storyboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "top")
            self.present(storyboard, animated: true, completion: nil)
        }catch let error as NSError {
            print("\(error.localizedDescription)")
        }
    }
    
    @IBAction func backTo(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //自分自身のユーザ情報の更新
    public func updateMyphotoURL(photoURL:URL) {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.photoURL = photoURL
        changeRequest?.commitChanges { (error) in
            //FIXME: エラーハンドリング
            print(error.debugDescription)
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            accountImg.contentMode = .scaleAspectFit
            accountImg.image = pickedImage
        }
        upload(comp: { url in
            if let u = url {
                self.updateMyphotoURL(photoURL: u)
            } else {
                // do nothing..
            }
        })
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    private func upload(comp:@escaping(URL?) -> Void) {
        let date = NSDate()
        let currentTimeStampInSecond = UInt64(floor(date.timeIntervalSince1970 * 1000))
        let storageRef = Storage.storage().reference().child("images").child("\(currentTimeStampInSecond).jpg")
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        if let uploadData = self.accountImg.image?.jpegData(compressionQuality: 0.9) {
            storageRef.putData(uploadData, metadata: metaData) { (metadata , error) in
                if let e = error {
                    print("error: \(e.localizedDescription)")
                }
                storageRef.downloadURL(completion: { (url, error) in
                    if let e = error {
                        print("error: \(e.localizedDescription)")
                        comp(nil)
                    }
                    if let u = url {
                        print("url: \(u.absoluteString)")
                        comp(u)
                    }
                })
            }
        }
    }
    
}
