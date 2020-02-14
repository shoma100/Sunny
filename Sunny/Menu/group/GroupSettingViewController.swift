//
//  GroupSettingViewController.swift
//  Sunny
//
//  Created by しゅん on 2020/01/30.
//  Copyright © 2020 石井翔真. All rights reserved.
//

import UIKit
import Firebase

class GroupSettingViewController: UIViewController,UITableViewDelegate,UITableViewDataSource , UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate{
    
    @IBOutlet weak var groupIconImage: UIImageView!
    @IBOutlet weak var groupNameTextFiled: UITextField!
    @IBOutlet weak var memberList: UITableView!
    let currentUser = Auth.auth().currentUser
    var ref:DatabaseReference!
    let imagePicker = UIImagePickerController()
    public var member:[Account] = []
    public var memberDic:[String:Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        memberList.delegate = self
        memberList.dataSource = self
        imagePicker.delegate = self
        groupNameTextFiled.delegate = self
        navigationController?.delegate = self
        
        //デフォルトグループアイコン
        groupIconImage.image = UIImage(named: "AppIcon")
        //角を丸くする
        groupIconImage.contentMode = .scaleAspectFill
        groupIconImage.layer.cornerRadius = groupIconImage.frame.width/2
        groupIconImage.clipsToBounds = true
        //写真追加処理
        groupIconImage.isUserInteractionEnabled = true
        groupIconImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.imageTaped(_:))))
        
        groupNameTextFiled.becomeFirstResponder()
        
        // myTextFieldの入力チェック(文字数チェック)をオブザーバ登録
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textFieldDidChange(notification:)),
                                               name: UITextField.textDidChangeNotification,
                                               object: groupNameTextFiled)
        
    }
    // オブザーバの破棄
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func textFieldDidChange(notification: NSNotification) {
        let textField = notification.object as! UITextField
        let nextActionBar = UIBarButtonItem(title: "作成", style: .plain, target: self, action: #selector(loadUi))
        if let _ = textField.text {
            if 0 >= textField.text!.count {
                self.navigationItem.setRightBarButton(nil, animated: true)
            } else {
                if let _ = navigationItem.rightBarButtonItem {
                    //do nothing..
                } else {
                    self.navigationItem.setRightBarButton(nextActionBar, animated: true)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        member.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Groupcell", for: indexPath)
        // セルに表示する値を設定する
        cell.textLabel!.text = member[indexPath.row].getDisplayName()
        return cell
    }
    
    //セルの編集許可
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool{
        return true
    }
    
    //スワイプしたセルを削除　※arrayNameは変数名に変更してください
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            member.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
        }
    }
    
    // UINavigationControllerDelegateのメソッド。遷移する直前の処理
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let controller = viewController as? GroupCreateViewController {
            controller.selectedFriends = []
        }
    }
    
    @objc func imageTaped(_ sender : UITapGestureRecognizer) {
        imagePicker.allowsEditing = true //画像の切り抜きが出来るようになります。
        imagePicker.sourceType = .photoLibrary //画像ライブラリを呼び出します
        present(imagePicker, animated: true, completion: nil)
    }
    
    fileprivate func createGroup(comp:@escaping() -> Void) {
        let uuid = NSUUID().uuidString
        let groupName = groupNameTextFiled.text!
        memberDic[currentUser!.uid] = true
        let memberCount = member.count+1
        for i in member {
            memberDic[i.getUserId()] = true
        }
        //TODO: DB登録、画面遷移
        upload(comp: {
            url in
            if let u = url {
                let newGroup = group(groupUid: uuid,
                                     groupName: groupName,
                                     imagePath: u,
                                     memberList: self.memberDic,
                                     memberCount: memberCount)
                self.addGroupDB(group: newGroup)
            }
            comp()
        })
    }
    
    @objc func loadUi(_ selder: UIBarButtonItem) {
        createGroup(comp: {
            //くるくる終了
            self.dismissIndicator()
            self.backTwo()
            
        })
        //くるくる開始
        startIndicator()
    }
    
    //　グループの登録
    private func addGroupDB(group:group) {
        ref = Database.database().reference();
        let newRF = ref.child("group").child(group.getGorupUid())
        newRF.setValue(group.toDictionary())
        ref.child("user").child(currentUser!.uid).updateChildValues(["group": [group.getGorupUid(): true]])
    }
    
    //　ボルトの登録
    private func addVaultDB(group:group) {
        ref = Database.database().reference();
        let newRF = ref.child("group").child(group.getGorupUid())
        newRF.setValue(group.toDictionary())
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            groupIconImage.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    private func upload(comp:@escaping(URL?) -> Void) {
        let date = NSDate()
        let currentTimeStampInSecond = UInt64(floor(date.timeIntervalSince1970 * 1000))
        let storageRef = Storage.storage().reference().child("images").child("group").child("\(currentTimeStampInSecond).jpg")
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        if let uploadData = self.groupIconImage.image?.jpegData(compressionQuality: 0.9) {
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
    
    func backTwo() {
      // 遷移履歴を二つ戻る
      let count = navigationController!.viewControllers.count - 3
      let target = navigationController!.viewControllers[count]
      navigationController?.popToViewController(target as UIViewController, animated: true)
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
