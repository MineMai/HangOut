//
//  FBUser.swift
//  AllTogeter
//
//  Created by YenShao on 2017/3/18.
//  Copyright © 2017年 YenShao. All rights reserved.
//

import Foundation
import SwiftyJSON


class FBUser
{
    var name:String?
    var email:String?
    var pictureURL:String?
    
    static let currentFBUser = FBUser()
    
    func setInfo(json:JSON)
    {
        self.name = json["name"].string
        self .email = json["email"].string
        
        let image = json["picture"].dictionary
        let imageData = image?["data"]?.dictionary
        self.pictureURL = imageData?["url"]?.string
    }
    
    func resetInfo()
    {
        self.name = nil
        self.email = nil
        self.pictureURL = nil
    }
    
    
}






















