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
import SVProgressHUD

class MainViewController: UIViewController, FBSDKLoginButtonDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var signupBtn: UIButton!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    //用來存放從FB取來的個資
    var FBdata:[String:Any]?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // 產生FB專用按鈕
        let fbloginButton = FBSDKLoginButton()
        
        view.addSubview(fbloginButton)
        
        fbloginButton.frame = CGRect(x: 50, y: 530, width: view.frame.width - 100, height: 40)
        
        fbloginButton.delegate = self
        
        //Firebase的登入註冊鈕外觀
        loginBtn.layer.borderWidth = 1.0
        loginBtn.layer.borderColor = UIColor.white.cgColor
        
        signupBtn.layer.borderWidth = 1.0
        signupBtn.layer.borderColor = UIColor.white.cgColor
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let reach = Reachability(hostName: "www.apple.com")
        if reach?.currentReachabilityStatus().rawValue == 0
        {
            //沒網路
            SVProgressHUD.showError(withStatus: "無網路連線")
            //alertTheUser(title: "無網路連線", message: "請檢查網路狀態")
        }
        else
        {
            //有網路
        }
    }
    
    func fetchFBProfile()
    {
        let parameters = ["fields":"email, first_name, last_name, picture.type(large)"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).start(completionHandler: { (connection, result, error) in
            
            if error != nil
            {
                print(error)
                return
            }
            if let results = result as? NSDictionary
            {
                guard let email = results["email"] else { return }
            
                print("email = \(email)")
                    
                guard let firstName = results["first_name"] as? String, let lastName = results["last_name"] as? String else { return }
            
                let name = firstName + " " + lastName
                print("name = \(name)")
                
                guard let picture = results["picture"] as? NSDictionary, let data = picture["data"] as? NSDictionary, let url = data["url"] as? String else { return }
                print("URL = \(url)")
                
                //把FB的個資存到firebase裡
                self.FBdata = ["email":email,"password":"xxxxxx","name":name,"Image":url]
                
            }
            
        })
        let accessToken = FBSDKAccessToken.current() //取得Token
        guard let accessTokenString = accessToken?.tokenString else { return } //解包
        let credntials = FIRFacebookAuthProvider.credential(withAccessToken: accessTokenString) //取得憑證
        FIRAuth.auth()?.signIn(with: credntials, completion: { (user, error) in
            
            if error != nil
            {
                print("FB使用者帳號出錯:", error)
                return
            }
            guard let uid = user?.uid else {
                return
            }
            print("FB使用者帳號成功 = \(uid)")
            
            self.performSegue(withIdentifier: "LoginSegue", sender: self)
            //把FB的個資存到firebase裡
            if let data = self.FBdata
            {
                DBProvider.Instance.dbRef.child("Users").child(uid).updateChildValues(data)
            }
        })
        
        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        //檢查有沒有使用者，有的話就直接進入
        checkLogin()
        
    }
    
    
    
    //MARK: 簽完FB協定後要實作方法
    //簽完FB協定後要實作方法1
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
        print("已登出Facebook")
    }
    //簽完FB協定後要實作方法2
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        if error != nil
        {
            print("按FB登入鈕失敗: \(error)")
            return
        }
        print("已按下FB登入鈕")
        fetchFBProfile()
        print("登入頁FBToken = \(FBSDKAccessToken.current())")
        
    }
    
    //MARK: firebaseLogin
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
    
    //MARK: firebaseSignup
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
            print("登入的CurrentUser = \(FIRAuth.auth()?.currentUser)")
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
    
    
    
    //MARK: 文字框按下return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    

    

}

























