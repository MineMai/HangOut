//
//  HostListTBVC.swift
//  AllTogeter
//
//  Created by YenShao on 2017/3/22.
//  Copyright © 2017年 YenShao. All rights reserved.
//

import UIKit
import Firebase

class HostListTBVC: UITableViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return hostMsg.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HostListCell
        
        cell.hostImage.image = nil
        cell.topicLabel.text = hostMsg[indexPath.row].topic
        cell.timeLabel.text = hostMsg[indexPath.row].time
    
        //-----------------------------------------------------
        let cacheURL = URL(string: hostMsg[indexPath.row].imageURL)
        
        cell.hostImage.sd_setImage(with: cacheURL)
        

        return cell
    }
    
    
    //取消點選的灰色
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    
    

}













