//
//  EditPageVC.swift
//  AllTogeter
//
//  Created by YenShao on 2017/4/1.
//  Copyright © 2017年 YenShao. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class EditPageVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, sendAddress {
    
    @IBOutlet weak var editTopic: UITextField!
    
    @IBOutlet weak var editPlace: UITextField!
    
    @IBOutlet weak var editTime: UITextField!
    
    @IBOutlet weak var editPeople: UITextField!
    
    @IBOutlet weak var editKind: UITextField!
    
    @IBOutlet weak var editSegment: UISegmentedControl!
    
    @IBOutlet weak var editImage: UIImageView!
    
    @IBOutlet weak var uiView: UIView!
    
    
    let segmentItem = ["聚餐","電影","運動","KTV","郊遊","逛逛","其他"]
    
    var editIndex = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "編輯活動"
        
        //文字框delegate
        editTopic.delegate = self
        editPlace.delegate = self
        editPeople.delegate = self
        editKind.delegate = self
        editTime.delegate = self
        
        //在圖片上加入點擊手勢效果
        uiView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectProfileImage)))
        
        //加入點擊手勢判斷鍵盤
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView(gesture:)))
        view.addGestureRecognizer(tapGesture)
        
        //移除返回鈕的文字
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        navigationItem.title = "編輯-" + hostMsg[editIndex].topic
        
        
    }
    
    
    @IBAction func cameraBtn(_ sender: UIButton) {
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
        
        editImage.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: 存編輯活動Button
    @IBAction func editSaveBtn(_ sender: UIBarButtonItem)
    {
        print("editIndex = \(editIndex)")
        
        if isInternetOk()
        {
            //設定轉轉轉
            SVProgressHUD.setDefaultStyle(.light) //轉轉小方框的 亮暗
            SVProgressHUD.setDefaultMaskType(.black) //轉轉背景的 亮暗
            SVProgressHUD.show(withStatus: "Upload")
            
            if checkTextField() == true
            {
                let currentID = FIRAuth.auth()?.currentUser?.uid
                
                let topic = editTopic.text!
                let place = editPlace.text!
                let time = editTime.text!
                let people = editPeople.text!
                let kind = editKind.text!
                
                //存圖片
                let uidString = NSUUID().uuidString
                let activityImagesRef = DBProvider.Instance.storageRef.child("Activity_images").child(currentID!).child(uidString)
                let imageData:Data = UIImageJPEGRepresentation(editImage.image!, 0.4)!
                
                activityImagesRef.put(imageData, metadata: nil) { (metadata, error) in
                    
                    if error != nil
                    {
                        print("上傳圖片錯誤: \(error?.localizedDescription)")
                        SVProgressHUD.dismiss()
                        SVProgressHUD.showError(withStatus: "伺服器無回應，請稍候再試")
                        return
                    }
                    
                    //照片儲存位置
                    let imageURL:String = (metadata?.downloadURL()?.absoluteString)!
                    
                    //存資料與圖片
                    let data:[String:Any] = ["from":currentID!, "topic":topic, "place":place, "time":time, "people":people, "kind":kind, "imageURL":imageURL]
                    
                    let autoKey = hostMsg[self.editIndex].autoKey
                    DBProvider.Instance.dbRef.child("Activity").child(autoKey).setValue(data)
                    
                    SVProgressHUD.showSuccess(withStatus: "上傳成功")
                    SVProgressHUD.dismiss(withDelay: 0.5) //關閉轉轉轉
                    let _ = self.navigationController?.popViewController(animated: true)
                    //切換tabBar的頁面
                    self.tabBarController?.selectedIndex = 0
                }
                
            }
            else { //如果沒填好欄位，也關掉轉轉
                SVProgressHUD.dismiss() //關閉轉轉轉
            }
        }
        else
        {
            SVProgressHUD.showError(withStatus: "無網路連線")
        }
        
        
    }
    
    
    
    //MARK: preparForSegue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "editLocationSegue"
        {
            let dvc = segue.destination as? searchLocationVC
            dvc?.sendAddressDelege = self
            dvc?.isMoveMap = false
        }
    }
    
    //MARK: protocle from searchMap
    func getaddress(address: String) {
        
        editPlace.text = address
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
            editTime.text = formatter.string(from: Date())
            textField.inputView = myDatePicker
        }
        
    }
    
    func datePickerChanged(datePicker: UIDatePicker)
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd HH:mm"
        editTime.text = formatter.string(from: datePicker.date)
    }
    
    
    
    //MARK: 文字框按下return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    //點擊畫面時縮鍵盤
    func didTapView(gesture:UITapGestureRecognizer) {
        //縮鍵盤
        view.endEditing(true)
    }
    

    @IBAction func kindSegmentBtn(_ sender: UISegmentedControl) {
        
        let segmentIndex = sender.selectedSegmentIndex
        editKind.text = segmentItem[segmentIndex]
    }
    
    
    //MARK: 檢查文字框空白
    func checkTextField() -> Bool
    {
        if editTopic.text != "" && editPlace.text != "" && editTime.text != "" && editPeople.text != "" && editKind.text != ""
        {
            if editImage.image != nil
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

















