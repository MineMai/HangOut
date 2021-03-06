//
//  AllActVC.swift
//  AllTogeter
//
//  Created by YenShao on 2017/3/17.
//  Copyright © 2017年 YenShao. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import SVProgressHUD

class AllActVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    
    @IBOutlet weak var allTableView: UITableView!
    
    
    let pullToRefreshControl = UIRefreshControl()
    
    let searchResultController = UITableViewController()
    var searchController:UISearchController?
    var searchArray = [ActMsg]() //存搜尋的結果

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //allTableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        searchController = UISearchController(searchResultsController: searchResultController)
        allTableView.tableHeaderView = searchController?.searchBar
        
        searchController?.searchResultsUpdater = self
        searchResultController.tableView.delegate = self
        searchResultController.tableView.dataSource = self
        
        
        //移除返回鈕的文字
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        //指定menuBarButton的目標是側邊欄controller
        if revealViewController() != nil
        {
            menuBarButton.target = revealViewController()
            menuBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
        
        //加入下拉更新
        allTableView.refreshControl = pullToRefreshControl
        pullToRefreshControl.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        
        
        
        //偷印使用者是誰登入
        let currentID = FIRAuth.auth()?.currentUser?.uid
        print("主頁currentUser = \(currentID) \n")
        print("主頁FBCurrentUser = \(FBSDKAccessToken.current()) \n")
        
        if let user = FIRAuth.auth()?.currentUser
        {
            for profile in user.providerData //可以判斷是由哪個管道登入
            {
                let providerId = profile.providerID
                //let uid = profile.uid // Provider-specific UID
                let name = profile.displayName
                let email = profile.email
                let photoUrl = profile.photoURL
                //print("userUID = \(uid)")
                //print("userName = \(name)")
                //print("useremail = \(email)")
                //print("userphotoUrl = \(photoUrl)")
                //print("userproviderId = \(providerId)")
                if providerId == "facebook.com"
                {
                    isFBLogin = true
                    fbUsers = FBUsers(name: name!, email: email!, pictureURL: photoUrl!)
                }
                else
                {
                    isFBLogin = false
                }
            }
            //loadData讀值
            loadProfileImage()
            loadData()
            
        }
        else
        {
            print("No user is signed in")
            
        }
        
        //設定轉轉轉
        SVProgressHUD.setDefaultStyle(.light) //轉轉小方框的 亮暗
        SVProgressHUD.setDefaultMaskType(.black) //轉轉背景的 亮暗
        SVProgressHUD.show(withStatus: "Loading")
        
    }
    
    // MARK: - 搜尋列協定方法
    //這方法就是要來搜尋的
    func updateSearchResults(for searchController: UISearchController)
    {
        if let searchWord = searchController.searchBar.text //取出搜尋欄的文字
        {
            //searchArray是搜尋的結果，filter過濾完後會把值丟出來
            searchArray = actMsg.filter({
                (msg) -> Bool in
                           //都先把字轉成小寫再比對
                if msg.topic.lowercased().contains(searchWord.lowercased()) {
                    return true
                }
                else {
                    return false
                }
            })
            self.searchResultController.tableView.reloadData()
        }
        
    }
    
    
    // MARK: - 下拉更新
    func refreshTable()
    {
        loadData()
        allTableView.reloadData()
        pullToRefreshControl.endRefreshing()
    }
    
    
    
    // MARK: - loadData
    func loadData()
    {
        SVProgressHUD.setDefaultStyle(.light) //轉轉小方框的 亮暗
        SVProgressHUD.setDefaultMaskType(.black) //轉轉背景的 亮暗
        SVProgressHUD.show(withStatus: "Loading")
        
        let currentID = FIRAuth.auth()?.currentUser?.uid
        
        let queryOrder = DBProvider.Instance.dbRef.child("Activity").queryOrdered(byChild: "time")
        
        queryOrder.observe(.value, with: { (snapshots) in
            
            actMsg = []
            hostMsg = []
            if let snapshot = snapshots.children.allObjects as? [FIRDataSnapshot]
            {
                for snap in snapshot
                {
                    if let snapDict = snap.value as? Dictionary<String, String
                        >
                    {
                        let autoKey = snap.key
                        let imageString = snapDict["imageURL"]!
                        let act = ActMsg(from: snapDict["from"]! , topic: snapDict["topic"]! , place: snapDict["place"]! , time: snapDict["time"]! , kind: snapDict["kind"]! , people: snapDict["people"]! , imageURL: imageString , currentID: currentID!, autoKey: autoKey)
                        actMsg.append(act)
                        if currentID == snapDict["from"]
                        {
                            hostMsg.append(act)
                        }
                    }
                }
            }
            self.allTableView.reloadData()
        })
        
        //-----撈Apply資料-----------------------------------------
        
        let apply_request = DBProvider.Instance.dbRef.child("Apply_Request")
        
        apply_request.observe(.value, with: { (snapshots) in
            
            applyMsg = []
            
            if let snapshot = snapshots.children.allObjects as? [FIRDataSnapshot]
            {
                for snap in snapshot
                {
                    if let snapDicts = snap.children.allObjects as? [FIRDataSnapshot]
                    {
                        for snapDict in snapDicts //snapDict.key可取到活動key
                        {
                            if let snapData = snapDict.value as? Dictionary<String, String>
                            {
                                let apply = snapData["apply"]
                                //let host = snapData["host"]
                                if currentID == apply
                                {
                                    //如果一樣就把活動Key存起來
                                    applyMsg.append(snapDict.key)
                                }
                                
                            }
                        }
                    }
                    
                }
                
            }
            
        })
        
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == allTableView
        {
            return actMsg.count
        }
        else
        {
            return searchArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == allTableView
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AllActCell", for: indexPath) as! AllActTBCell
            
            cell.activityTopicLabel.text = ""
            cell.activityTimeLabel.text = ""
            cell.activityKindLabel.text = ""
            cell.activityImage.image = UIImage(named: "picture_placeholder.png")
            
            cell.activityTopicLabel.text = actMsg[indexPath.row].topic
            cell.activityTimeLabel.text = actMsg[indexPath.row].time
            cell.activityKindLabel.text = actMsg[indexPath.row].kind
            
            let cacheURL = URL(string: actMsg[indexPath.row].imageURL)
            
            cell.activityImage.sd_setImage(with: cacheURL)
            
            SVProgressHUD.dismiss()
            
            return cell
        }
        else
        {
            let cell = UITableViewCell()
            cell.textLabel?.text = searchArray[indexPath.row].topic
            return cell
        }
        
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "detailSegue"
        {
            let dvc = segue.destination as? DetailVC
            dvc?.detailindex = allTableView.indexPathForSelectedRow?.row
        
        }
    }
    
    
    
    
    
    //取消點選的灰色
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    //給側邊欄用的
    func loadProfileImage()
    {
        let currentID = FIRAuth.auth()?.currentUser?.uid
        
        DBProvider.Instance.dbRef.child("Users").child(currentID!).observeSingleEvent(of: .value) { (snapshot:FIRDataSnapshot) in
            
            let snap = snapshot.value as! [String:String]
            var userName = snap["name"]
            
            var userImageURL = snap["Image"]
            
            
            if userImageURL == nil
            {
                userImageURL = "gs://alltogeter-573f4.appspot.com/profile_picture.png"
            }
            if userName == nil
            {
                userName = "未命名"
            }
            
            sideProfileName = userName
            
            if isFBLogin
            {
                sideProfileImage = try! UIImage(data: Data(contentsOf: (fbUsers?.pictureURL)!))
            }
            else
            {
                let storage = FIRStorage.storage()
                let imageURL = storage.reference(forURL: userImageURL!)
                
                imageURL.downloadURL(completion: { (url, error) in
                    
                    if error != nil {
                        print("downloadURL Error:\(error?.localizedDescription)")
                        return
                    }
                    
                    URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                        
                        if error != nil {
                            print(error)
                            return
                        }
                        
                        guard let imageData = UIImage(data: data!) else { return }
                        sideProfileImage = imageData
    
                        DispatchQueue.main.async {
                            
                        }
                        
                    }).resume()
                })
            }
        }
    }
    
    
    
    

}

//extension NSCache
//{
//    class var sharedInstance : NSCache<NSString, AnyObject>
//    {
//        let cache = NSCache<NSString, AnyObject>()
//        return cache
//    }
//}












