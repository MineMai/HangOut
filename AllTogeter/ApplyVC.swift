//
//  ApplyVC.swift
//  AllTogeter
//
//  Created by YenShao on 2017/3/29.
//  Copyright © 2017年 YenShao. All rights reserved.
//

import UIKit

class ApplyVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet weak var applyCollectionView: UICollectionView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        applyCollectionView.delegate = self
        applyCollectionView.dataSource = self
        applyCollectionView.decelerationRate = UIScrollViewDecelerationRateFast
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        loadData()
    }
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return applyMsg.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ApplyCell", for: indexPath) as! ApplyCell
        
        cell.imageView.image = nil
        cell.topicLabel.text = applyMsg[indexPath.row].topic
        cell.timeLabel.text = applyMsg[indexPath.row].time
        cell.placeLabel.text = applyMsg[indexPath.row].place
        
        let cacheURL = URL(string: applyMsg[indexPath.row].imageURL)
        
        //cell.imageView.sd_setImage(with: cacheURL)
        
        cell.imageView.sd_setImage(with: cacheURL, placeholderImage: UIImage(named: "picture_placeholder.png"))
        
        return cell
        
    }
    
    
    func loadData()
    {
        applyMsg = []
        for i in 0..<applyKey.count
        {
            for key in actMsg
            {
                if applyKey[i] == key.autoKey
                {
                    let applymsg = ApplyMsg(from: key.from, topic: key.topic, place: key.place, time: key.time, kind: key.kind, people: key.people, imageURL: key.imageURL, currentID: key.currentID, autoKey: key.autoKey)
                    applyMsg.append(applymsg)
                }
            }
        }
        applyCollectionView.reloadData()
        
    }
    
    

    

}





















