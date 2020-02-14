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
        self.setViewControllers([getInit()], direction: .forward, animated: true, completion: nil)
        self.dataSource = self
    }
    
    
    func getInit() -> UINavigationController {
        var storyboard: UIStoryboard = UIStoryboard(name: "Sub", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "navigationRoot") as! UINavigationController
    }

    func getFirst() -> CameraController {
        var storyboard: UIStoryboard = UIStoryboard(name: "test", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "cam") as! CameraController
    }

    func getSecond() -> MyAccountViewController {
        var storyboard: UIStoryboard = UIStoryboard(name: "Sub", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "MyAccountViewController") as! MyAccountViewController
    }

    func getThird() -> ChatViewController {
        var storyboard: UIStoryboard = UIStoryboard(name: "Sub", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "chat") as! ChatViewController
    }
    
    func getChatList() -> UINavigationController {
        var storyboard: UIStoryboard = UIStoryboard(name: "Sub", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "chatNavi") as! UINavigationController
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension PageViewController : UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        print("viewcon = ",viewController.view,"id = ",viewController.restorationIdentifier)
//        if viewController.isKind(of: ChatListViewController.self) {
//            // 3 -> 2
//            return getInit()
//        } else if viewController.isKind(of: UINavigationController.self) {
//            // 2 -> 1
//            return getFirst()
//        } else {
//            // 1 -> end of the road
//            return nil
//        }
        if viewController.restorationIdentifier == "chatNavi" {
            // 3 -> 2
            return getInit()
        } else {
            // 1 -> end of the road
            return nil
        }
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        print("title = ",self.navigationController?.viewControllers[0],"id = ",self.restorationIdentifier)
//        if viewController.isKind(of: CameraController.self) {
//            // 1 -> 2
//            return getInit()
//        } else if viewController.isKind(of: UINavigationController.self) {
//            // 2 -> 3
//            return getThird()
//        } else {
//            // 3 -> end of the road
//            return nil
//        }
        if viewController.restorationIdentifier == "navigationRoot" {
            // MyaccountView -> chatList
            return getChatList()
        } else {
            // 1 -> end of the road
            return nil
        }
    }
}
