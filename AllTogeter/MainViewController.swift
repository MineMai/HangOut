//
//  MainViewController.swift
//  AllTogeter
//
//  Created by YenShao on 2017/3/17.
//  Copyright © 2017年 YenShao. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import SwiftyJSON

class MainViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var signupBtn: UIButton!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // 產生FB專用按鈕
        let fbloginButton = FBSDKLoginButton()
        
        view.addSubview(fbloginButton)
        
        fbloginButton.frame = CGRect(x: 40, y: 530, width: view.frame.width - 80, height: 40)
        
        fbloginButton.delegate = self
        //loginButton.readPermissions = ["email", "public_profile"]
        
        loginBtn.layer.borderWidth = 1.0
        loginBtn.layer.borderColor = UIColor.white.cgColor
        
        signupBtn.layer.borderWidth = 1.0
        signupBtn.layer.borderColor = UIColor.white.cgColor
        
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if FBSDKAccessToken.current() != nil
        {
            performSegue(withIdentifier: "LoginSegue", sender: self)
        }
        else
        {
            print("xxxxCurrent = \(FBSDKAccessToken.current())")
        }
        
    }
    
    
    
    
    //簽完FB協定後要實作方法1
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
        print("xxx已登出Facebook")
    }
    //簽完FB協定後要實作方法2
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        if error != nil
        {
            print("xxxFB登入失敗: \(error)")
            return
        }
        print("xxx登入成功!")
        FBManager.getFBUserData { 
            self.viewDidAppear(true)
        }
        
    }
    
    
    @IBAction func firebaseLogin(_ sender: UIButton) {
    }
    
    
    @IBAction func firebaseSignup(_ sender: UIButton) {
    }
    
    
    

    

}













