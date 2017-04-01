//
//  AddItemVC.swift
//  AllTogeter
//
//  Created by YenShao on 2017/3/17.
//  Copyright © 2017年 YenShao. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class AddItemVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, sendAddress {
    
    
    @IBOutlet weak var newTopic: UITextField!
    
    @IBOutlet weak var newPlace: UITextField!
    
    @IBOutlet weak var newTime: UITextField!
    
    @IBOutlet weak var newPeople: UITextField!
    
    @IBOutlet weak var newKind: UITextField!
    
    @IBOutlet weak var newImage: UIImageView!
    
    @IBOutlet weak var kindSegment: UISegmentedControl!
    
    @IBOutlet weak var uiview: UIView!
    
    
    
    let segmentItem = ["聚餐","電影","運動","KTV","郊遊","逛逛","其他"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //文字框delegate
        newTopic.delegate = self
        newPlace.delegate = self
        newPeople.delegate = self
        newKind.delegate = self
        newTime.delegate = self

        //在圖片上加入點擊手勢效果
        uiview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectProfileImage)))
        
        //加入點擊手勢判斷鍵盤
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView(gesture:)))
        view.addGestureRecognizer(tapGesture)
        
        //移除返回鈕的文字
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        
    }
    
    @IBAction func cameraBtn(_ sender: UIButton)
    {
        selectProfileImage()
    }
    
    
    //MARK: 選照片
    func selectProfileImage()
    {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        show(imagePickerController, sender: self)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        newImage.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        dismiss(animated: true, completion: nil)
    }
    
    

    //MARK: 存新活動Button
    @IBAction func saveNewAct(_ sender: UIBarButtonItem)
    {
        if isInternetOk()
        {
            //設定轉轉轉
            SVProgressHUD.setDefaultStyle(.light) //轉轉小方框的 亮暗
            SVProgressHUD.setDefaultMaskType(.black) //轉轉背景的 亮暗
            SVProgressHUD.show(withStatus: "Upload")
            
            if checkTextField() == true
            {
                let currentID = FIRAuth.auth()?.currentUser?.uid
                
                let topic = newTopic.text!
                let place = newPlace.text!
                let time = newTime.text!
                let people = newPeople.text!
                let kind = newKind.text!
                
                //存圖片
                let uidString = NSUUID().uuidString
                let activityImagesRef = DBProvider.Instance.storageRef.child("Activity_images").child(currentID!).child(uidString)
                let imageData:Data = UIImageJPEGRepresentation(newImage.image!, 0.1)!
                
                activityImagesRef.put(imageData, metadata: nil) { (metadata, error) in
                    
                    if error != nil
                    {
                        print("上傳圖片錯誤: \(error?.localizedDescription)")
                        return
                    }
                    
                    //照片儲存位置
                    let imageURL:String = (metadata?.downloadURL()?.absoluteString)!
                    
                    //存資料與圖片
                    let data:[String:Any] = ["from":currentID!, "topic":topic, "place":place, "time":time, "people":people, "kind":kind, "imageURL":imageURL]
                    
                    DBProvider.Instance.dbRef.child("Activity").childByAutoId().setValue(data)
                    
                    SVProgressHUD.showSuccess(withStatus: "上傳成功")
                    SVProgressHUD.dismiss() //關閉轉轉轉
                    let _ = self.navigationController?.popViewController(animated: true)
                    
                }
                
            }
        }
        else
        {
            SVProgressHUD.showError(withStatus: "無網路連線")
        }
        
        
    }
    
    //MARK: 取得目前位置Button
    @IBAction func getLocationBtn(_ sender: UIButton)
    {
        
    }
    
    //MARK: preparForSegue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "serchLocationSegue"
        {
            let dvc = segue.destination as? searchLocationVC
            dvc?.sendAddressDelege = self
            dvc?.isMoveMap = false
        }
    }
    
    
    
    
    
    
    //MARK: 設定PickerView
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        let myDatePicker = UIDatePicker()
        
        myDatePicker.datePickerMode = .dateAndTime
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd HH:mm"
        
        //newTimeField.text = formatter.string(from: Date())
        
        myDatePicker.locale = Locale(identifier: "zh_TW")
        myDatePicker.backgroundColor = UIColor.white
        
        myDatePicker.addTarget(self, action: #selector(self.datePickerChanged), for: .valueChanged)
        
        if textField.tag == 1
        {
            newTime.text = formatter.string(from: Date())
            textField.inputView = myDatePicker
        }
        
    }
    
    func datePickerChanged(datePicker: UIDatePicker)
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd HH:mm"
        newTime.text = formatter.string(from: datePicker.date)
    }
    
    
    
    
    
    
    //MARK: 文字框按下return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    //點擊畫面時縮鍵盤
    func didTapView(gesture:UITapGestureRecognizer)
    {
        //縮鍵盤
        view.endEditing(true)
    }
    
    
    @IBAction func kindSegmentBtn(_ sender: UISegmentedControl)
    {
        let segmentIndex = sender.selectedSegmentIndex
        newKind.text = segmentItem[segmentIndex]
        
    }
    
    //MARK: protocle from searchMap
    func getaddress(address: String) {
        
        newPlace.text = address
    }
    
    
    //MARK: 檢查文字框空白
    func checkTextField() -> Bool
    {
        if newTopic.text != "" && newPlace.text != "" && newTime.text != "" && newPeople.text != "" && newKind.text != ""
        {
            if newImage.image != nil
            {
                return true
            }
            else
            {
                alertTheUser(title: "尚未完成欄位", message: "請放上一張圖片")
                return false
            }
            
        }
        else
        {
            alertTheUser(title: "尚未完成欄位", message: "請輸入資料")
            return false
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























