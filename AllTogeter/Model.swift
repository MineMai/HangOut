//
//  Model.swift
//  AllTogeter
//
//  Created by YenShao on 2017/3/8.
//  Copyright © 2017年 YenShao. All rights reserved.
//

import UIKit


var actMsg = [ActMsg]()

var hostMsg = [ActMsg]()

var applyKey = [String]() //只存活動的AutoKey

var applyMsg = [ApplyMsg]()

var searchArray = [ActMsg]() //存搜尋列的結果

class ActMsg
{
    var from = ""      //誰創建的id
    var topic = ""
    var place = ""
    var time = ""
    var kind = ""
    var people = ""
    var imageURL = ""
    var currentID = "" //誰報名的id
    var autoKey = ""   //活動的專屬key
    
    init(from:String, topic:String, place:String, time:String, kind:String, people:String, imageURL:String, currentID:String, autoKey:String)
    {
        self.from = from
        self.topic = topic
        self.place = place
        self.time = time
        self.kind = kind
        self.people = people
        self.imageURL = imageURL
        self.currentID = currentID
        self.autoKey = autoKey
    }
}

var forAllActVCtoShowImg = [UIImage]()
var forHostToShowImg = [UIImage]()
var detailImagePass = [UIImage]()

//如果用Firebase登入就要把照片名字先存起來，給側邊欄用
var sideProfileImage:UIImage?
var sideProfileName:String?

var isFBLogin = false
var fbUsers:FBUsers?


class ApplyMsg
{
    var from = ""
    var topic = ""
    var place = ""
    var time = ""
    var kind = ""
    var people = ""
    var imageURL = ""
    var currentID = ""
    var autoKey = ""
    
    init(from:String, topic:String, place:String, time:String, kind:String, people:String, imageURL:String, currentID:String, autoKey:String)
    {
        self.from = from
        self.topic = topic
        self.place = place
        self.time = time
        self.kind = kind
        self.people = people
        self.imageURL = imageURL
        self.currentID = currentID
        self.autoKey = autoKey
    }
}


func isInternetOk() -> Bool
{
    let reach = Reachability(hostName: "www.apple.com")
    if reach?.currentReachabilityStatus().rawValue == 0
    {
        //沒網路
        return false
    }
    else
    {
        //有網路
        return true
    }
}









