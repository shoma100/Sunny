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
    
    
    let TODO = ["牛乳を買う", "掃除をする", "アプリ開発の勉強をする"]
    
    
    //最初からあるコード
    override func viewDidLoad() {
        super.viewDidLoad()
        TableView.tableFooterView = UIView()
        let tblBackColor: UIColor = UIColor.clear
        TableView.backgroundColor = tblBackColor
        
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
