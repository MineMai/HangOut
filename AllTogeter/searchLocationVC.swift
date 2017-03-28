//
//  searchLocationVC.swift
//  AllTogeter
//
//  Created by YenShao on 2017/3/19.
//  Copyright © 2017年 YenShao. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol sendAddress
{
    func getaddress(address:String)
}

class searchLocationVC: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var searchMapView: MKMapView!
    
    var sendAddressDelege:sendAddress?
    
    let locationManager = CLLocationManager() //定位需要用的
    
    var isMoveMap = false

    
    @IBAction func mapTypeChange(_ sender: UISegmentedControl)
    {
        let index = sender.selectedSegmentIndex
        
        switch index {
        case 0:
            searchMapView.mapType = .standard
        case 1:
            searchMapView.mapType = .satellite
        case 2:
            searchMapView.mapType = .hybrid
        default:
            searchMapView.mapType = .standard
        }
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //定位設定
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.activityType = .automotiveNavigation
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation() //開始執行
        
        //加入長按手勢，加入大頭針
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(addAnnotation(gestureRecognizer:)))
        longPress.minimumPressDuration = 1.2
        
        searchMapView.addGestureRecognizer(longPress)

    }
    
    
    // MARK: - CLLocationManagerDelegate Methods
    // 接收傳回的經緯度位置
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let currentLocation = locations.last else
        {
            print("CurrentLocation is nil")
            return
        }
        //這就是目前使用者位置
        //print(currentLocation.coordinate.latitude) //這就是目前使用者位置
        
        if isMoveMap
        {
            
        }
        else
        {
            moveMap(currentLocation: currentLocation)
            isMoveMap = true
        }
        
        
        
        //自己隨便取個名字(工作的名稱)
//        DispatchQueue.once(token: "MoveMap") {
//            //裡面的程式只會被執行一次
//            let span = MKCoordinateSpanMake(0.01, 0.01)
//            let region = MKCoordinateRegionMake(currentLocation.coordinate, span)
//            searchMapView.setRegion(region, animated: true)
//            
//        }
        
    }
    
    func moveMap(currentLocation:CLLocation)
    {
        let span = MKCoordinateSpanMake(0.01, 0.01)
        let region = MKCoordinateRegionMake(currentLocation.coordinate, span)
        searchMapView.setRegion(region, animated: true)
    }
    
    
    
    
    //長按手勢要做的事，加入大頭針
    func addAnnotation(gestureRecognizer:UIGestureRecognizer)
    {
        //偵測長按結束才會執行動作
        if gestureRecognizer.state == .began
        {
            //獲取在地圖上長按的地方
            let touchPoint = gestureRecognizer.location(in: searchMapView)
            //將長按的位置轉成座標
            let coordinate = searchMapView.convert(touchPoint, toCoordinateFrom: searchMapView)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            //let lati = String(coordinate.latitude)
            //annotation.title = "你選的位置是"
            //annotation.subtitle = "HelloWord"
            //searchMapView.addAnnotation(annotation)
            
            //將CLLocationCoordinate2D 轉成 CLLocation
            let lat: CLLocationDegrees = coordinate.latitude
            let lon: CLLocationDegrees = coordinate.longitude
            let transformCLLocation: CLLocation =  CLLocation(latitude: lat, longitude: lon)
            
            //用經緯度轉成地址
            CLGeocoder().reverseGeocodeLocation(transformCLLocation
            ) { (placemarks, error) in
                
                if error != nil
                {
                    print(error)
                }
                else
                {
                    if let placemark = placemarks?[0]
                    {
                        //print(placemark) //-->這就是取得所有轉換後資訊
                        //print("placemark = \(placemark.addressDictionary)" + "\n")
                        if let formatadd = placemark.addressDictionary? ["FormattedAddressLines"] as? [String]
                        {
                            var myLocation = ""
                            for i in formatadd
                            {
                                myLocation += i
                            }
                            
                            //let street = formatadd[0]
                            //let city = formatadd[1]
                            //let country = formatadd[2]
                            //let myLocation = street + city
                            //print("Myaddress = \(street) \(city) \(country)" + "\n")
                            print("Myaddress = \(myLocation)" + "\n")
                            annotation.title = "你選的位置是"
                            annotation.subtitle = myLocation
                            self.searchMapView.addAnnotation(annotation)
                            
                            //傳值到前一頁
                            self.sendAddressDelege?.getaddress(address: myLocation)
                        }
                        
                    }
                }
            }
            
        }
        
    }
    
    

    

}


// 擴充 DispatchQueue 實作一個DispatchQueue once
extension DispatchQueue
{
    private static var _onceTokens = [String]()
    //帶入工作名稱    帶入要執行的工作
    public class func once(token:String, jobToExecute:()->())
    {
        objc_sync_enter(self) //確保只有一個執行緒在做這件事 ，鎖定
        
        //把解鎖統一都寫在defer裡面。 defer 是 當這裡面程式碼跑完要離開時才會執行defer裡面的程式
        defer {
            objc_sync_exit(self) //解鎖
        }
        
        if _onceTokens.contains(token) //傳進來的token是否已存在_onceTokens裡面
        {
            //objc_sync_exit(self) //解鎖
            return
        }
        _onceTokens.append(token)
        jobToExecute()
        //objc_sync_exit(self) //解鎖
    }
}












