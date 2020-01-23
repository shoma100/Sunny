//
//  PageViewController.swift
//  Sunny
//
//  Created by 原涼馬 on 2020/01/21.
//  Copyright © 2020 石井翔真. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViewControllers([getSecond()], direction: .forward, animated: true, completion: nil)
        self.dataSource = self
    }

    func getFirst() -> CameraViewController {
        var storyboard: UIStoryboard = UIStoryboard(name: "Camera", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "camera") as! CameraViewController
    }

    func getSecond() -> MyAccountViewController {
        var storyboard: UIStoryboard = UIStoryboard(name: "Sub", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "MyAccountViewController") as! MyAccountViewController
    }

    func getThird() -> ChatListViewController {
        var storyboard: UIStoryboard = UIStoryboard(name: "Sub", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "chatlist") as! ChatListViewController
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension PageViewController : UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if viewController.isKind(of: ChatListViewController.self) {
            // 3 -> 2
            return getSecond()
        } else if viewController.isKind(of: MyAccountViewController.self) {
            // 2 -> 1
            return getFirst()
        } else {
            // 1 -> end of the road
            return nil
        }
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if viewController.isKind(of: CameraViewController.self) {
            // 1 -> 2
            return getSecond()
        } else if viewController.isKind(of: MyAccountViewController.self) {
            // 2 -> 3
            return getThird()
        } else {
            // 3 -> end of the road
            return nil
        }
    }
}
