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

class ActMsg
{
    var from = ""
    var topic = ""
    var latitude = ""
    var longitude = ""
    var time = ""
    var kind = ""
    var people = ""
    var imageURL = ""
    var currentID = ""
    var autoKey = ""
    
    init(from:String, topic:String, latitude:String, longitude:String, time:String, kind:String, people:String, imageURL:String, currentID:String, autoKey:String)
    {
        self.from = from
        self.topic = topic
        self.latitude = latitude
        self.longitude = longitude
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




















