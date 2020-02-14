//
//  AccountSetViewController.swift
//  Sunny
//
//  Created by 原涼馬 on 2019/12/16.
//  Copyright © 2019 石井翔真. All rights reserved.
//

import UIKit
import Firebase
import Nuke

class AccountSetViewController: UITableViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let ref = Database.database().reference()
    let user = Auth.auth().currentUser
    var accountImgURL:URL!
    let imagePicker = UIImagePickerController()
    let storage = Storage.storage()
    
    //tableViewのバックグラウンドカラー
    public let backGroundColor:UIColor = UIColor(red: 255/255, green: 198/255, blue: 122/255, alpha: 1)
    
    @IBOutlet weak var table:UITableView!
    @IBOutlet weak var accountImg: UIImageView!
    
    override func viewDidLoad(){
        self.view.backgroundColor = backGroundColor
        
        imagePicker.delegate = self
        
        // 角を丸くする
        accountImg.contentMode = .scaleAspectFill
        accountImg.layer.cornerRadius = accountImg.frame.height/2
        accountImg.clipsToBounds = true
        
        accountImg.isUserInteractionEnabled = true
        accountImg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.imageTaped(_:))))
        
        ref.child("user").child(user!.uid).observe(DataEventType.value, with: {
            (snapshot) in
            let user = snapshot.value as! [String : Any]
            if let accountImgURL = user["iconURL"] {
                do {
                    let url = URL(string: accountImgURL as! String)
                    let options = ImageLoadingOptions(
                       placeholder: UIImage(named: "AppIcon"),
                       transition: .fadeIn(duration: 0.5)
                     )
                     Nuke.loadImage(with: url!,options: options, into: self.accountImg)
                } catch {
                    print(error)
                }
            } else {
                self.accountImg.image = UIImage(named: "AppIcon")
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        //
        //        ref.child("user").child(user!.uid).observe(.value) { (snapshot) in
        //            let data = snapshot.value as? [String : AnyObject] ?? [:]
        //            let name = data["name"] as? String
        //            _ = data["id"] as? String
        //            self.unm.text = name!
        //        }
    }
    
    @objc func imageTaped(_ sender : UITapGestureRecognizer) {
        imagePicker.allowsEditing = true //画像の切り抜きが出来るようになります。
        imagePicker.sourceType = .photoLibrary //画像ライブラリを呼び出します
        present(imagePicker, animated: true, completion: nil)
    }
    
    func logout() {
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
    
    //自分自身のユーザ情報の更新
    public func updateMyphotoURL(photoURL:URL) {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.photoURL = photoURL
        changeRequest?.commitChanges { (error) in
            //FIXME: エラーハンドリング
            print(error.debugDescription)
        }
        ref.child("user").child(user!.uid).updateChildValues(["iconURL": photoURL.absoluteString])
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
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
    
    //Headerの高さ
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 60
    }
    //Footerの高さ
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    //Headerが表示される時の処理
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        //Headerのラベルの文字色を設定
        header.textLabel?.textColor = UIColor.black
        //Headerの背景色を設定
        header.contentView.backgroundColor = backGroundColor
    }
    //Footerが表示される時の処理
    override func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        guard let footer = view as? UITableViewHeaderFooterView else { return }
        //Footerのラベルの文字色を設定
        footer.textLabel?.textColor = UIColor.white
        //Footerの背景色を設定
        footer.contentView.backgroundColor = backGroundColor
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: // 「全般」のセクション
            return 5
        case 1: // 「一般」のセクション
            return 1
        case 2: //　「その他」のセクション
            return 1
        default: // ここが実行されることはないはず
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                // 画像
                //self.performSegue(withIdentifier: "toAccountSegue", sender: nil)
                break
            case 1:
                // 名前
                performSegue(withIdentifier: "showChangeUserName", sender: nil)
                break
            case 2:
                // ユーザID
                //self.performSegue(withIdentifier: "toPrivacySegue", sender: nil)
                break
            case 3:
                // 生年月日
                performSegue(withIdentifier: "showChangeBirthday", sender: nil)
                break
            case 4:
                // パスワード
                performSegue(withIdentifier: "showChangePassword", sender: nil)
                break
            default:
                // ここに来ることはない..
                break
            }
        case 1:
            // アカウント設定
            switch indexPath.row {
            case 0:
                // ブロックしたユーザ
                performSegue(withIdentifier: "showBlockUser", sender: nil)
                break
            default:
                // ここに来ることはない..
                break
            }
        case 2:
            // ログアウト
            switch indexPath.row {
            case 0:
                // ログアウト
                //self.performSegue(withIdentifier: "", sender: nil)
                logout()
                break
            default:
                // ここに来ることはない..
                break
            }
        default:
            // ここに来ることはない..
            break
        }
        table.deselectRow(at: indexPath as IndexPath, animated: true)
    }
    
}
