//
//  GroupTableViewController.swift
//  Sunny
//
//  Created by 石井翔真 on 2020/01/20.
//  Copyright © 2020 石井翔真. All rights reserved.
//

import Foundation
import UIKit

class GroupTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
 
    @IBOutlet weak var TableView: UITableView!
    var groupNoneView:UIView?
    
    let TODO:[String] = []
    
    //最初からあるコード
    override func viewDidLoad() {
        super.viewDidLoad()
        TableView.tableFooterView = UIView()
        let tblBackColor: UIColor = UIColor.clear
        TableView.backgroundColor = tblBackColor
        
        //グループがない場合に表示するview
        if TODO.count == 0 {
            groupNoneView = UIView(frame: CGRect(x: 0,y: 0,width: self.view.frame.width,height: self.view.frame.height))
            groupNoneView?.backgroundColor = UIColor.white
            let title = UILabel()
            title.text = "グループはありません"
            title.frame = CGRect(x:self.view.frame.width/2,y: self.view.frame.height/2,width: 250,height:250)
            title.textAlignment = .center
            title.center = self.view.center
            groupNoneView?.addSubview(title)
            self.view.addSubview(groupNoneView!)
        }
    }
    //最初からあるコード
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TODO.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Groupcell", for: indexPath)
        // セルに表示する値を設定する
        cell.textLabel!.text = TODO[indexPath.row]
        return cell
    }
    
    @IBAction func backTo(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
