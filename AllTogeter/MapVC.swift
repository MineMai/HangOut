//
//  MapVC.swift
//  AllTogeter
//
//  Created by YenShao on 2017/3/21.
//  Copyright © 2017年 YenShao. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapVC: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate
{
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    
    let locationManager = CLLocationManager() //定位需要用的
    var forNavigationLocation:CLLocationCoordinate2D? //把位置給導航用的變數
    var myLocation:CLLocationCoordinate2D?    //把位置給導航用的變數
    
    var targetLocation:String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //定位設定
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.activityType = .automotiveNavigation
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation() //開始執行
        
        if let location = targetLocation
        {
            findLocation(address: location)
        }
        
    }
    
    
    // MARK: - CLLocationManagerDelegate Methods
    // 接收傳回的經緯度位置
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let currentLocation = locations.last else
        {
            print("xxCurrentLocation is nil")
            return
        }
        //print(currentLocation.coordinate.latitude)
        myLocation = currentLocation.coordinate
    }
    
    
    
    //MARK: 找出目的地
    func findLocation(address:String)
    {
        let geoCoder = CLGeocoder() //地址轉座標
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            
            if error != nil
            {
                print("xx地址轉座標錯誤: \(error?.localizedDescription)")
                return
            }
            else
            {
                //placemarks裡面傳回來的是可能有好幾個位置，所以用陣列表示
                if let coordinate = placemarks?[0].location?.coordinate
                {
                    self.forNavigationLocation = coordinate // 把位置傳給導航用
                    let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake((coordinate.latitude), (coordinate.longitude))
                    let xScale:CLLocationDegrees = 0.01
                    let yScale:CLLocationDegrees = 0.01
                    let span:MKCoordinateSpan = MKCoordinateSpanMake(yScale, xScale)
                    let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
                    self.mapView.setRegion(region, animated: true)
                    
                    //加入大頭針
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = "集合點"
                    self.mapView.selectAnnotation(annotation, animated: true) //自動顯示泡泡
                    self.mapView.addAnnotation(annotation)
                }
                
                
            }
        
        
        }
    

    }
    
    
    // MARK: - MKMapViewDelegate Methods  自訂泡泡裡面加東西
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        //檢查是否為使用者位置，是的話就不標
        if annotation is MKUserLocation
        {
            return nil
        }
        let identifier = "Pin" //大頭針識別號
        
        //大頭針回收機制
        var result = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if result == nil
        {
            result = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        
        
        result?.canShowCallout = true
        result?.image = UIImage(named: "pin_red.png")
        
        
        //right callout accessoryview 泡泡右邊助理按鈕
        let button = UIButton(type: .detailDisclosure)
        button.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        result?.rightCalloutAccessoryView = button
        
        return result
        
    }
    
    
    //泡泡裡的按鈕，按下會執行的方法
    func buttonTapped(sender:UIButton)
    {
        let alert = UIAlertController(title: "導航", message: "是否進入導航頁面", preferredStyle: .actionSheet)
        let ok = UIAlertAction(title: "OK", style: .default) { (action) in
            
            let pA = MKPlacemark(coordinate: self.myLocation!, addressDictionary: nil)
            let pB = MKPlacemark(coordinate: self.forNavigationLocation!, addressDictionary: nil)
            
            let miA = MKMapItem(placemark: pA)
            let miB = MKMapItem(placemark: pB)
            miA.name = "現在位置"
            miB.name = "目的地"
            let routes = [miA, miB]
            let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
            MKMapItem.openMaps(with: routes, launchOptions: options)
            
        }
        let cancle = UIAlertAction(title: "取消", style: .destructive, handler: nil)
        alert.addAction(ok)
        alert.addAction(cancle)
        present(alert, animated: true, completion: nil)
        
        
    }
    
    
    
    

}












