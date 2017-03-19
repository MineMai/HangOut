//
//  Model.swift
//  AllTogeter
//
//  Created by YenShao on 2017/3/8.
//  Copyright © 2017年 YenShao. All rights reserved.
//

import UIKit


var actMessage = [ActMessage]()

var hostMessage = [ActMessage]()

class ActMessage
{
    var uid = ""
    var topic = ""
    var place = ""
    var time = ""
    var autoKey = ""
    var from = ""
    
    init(uid:String, topic:String, place:String, time:String, autoKey:String, from:String)
    {
        self.uid = uid
        self.topic = topic
        self.place = place
        self.time = time
        self.autoKey = autoKey
        self.from = from
        
    }
}

var forSecondVCtoShowImg = [UIImage]()
var forListTBVCtoShowImg = [UIImage]()

var detailImagePass = [UIImage]()


var applyMessage = [ApplyMessage]()

class ApplyMessage
{
    var whoApply = ""
    
    init(whoApply:String)
    {
        self.whoApply = whoApply
    }
}



















