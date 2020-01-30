//
//  UIViewController+Extension.swift
//  Where
//
//  Created by しゅん on 2019/12/29.
//  Copyright © 2019 g-chan. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {

    func startIndicator() {

        let loadingIndicator = UIActivityIndicatorView(style: .whiteLarge)

        loadingIndicator.center = self.view.center
        let grayOutView = UIView(frame: self.view.frame)
        grayOutView.backgroundColor = .black
        grayOutView.alpha = 0.6

        // 他のViewと被らない値を代入
        loadingIndicator.tag = 999
        grayOutView.tag = 999

        self.view.addSubview(grayOutView)
        self.view.addSubview(loadingIndicator)
        self.view.bringSubviewToFront(grayOutView)
        self.view.bringSubviewToFront(loadingIndicator)

        loadingIndicator.startAnimating()
    }

    func dismissIndicator() {
        self.view.subviews.forEach {
            if $0.tag == 999 {
                $0.removeFromSuperview()
            }
        }
    }

}
