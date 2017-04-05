//
//  HostVC.swift
//  AllTogeter
//
//  Created by YenShao on 2017/3/28.
//  Copyright © 2017年 YenShao. All rights reserved.
//

import UIKit

class HostVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet weak var hostCollectionView: UICollectionView!
    
    //給彈跳視窗用的
    let transitionDelegate = TransitionDelegate()
    
    var forEditPageIndex = 0
    var forReviewIndex = 0
    var forAllowIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        hostCollectionView.delegate = self
        hostCollectionView.dataSource = self
        hostCollectionView.decelerationRate = UIScrollViewDecelerationRateFast
        
        
    }
    
    //MARK: -收到通知要做的方法
    func reloadCollection(noti:NSNotification)
    {
        hostCollectionView.reloadData()
    }
    //收到通知要做的方法->轉場EditPageVC
    func goToEdit(noti:NSNotification)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let editVC = storyboard.instantiateViewController(withIdentifier: "editPage") as! EditPageVC
        editVC.editIndex = forEditPageIndex
        
        self.navigationController?.pushViewController(editVC, animated: true)
    }
    //收到通知要做的方法->轉場ReViewDetailVC
    func goToReviewDetail(noti:NSNotification)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let reViewDetailVC = storyboard.instantiateViewController(withIdentifier: "ReViewDetailVC") as! ReViewDetailVC
        reViewDetailVC.reviewIndex = forReviewIndex
        
        self.navigationController?.pushViewController(reViewDetailVC, animated: true)
    }
    //收到通知要做的方法->轉場goToAllow
    func goToAllow(noti:NSNotification)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let allowTBVC = storyboard.instantiateViewController(withIdentifier: "AllowTBVC") as! AllowTBVC
        allowTBVC.allowIndex = forAllowIndex
        
        self.navigationController?.pushViewController(allowTBVC, animated: true)
    }
    
    
    //MARK: viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        //監聽通知
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCollection), name: NSNotification.Name(rawValue: "reloadCollection"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(goToEdit), name: NSNotification.Name(rawValue: "goToEdit"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(goToReviewDetail), name: NSNotification.Name(rawValue: "goToReviewDetail"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(goToAllow), name: NSNotification.Name(rawValue: "goToAllow"), object: nil)
        
        hostCollectionView.reloadData()
    }
    
    //移除監聽器
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return hostMsg.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HostCell", for: indexPath) as! HostCell
        
        cell.imageView.image = nil
        cell.topicLabel.text = hostMsg[indexPath.row].topic
        cell.timeLabel.text = hostMsg[indexPath.row].time
        cell.placeLabel.text = hostMsg[indexPath.row].place
        
        let cacheURL = URL(string: hostMsg[indexPath.row].imageURL)
        
        cell.imageView.sd_setImage(with: cacheURL, placeholderImage: UIImage(named: "picture_placeholder.png"))
        
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        print("Selected row is \(indexPath.row)")
//        
//        collectionView.performBatchUpdates({
//            
//            collectionView.deleteItems(at: [indexPath])
//            hostMsg.remove(at: (indexPath.row))
//            
//            }, completion: {(_) in
//                
//                collectionView.reloadData()
//        })
        
        forEditPageIndex = indexPath.row
        forReviewIndex = indexPath.row
        forAllowIndex = indexPath.row
        
        showOverlay(indexPath: indexPath)
        
    }
    
    //MARK: show彈跳視窗
    func showOverlay(indexPath:IndexPath)
    {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let overlayVC = sb.instantiateViewController(withIdentifier: "Overlay") as! OverlayVC
        overlayVC.overlayIndex = indexPath.row
        overlayVC.transitioningDelegate = transitionDelegate
        overlayVC.modalPresentationStyle = .custom
        self.present(overlayVC, animated: true, completion: nil)
    }
    
    
    

    

}
















