//
//  ViewController.swift
//  Sunny
//
//  Created by 石井翔真 on 2019/12/06.
//  Copyright © 2019 石井翔真. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    @IBOutlet weak var logoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let _ : Timer = Timer.scheduledTimer(timeInterval: 0.7,  target: self,selector: #selector(anime), userInfo: nil, repeats: false)
        let _ : Timer = Timer.scheduledTimer(timeInterval: 2,  target: self,selector: #selector(pageTransition), userInfo: nil, repeats: false)
    }
    
    @objc func pageTransition(timer : Timer) {
//        let storyboard: UIStoryboard = UIStoryboard(name: "test", bundle: nil)
//        let top = storyboard.instantiateInitialViewController() as! CameraController
//        let storyboard: UIStoryboard = self.storyboard!
//        let top = storyboard.instantiateViewController(identifier: "top") as! topViewController
//        top.modalTransitionStyle = .coverVertical
        
//        self.present(top,animated: true,completion: nil)
        do {
            //do-try-catchの中で、FIRAuth.auth()?.signOut()を呼ぶだけで、ログアウトが完了
            try Auth.auth().signOut()
        } catch let error as NSError {
            print("\(error.localizedDescription)")
        }
        let user = Auth.auth().currentUser
        if (user != nil) && ((user?.isEmailVerified) != nil) {
            self.transitionToView()
        } else {
            let storyboard: UIStoryboard = self.storyboard!
            let top = storyboard.instantiateViewController(identifier: "top") as! topViewController
            top.modalTransitionStyle = .crossDissolve
            self.present(top,animated: true,completion: nil)
        }
    }
    
    func transitionToView() {
        let storyboard: UIStoryboard = UIStoryboard(name: "Sub", bundle: nil)
        let nextView = storyboard.instantiateInitialViewController() as! UIPageViewController
        nextView.modalTransitionStyle = .crossDissolve
        self.present(nextView, animated: true, completion: nil)
    }
    
    @objc func anime() {
        //80%まで縮小させて・・・
        UIView.animate(withDuration: 0.3,
                       delay: 1.0,
                       options: UIView.AnimationOptions.curveEaseOut,
                       animations: { () in
                        self.logoImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }, completion: { (Bool) in
            
        })
        
        //8倍まで拡大！
        UIView.animate(withDuration: 0.2,
                       delay: 1.3,
                       options: UIView.AnimationOptions.curveEaseOut,
                       animations: { () in
                        self.logoImageView.transform = CGAffineTransform(scaleX: 8.0, y: 8.0)
                        self.logoImageView.alpha = 0
        }, completion: { (Bool) in
            //で、アニメーションが終わったらimageViewを消す
            self.logoImageView.removeFromSuperview()
        })
    }
    
    
}

