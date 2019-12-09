//
//  ViewController.swift
//  Sunny
//
//  Created by 石井翔真 on 2019/12/06.
//  Copyright © 2019 石井翔真. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let _ : Timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(pageTransition), userInfo: nil, repeats: false)
    }
    
    @objc func pageTransition(timer : Timer) {
            let storyboard: UIStoryboard = self.storyboard!
            let top = storyboard.instantiateViewController(identifier: "top")
            self.present(top,animated: false,completion: nil)
        }


    
}

