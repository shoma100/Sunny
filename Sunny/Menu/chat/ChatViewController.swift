//
//  ChatViewController.swift
//  Sunny
//
//  Created by 石井翔真 on 2020/01/23.
//  Copyright © 2020 石井翔真. All rights reserved.


import UIKit
import MessageKit
import Foundation
import MessageInputBar
import InputBarAccessoryView
import Firebase


class ChatViewController: MessagesViewController{
    
    let ref = Database.database().reference()
    let user = Auth.auth().currentUser
    var userInfo = [String : Any]()
    var messageList: [MockMessage] = []
    
    lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref.child("user").child(user!.uid).observe(.value) {
            (snapshot) in
            
            self.userInfo = snapshot.value as?
                [String : AnyObject] ?? [:]
        }
        DispatchQueue.global().async {
            
            
            DispatchQueue.main.async {
                self.ref.child("chat").queryOrdered(byChild: "room").queryEqual(toValue: 1).observe(DataEventType.value) {
                    (snapshot) in
                    self.messageList.removeAll()
                    // messageListにメッセージの配列をいれて
                    for data in snapshot.children {
                        let snapData = data as! DataSnapshot
                        // Dictionary型にキャスト
                        var user = snapData.value as! [String: Any]
                        user["key"] = snapData.key
                        
                        self.messageList.append(self.getMessages(user: user as [String : Any]))
                    }
                    // messagesCollectionViewをリロードして
                    self.messagesCollectionView.reloadData()
                    // 一番下までスクロールする
                    self.messagesCollectionView.scrollToBottom()
                }
            }
        }
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
        
        messageInputBar.delegate = self
        messageInputBar.sendButton.tintColor = UIColor.lightGray
        
//                // メッセージ入力欄の左に画像選択ボタンを追加
//                // 画像選択とかしたいときに
//                let items = [
//                    makeButton(named: "clip.png").onTextViewDidChange { button, textView in
//                        button.tintColor = UIColor.lightGray
//                        button.isEnabled = textView.text.isEmpty
//                    }
//                ]
//                items.forEach { $0.tintColor = .lightGray }
//                messageInputBar.setStackViewItems(items, forStack: .left, animated: false)
//                messageInputBar.setLeftStackViewWidthConstant(to: 45, animated: false)
        
        // メッセージ入力時に一番下までスクロール
        scrollsToBottomOnKeyboardBeginsEditing = true // default false
        maintainPositionOnKeyboardFrameChanged = true // default false
    }
    
//        // ボタンの作成
//        func makeButton(named: String) -> InputBarButtonItem {
//            return InputBarButtonItem()
//                .configure {
//                    $0.spacing = .fixed(10)
//                    $0.image = UIImage(named: named)?.withRenderingMode(.alwaysTemplate)
//                    $0.setSize(CGSize(width: 30, height: 30), animated: true)
//                }.onSelected {
//                    $0.tintColor = UIColor.gray
//                }.onDeselected {
//                    $0.tintColor = UIColor.lightGray
//                }.onTouchUpInside { _ in
//                    print("Item Tapped")
//            }
//        }
    
    @IBAction func swipe(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    
    
    // サンプル用に適当なメッセージ
    func getMessages(user: [String : Any]) -> MockMessage {
        
        return
            createMessage(data: user)
        
    }
    
    func createMessage(data: [String : Any]) -> MockMessage {
        let attributedText = NSAttributedString(string: data["content"] as! String, attributes: [.font: UIFont.systemFont(ofSize: 15),
                                                                                                 .foregroundColor: UIColor.black])
        return MockMessage(attributedText: attributedText, sender: sender(id: data["senderId"] as! String,displayName: data["name"] as! String) as! Sender, messageId: data["key"] as! String, date: dateFromString(string: data["date"] as! String))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


extension ChatViewController: MessagesDataSource{
    
    func currentSender() -> SenderType {
        return Sender(id: user!.uid, displayName: userInfo["name"] as! String)
    }
    
    func sender(id: String, displayName: String) -> SenderType {
        return Sender(id: id, displayName: displayName)
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messageList.count
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messageList[indexPath.section]
    }
    
    // メッセージの上に文字を表示
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if indexPath.section % 3 == 0 {
            return NSAttributedString(
                string: MessageKitDateFormatter.shared.string(from: message.sentDate),
                attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10),
                             NSAttributedString.Key.foregroundColor: UIColor.darkGray]
            )
        }
        return nil
    }
    
    // メッセージの上に文字を表示（名前）
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let name = message.sender.displayName
        return NSAttributedString(string: name, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1)])
    }
    
    // メッセージの下に文字を表示（日付）
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let dateString = formatter.string(from: message.sentDate)
        return NSAttributedString(string: dateString, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2)])
    }
}

// メッセージのdelegate
extension ChatViewController: MessagesDisplayDelegate{
    
    // メッセージの色を変更（デフォルトは自分：白、相手：黒）
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .white : .darkText
    }
    
    // メッセージの背景色を変更している（デフォルトは自分：緑、相手：グレー）
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ?
            UIColor(red: 69/255, green: 193/255, blue: 89/255, alpha: 1) :
            UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
    }
    
    // メッセージの枠にしっぽを付ける
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(corner, .curved)
    }
    
    // アイコンをセット
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        // message.sender.displayNameとかで送信者の名前を取得できるので
        // そこからイニシャルを生成するとよい
//        isFromCurrentSender(message: message) ? currentImageSet(avatarView: avatarView) : otherImageSet(avatarView: avatarView)
        ref.child("user").child(message.sender.senderId).observeSingleEvent(of: DataEventType.value, with: {
            (snapshot) in
            let user = snapshot.value as! [String : Any]
            if let accountImgURL = user["iconURL"] {
                do {
                    let url = URL(string: accountImgURL as! String)
                    let data = try Data(contentsOf: url!)
                    let avatar = Avatar(image: UIImage(data: data))
                    avatarView.set(avatar: avatar)
                } catch {
                    print(error)
                }
            } else {
                let avatar = Avatar(initials: "人")
                avatarView.set(avatar: avatar)
            }
            }) { (error) in
              print(error.localizedDescription)
        }
        
    }
    
    func currentImageSet(avatarView: AvatarView) {
        ref.child("user").child(user!.uid).observeSingleEvent(of: .value, with: {
            (snapshot) in
            let user = snapshot.value as! [String : Any]
            if let accountImgURL = user["iconURL"] {
                do {
                    let url = URL(string: accountImgURL as! String)
                    let data = try Data(contentsOf: url!)
                    let avatar = Avatar(image: UIImage(data: data))
                    avatarView.set(avatar: avatar)
                } catch {
                    print(error)
                }
            } else {
                let avatar = Avatar(initials: "人")
                avatarView.set(avatar: avatar)
            }
            }) { (error) in
              print(error.localizedDescription)
        }
    }
    
    func otherImageSet(avatarView: AvatarView) {
        let avatar = Avatar(initials: "人")
        avatarView.set(avatar: avatar)
    }
}

// 各ラベルの高さを設定（デフォルト0なので必須）
extension ChatViewController: MessagesLayoutDelegate{
    
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if indexPath.section % 3 == 0 { return 10 }
        return 0
    }
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 16
    }
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 16
    }
    
}

extension ChatViewController: MessageCellDelegate{
    
    // メッセージをタップした時の挙動
    func didTapMessage(in cell: MessageCollectionViewCell) {
        print("Message tapped")
        self.view.endEditing(true)
    }
    
}


extension ChatViewController: MessageKit.MessageInputBarDelegate{
    
    // メッセージ送信ボタンをタップした時の挙動
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        //入力欄が空欄ならその後の処理をしない
        guard inputBar.inputTextView.text != nil else { return }
        
        
        for component in inputBar.inputTextView.components {
            if let image = component as? UIImage {
                
                let imageMessage = MockMessage(image: image, sender: currentSender() as! Sender, messageId: UUID().uuidString, date: Date())
                messageList.append(imageMessage)
                messagesCollectionView.insertSections([messageList.count - 1])
                
            } else if let text = component as? String {
                let data = ["content": text, "date": stringFromDate(date: Date(), format: "yyyy-MM-dd HH:mm:ss"),"name": self.userInfo["name"],"room": 1,"senderId": user?.uid]
                ref.child("chat").childByAutoId().setValue(data)
                //                let attributedText = NSAttributedString(string: text, attributes: [.font: UIFont.systemFont(ofSize: 15),
                //                                                                                   .foregroundColor: UIColor.white])
                //                let message = MockMessage(attributedText: attributedText, sender: currentSender() as! Sender, messageId: UUID().uuidString, date: Date())
                //                print(message)
                //                messageList.append(message)
                //                messagesCollectionView.insertSections([messageList.count - 1])
            }
            
        }
        inputBar.inputTextView.text = String()
        messagesCollectionView.scrollToBottom()
    }
    
    func dateFromString(string: String) -> Date {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return formatter.date(from: string)!
    }
    
    func stringFromDate(date: Date, format: String) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
