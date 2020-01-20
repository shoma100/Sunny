//
//  TableViewController.swift
//  Sunny
//
//  Created by 石井翔真 on 2020/01/17.
//  Copyright © 2020 石井翔真. All rights reserved.
//

import Foundation
import UIKit

class FriendTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    let TODO = ["牛乳を買う", "掃除をする", "アプリ開発の勉強をする"]
    

    
    //最初からあるコード
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        let tblBackColor: UIColor = UIColor.clear
        tableView.backgroundColor = tblBackColor
    }
    //最初からあるコード
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    //セルの個数を指定するデリゲートメソッド（必須）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TODO.count
    }
    
    //セルに値を設定するデータソースメソッド（必須）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Friendcell", for: indexPath)
        // セルに表示する値を設定する
        cell.textLabel!.text = TODO[indexPath.row]
        return cell
    }
    

    
}
