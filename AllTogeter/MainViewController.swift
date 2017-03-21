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
            print("xxFBCurrentUser1 = \(FBSDKAccessToken.current())\n")
        }
        
        //檢查Firebase的使用者，有的話就直接進入
        checkLogin()
        
    }
    
    
    
    
    //簽完FB協定後要實作方法1
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
        print("xx已登出Facebook")
    }
    //簽完FB協定後要實作方法2
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        if error != nil
        {
            print("xxFB登入失敗: \(error)")
            return
        }
        print("xxFB登入成功!")
        FBManager.getFBUserData { 
            self.viewDidAppear(true)
        }
        
    }
    
    
    @IBAction func firebaseLogin(_ sender: UIButton)
    {
        if emailTextField.text != "" && passwordTextField.text != ""
        {
            AuthProvider.Instance.logIn(email: emailTextField.text!, password: passwordTextField.text!, loginHandler: { (message) in
                
                if message != nil
                {
                    self.alertTheUser(title: "登入異常", message: message!)
                }
                else
                {
                    self.performSegue(withIdentifier: "LoginSegue", sender: nil)
                }
            })
        }
        else
        {
            alertTheUser(title: "尚未填入", message: "請輸入Email與Password")
        }
        
    }
    
    
    @IBAction func firebaseSignup(_ sender: UIButton)
    {
        if emailTextField.text != "" && passwordTextField.text != ""
        {
            AuthProvider.Instance.signUp(email: emailTextField.text!, password: passwordTextField.text!, loginHandler: { (message) in
                
                if message != nil
                {
                    self.alertTheUser(title: "創建帳號異常", message: message!)
                }
                else
                {
                    //清空輸入欄
                    self.emailTextField.text = ""
                    self.passwordTextField.text = ""
                    
                    self.performSegue(withIdentifier: "LoginSegue", sender: nil)
                }
            })
        }
        else
        {
            alertTheUser(title: "尚未填入", message: "請輸入Email與Password")
        }
        
    }
    
    func checkLogin()
    {
        //如果現在真的有user的話就轉場
        if FIRAuth.auth()?.currentUser != nil
        {
            self.performSegue(withIdentifier: "LoginSegue", sender: self)
        }
        else
        {
            print("現在沒使用者")
        }
    }
    
    
    func alertTheUser(title:String, message:String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    

    

}













