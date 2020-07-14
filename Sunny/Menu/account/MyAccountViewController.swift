//
//  MyAccountViewController.swift
//  Sunny
//
//  Created by 原涼馬 on 2019/12/16.
//  Copyright © 2019 石井翔真. All rights reserved.
//

import UIKit
import Firebase
import Nuke

class MyAccountViewController: UIViewController {
    let ref = Database.database().reference()
    let user = Auth.auth().currentUser
    @IBOutlet weak var uid: UILabel!
    @IBOutlet weak var unm: UILabel!
    @IBOutlet weak var accountImg: UIImageView!
    
    override func viewDidLoad() {
        
        // 角を丸くする
        accountImg.contentMode = .scaleAspectFill
        accountImg.layer.cornerRadius = accountImg.frame.width/2
        accountImg.clipsToBounds = true

        ref.child("user").child(user!.uid).observe(DataEventType.value, with: {
            (snapshot) in
            let user = snapshot.value as! [String : Any]
            if let accountImgURL: String = user["iconURL"] as? String {
                do {
                    if (accountImgURL.isEmpty) {
                        self.accountImg.image = UIImage(named: "AppIcon")
                        return
                    }
                    let url = URL(string: accountImgURL)
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
        DB.getUserInfo_o(userId: user!.uid, comp: {
            value in
            
            if let name = value["displayName"] {
                self.unm.text = name as! String
                self.uid.text = value["searchId"] as! String
            } else {
                DB.getUserInfo(userId: self.user!.uid, comp: {
                    item in
                    self.unm.text = item!.getDisplayName()
                    self.uid.text = item!.getSearchId()
                })
                
            }
        })
    }
    @IBAction func toCamera(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "test", bundle: nil)
        let nextView = storyboard.instantiateInitialViewController() as! CameraController
        nextView.modalPresentationStyle = .fullScreen
        self.present(nextView, animated: true, completion: nil)
    }
    
    
    @IBAction func tappedAccountSetting(_ sender: Any) {
        self.performSegue(withIdentifier: "showAccountSegue", sender: nil)
    }
    
    
    
}
