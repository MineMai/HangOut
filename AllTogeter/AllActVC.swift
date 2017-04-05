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
import UserNotifications

class AllActVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    
    @IBOutlet weak var allTableView: UITableView!
    
    
    let pullToRefreshControl = UIRefreshControl()
    
    //實作搜尋列要用的
    let searchResultController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "searchTable") as! SearchTBVC
    var searchController:UISearchController?
    
    var isFirst = true //檢查chieldadd是否第一次執行用
    var isFirst2 = true //檢查chieldadd是否第一次執行用

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchResultController.tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
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
        
        //判斷網路
        if isInternetOk()
        {
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
            
            checkWhoApply()
            //checkPushForUser()
        }
        else
        {
            SVProgressHUD.showError(withStatus: "無網路連線")
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searchController?.searchBar.text = "" //清空搜尋列的文字
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
        //SVProgressHUD.setDefaultStyle(.light) //轉轉小方框的 亮暗
        //SVProgressHUD.setDefaultMaskType(.black) //轉轉背景的 亮暗
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
            applyKey = []
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
                                    applyKey.append(snapDict.key)
                                }
                                //-----試做報名通知---------
//                                if currentID == snapData["host"]
//                                {
//                                    print("有人報名 = \(snapData["apply"])")
//                                }
                                //-----試做報名通知---------
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
        if tableView == allTableView {
            return actMsg.count
        }
        else {
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
            
            cell.activityImage.sd_setImage(with: cacheURL, placeholderImage: UIImage(named: "picture_placeholder.png"))
            
            //確認側邊欄圖片是否載完，才取消轉轉
            if sideProfileImage != nil
            {
                SVProgressHUD.dismiss()
            }
            
            
            return cell
        }
        else
        {
            let cell = searchResultController.tableView.dequeueReusableCell(withIdentifier: "SearchTBVCell", for: indexPath) as! SearchTBVCell
            cell.searchTopicLabel.text = searchArray[indexPath.row].topic
            cell.searchTimeLabel.text = searchArray[indexPath.row].time
            cell.searchKindLabel.text = searchArray[indexPath.row].kind
            
            let cacheURL = URL(string: searchArray[indexPath.row].imageURL)
            cell.searchImage.sd_setImage(with: cacheURL, placeholderImage: UIImage(named: "picture_placeholder.png"))
            
            return cell
        }
        
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "detailSegue"
        {
            let dvc = segue.destination as? DetailVC
            dvc?.detailindex = allTableView.indexPathForSelectedRow?.row
            dvc?.searchIndex = searchResultController.tableView.indexPathForSelectedRow?.row
        
        }
        
        
        
    }
    
    
    //取消點選的灰色
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "detailSegue", sender: nil)
        
        //轉場後讓search bar消失
        searchController?.dismiss(animated: true, completion: nil)
        
        //消除點選的灰色
        tableView.deselectRow(at: indexPath, animated: true)
        
        /*
        if tableView == allTableView
        {
            performSegue(withIdentifier: "detailSegue", sender: nil)
        }
        else
        {
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let pushViewController = storyboard.instantiateViewController(withIdentifier: "detailVC")
            navigationController?.pushViewController(pushViewController, animated: true)
            searchController?.searchBar.text = ""
            searchController?.searchBar.resignFirstResponder()
        } */
        
        
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
                SVProgressHUD.dismiss()
            }
            else
            {
                let storage = FIRStorage.storage()
                let imageURL = storage.reference(forURL: userImageURL!)
                
                imageURL.downloadURL(completion: { (url, error) in
                    
                    if error != nil {
                        print("downloadURL Error:\(error?.localizedDescription)")
                        SVProgressHUD.dismiss()
                        SVProgressHUD.showError(withStatus: "伺服器無回應，請稍候再試")
                        return
                    }
                    
                    URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                        
                        if error != nil {
                            print(error)
                            return
                        }
                        
                        guard let imageData = UIImage(data: data!) else { return }
                        sideProfileImage = imageData
                        
                        SVProgressHUD.dismiss()
                    }).resume()
                })
            }
            
        }
    }
    
    
    
    func checkWhoApply()
    {
        let currentID = FIRAuth.auth()?.currentUser?.uid
        let apply_request = DBProvider.Instance.dbRef.child("Apply_Request")
        
        apply_request.observe(.childAdded) { (snapshots:FIRDataSnapshot) in
            
            if let snapshot = snapshots.children.allObjects as? [FIRDataSnapshot]
            {
                for snap in snapshot
                {
                    //print("snapData = \(snap.key)") //這是活動的Key名稱
                    if let snapData = snap.value as? Dictionary<String, String>
                    {
                        //print("snapData = \(snapData)")
                        if self.isFirst == false
                        {
                            if currentID == snapData["host"]
                            {
                                //print("有人報名 = \(snapData["apply"])")
                                //推播寫在這.......
                                self.pushNotification(title: snapData["applyName"]!)
                                //再開通知
                                //let notificationName =
                                    //Notification.Name("NewApplicantNoti")
                                //NotificationCenter.default.post(name: notificationName, object: nil, userInfo: ["data":self.data])
                                self.tabBarController?.tabBar.items?[1].badgeValue = "new"//(String)("new")
                            }
                        }
                        
                    }
                }
            }
        }
        //目的只是要把判斷是否為第一次寫在裡面而已，因為firebase語法特性，
        //observeSingleEvent會等observe(.childAdded)全部跑完才做
        apply_request.observeSingleEvent(of: .value, with: { (snapshot) in
            
            self.isFirst = false
        })
        
    }
    
    //MARK: push Notification
    func pushNotification(title:String)
    {
        let content = UNMutableNotificationContent() //建立通知物件(顯示的表單view)
        content.title = title
        content.subtitle = " "
        content.body = "申請加入"
        content.badge = 1
        content.sound = UNNotificationSound.default()
        
        //發送通知時，在通知裡包含客製化資訊
        content.userInfo = ["myKey":"myUserInfo"]
        
        //let imageURL = Bundle.main.url(forResource: "pic", withExtension: "jpg")
        //let attachment = try! UNNotificationAttachment(identifier: "", url: imageURL!, options: nil)
        //content.attachments = [attachment]
        
        //設定通知內容的類別 ID
        content.categoryIdentifier = "myMessage"
        
        //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false) //這是發送通知的種類，如何觸發的
        let request = UNNotificationRequest(identifier: "myNotification", content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    
    
    func checkPushForUser()
    {
        let currentID = FIRAuth.auth()?.currentUser?.uid
        let checkNotifi = DBProvider.Instance.dbRef.child("enrolled")
        
        checkNotifi.observe(.childChanged) { (snapshots:FIRDataSnapshot) in
            
            if let snapshot = snapshots.children.allObjects as? [FIRDataSnapshot]
            {
                for snap in snapshot
                {
                    //print("snapData = \(snap.key)") //這是活動的Key名稱
                    if let snapData = snap.value as? Dictionary<String, String>
                    {
                        //print("snapData = \(snapData)")
                        if self.isFirst2 == false
                        {
                            print("currentID = \(currentID)")
                            print("snapData[id] = \(snapData["id"])")
                            if currentID == snapData["id"]
                            {
                                //print("snapData[confirm] = \(snapData["confirm"])")
                                if snapData["confirm"] == "true"
                                {
                                    print("要傳了")
                                    //推播寫在這.......
                                    self.pushNotification2(title: snapData["name"]!, confirm: true)
                                }
                                
                            }
                        }
                    }
                }
            }
        }
        //目的只是要把判斷是否為第一次寫在裡面而已，因為firebase語法特性，
        //observeSingleEvent會等observe(.childAdded)全部跑完才做
        checkNotifi.observeSingleEvent(of: .value, with: { (snapshot) in
            
            self.isFirst2 = false
        })
    }
    
    
    //MARK: push Notification2
    func pushNotification2(title:String, confirm:Bool)
    {
        let content = UNMutableNotificationContent() //建立通知物件(顯示的表單view)
        if confirm
        {
            content.body = "恭喜！報名成功"
        }
        else
        {
            content.body = "抱歉！你已被取消報名資格"
        }
        content.title = title
        content.subtitle = " "
        //content.body = "恭喜！報名成功"
        content.badge = 1
        content.sound = UNNotificationSound.default()
        
        //發送通知時，在通知裡包含客製化資訊
        content.userInfo = ["myKey":"myUserInfo"]
        
        //let imageURL = Bundle.main.url(forResource: "pic", withExtension: "jpg")
        //let attachment = try! UNNotificationAttachment(identifier: "", url: imageURL!, options: nil)
        //content.attachments = [attachment]
        
        //設定通知內容的類別 ID
        content.categoryIdentifier = "myMessage2"
        
        //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false) //這是發送通知的種類，如何觸發的
        let request = UNNotificationRequest(identifier: "myNotification2", content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    
    
    
    
    

}














