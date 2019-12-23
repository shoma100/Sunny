//
//  AccountDetails.swift
//  Sunny
//
//  Created by 石井翔真 on 2019/12/23.
//  Copyright © 2019 石井翔真. All rights reserved.
//

import Foundation
import UIKit

class AccountDetailsViewController: UIViewController {
    
    func logout() {
       
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nextView = storyboard.instantiateInitialViewController() as! ViewController
        self.present(nextView, animated: true, completion: nil)

        
    }
    
}
