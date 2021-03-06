//
//  FBManager.swift
//  AllTogeter
//
//  Created by YenShao on 2017/3/18.
//  Copyright © 2017年 YenShao. All rights reserved.
//

import Foundation
import FBSDKLoginKit
import SwiftyJSON
import Firebase

class FBManager
{
    
    static let shared = FBSDKLoginManager()
    
    public class func getFBUserData(completionHandler: @escaping () -> Void)
    {
        //import Firebase後，連結Firebase與Facebook的Auth signin功能--(2)
        let accessToken = FBSDKAccessToken.current() //取得Token
        guard let accessTokenString = accessToken?.tokenString else { return } //解包
        
        let credntials = FIRFacebookAuthProvider.credential(withAccessToken: accessTokenString) //取得憑證
        FIRAuth.auth()?.signIn(with: credntials, completion: { (user, error) in
            
            if error != nil
            {
                print("xxxFB使用者帳號出錯:", error)
                return
            }
            print("xxxFB使用者帳號成功", user)
            guard let uid = user?.uid else {
                return
            }
            print("xxTest FB UID = \(uid)")
        })
        
        
        if FBSDKAccessToken.current() != nil
        {
            //跟Facebook要資料
            //取得使用者資訊--(1)
            FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email, picture.type(normal)"]).start(completionHandler: { (connection, result, error) in
                
                if error == nil
                {
                    
                    let json = JSON(result!)
                    //print("xxxJson = \(json)")
                    
                    FBUser.currentFBUser.setInfo(json: json)
                    
                    //就將此FBuser存進database
                    //let fbEmail = FBUser.currentFBUser.email
                    //let fbID = FBUser.currentFBUser.FBID
                    //MsgHandler.Instance.saveUser(ID: fbID!, email: fbEmail!, password: "FBpassword")
                    
                    completionHandler()
                }
            })
        }
    }
    
    
    
    
    
}












