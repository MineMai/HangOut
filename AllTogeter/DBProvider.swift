//
//  DBProvider.swift
//  AllTogeter
//
//  Created by YenShao on 2017/3/9.
//  Copyright © 2017年 YenShao. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase


class DBProvider
{
    private static let _instance = DBProvider()
    static var Instance:DBProvider {
        return _instance
    }
    
    var dbRef:FIRDatabaseReference {
        return FIRDatabase.database().reference()
    }
    
    var storageRef:FIRStorageReference {
        return FIRStorage.storage().reference()
    }
    
    
    
}






















