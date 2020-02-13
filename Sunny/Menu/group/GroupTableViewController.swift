//
//  GroupTableViewController.swift
//  Sunny
//
//  Created by 石井翔真 on 2020/01/20.
//  Copyright © 2020 石井翔真. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class GroupTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var TableView: UITableView!
    var groupNameList:[[String:Any]] = []
    let currentUser = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        TableView.tableFooterView = UIView()
        TableView.delegate = self
        TableView.dataSource = self
//        let tblBackColor: UIColor = UIColor.clear
//        TableView.backgroundColor = tblBackColor
        getGroupList(comp: {
            self.dismissIndicator()
        })
        startIndicator()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(groupNameList.count)
        return groupNameList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Groupcell", for: indexPath)
        // セルに表示する値を設定する
        print("name = ",groupNameList[indexPath.row]["groupName"] as! String)
        cell.textLabel!.text = groupNameList[indexPath.row]["groupName"] as! String
        return cell
    }
    
    func getGroupList(comp:@escaping() -> Void) {
        DB.getUserJoinGroup(userId: currentUser!.uid, comp: {
            result in
//            self.groupNameList = result
            if result.count == 0 {
                //グループがない場合に表示するview
                self.makeNoneView()
                comp()
            } else {
                self.groupNameList = result
                print("リロードする直前 = ",self.groupNameList)
                DispatchQueue.main.async {
                    self.TableView.reloadData()
                    comp()
                }
            }
        })
    }
    
    @IBAction func backTo(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    fileprivate func makeNoneView() {
        let groupNoneView = UIView(frame: CGRect(x: 0,y: 0,width: self.view.frame.width,height: self.view.frame.height))
        groupNoneView.backgroundColor = UIColor.white
        let title = UILabel(frame: CGRect(x:self.view.frame.width/2,y: self.view.frame.height/2,width: 250,height:250))
        title.text = "グループはありません"
        title.textAlignment = .center
        title.center = self.view.center
        groupNoneView.addSubview(title)
        groupNoneView.backgroundColor = UIColor(red: 255/255, green: 198/255, blue: 122/255, alpha: 1)
        self.view.addSubview(groupNoneView)
    }
}
