//
//  ViewController.swift
//  VehicleTracking
//
//  Created by Norhizami  on 02/03/2018.
//  Copyright © 2018 Media Prima Digital - Norhizami. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Firebase
import Alamofire
import SwiftyJSON

struct MyPlace {
    var name: String
    var lat: Double
    var long: Double
}

class ViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var googleMapView: GMSMapView!
    
    // MARK: - Variables
    let currentLocationMarker = GMSMarker()
    var locationManager = CLLocationManager()
    var chosenPlace: MyPlace?
    
    let customMarkerWidth: Int = 80
    let customMarkerHeight: Int = 105
    
    var ref: DatabaseReference!
    var vehiclesArr: [Vehicles] = []
    var markers: [GMSMarker] = []
    var countdownTimer: Timer!
    var totalTime = 0
    var currentLocationIndex = 0
    
    let previewDemoData = [(title: "The Polar Junction", img: #imageLiteral(resourceName: "restaurant1"), price: 10), (title: "The Nifty Lounge", img: #imageLiteral(resourceName: "restaurant2"), price: 8), (title: "The Lunar Petal", img: #imageLiteral(resourceName: "restaurant3"), price: 12)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = "Vehicle Tracking"
        googleMapView.delegate = self
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        
        initGoogleMaps()
        
        // Firebase initialization
        ref = Database.database().reference()
        
        ref?.child("vehicles").observe(.value, with: { (snapshots) in
            
            for item in snapshots.children {
                let child = item as! DataSnapshot
                let dict = child.value as! NSDictionary
                let vehicle = Vehicles(dictionary: dict)
                self.vehiclesArr.append(vehicle!)
            }
            
            // show all marker
            self.showPartyMarkers()
        })
        
    }
    
    func initGoogleMaps() {
        self.googleMapView.delegate = self
        self.googleMapView.isMyLocationEnabled = true
        self.googleMapView.settings.myLocationButton = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - this is function for create path, from start location to desination location
    func showPartyMarkers() {
        googleMapView.clear()
        
        var count = 0
        for item in vehiclesArr {
            // draw path according to all coordinates
            let path = GMSMutablePath()
            
            if let coordinate_number = item.coordinates?.count {
                for i in 0..<coordinate_number {
                    path.add(CLLocationCoordinate2DMake(item.coordinates![i].latitude!, item.coordinates![i].longitude!))
                    
                    if i == coordinate_number-1 {
                        let marker=GMSMarker()
                        let customMarker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: customMarkerWidth, height: customMarkerHeight), image: previewDemoData[0].img, borderColor: UIColor.darkGray, tag: i, plateNumber: item.plate!)
                        marker.iconView=customMarker
                        marker.position = CLLocationCoordinate2D(latitude: item.coordinates![i].latitude!, longitude: item.coordinates![i].longitude!)
                        marker.map = self.googleMapView
                        
                        // ADD TO array or gmsmarker
                        markers.append(marker)
                    }
                }
            }
            
            let rectangle = GMSPolyline(path: path)
            rectangle.strokeWidth = 2.0
            rectangle.map = googleMapView
            
            //        self.view = mapView
            
            // timer to add next location
//            startTimer()
            
            // must be last line of block
            count = count + 1
        }
        
        let camera = GMSCameraPosition.camera(withLatitude: vehiclesArr[0].coordinates![0].latitude!, longitude: vehiclesArr[0].coordinates![0].longitude!, zoom: 14.0)
        self.googleMapView.camera = camera
        self.googleMapView.animate(to: camera)
        
    }
}

extension ViewController: CLLocationManagerDelegate, GMSMapViewDelegate {
    
    // MARK: CLLocation Manager Delegate
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while getting location \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.delegate = nil
        locationManager.stopUpdatingLocation()
        let location = locations.last
        let lat = (location?.coordinate.latitude)!
        let long = (location?.coordinate.longitude)!
        
        showPartyMarkers()
    }
    
    // MARK: GOOGLE MAP DELEGATE
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        guard let customMarkerView = marker.iconView as? CustomMarkerView else { return false }
        let img = customMarkerView.img!
        let customMarker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: customMarkerWidth, height: customMarkerHeight), image: img, borderColor: UIColor.orange, tag: customMarkerView.tag, plateNumber: customMarkerView.plateNumber)
        
        marker.iconView = customMarker
        
        return false
    }
    
//    func mapView(_ mapView: GMSMapView, markerInfoContents marker: GMSMarker) -> UIView? {
//        guard let customMarkerView = marker.iconView as? CustomMarkerView else { return nil }
//        let data = previewDemoData[customMarkerView.tag]
//        restaurantPreviewView.setData(title: data.title, img: data.img, price: data.price)
//        return restaurantPreviewView
//    }
    
//    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
//        guard let customMarkerView = marker.iconView as? CustomMarkerView else { return }
//        let tag = customMarkerView.tag
//        restaurantTapped(tag: tag)
//    }
    
    func mapView(_ mapView: GMSMapView, didCloseInfoWindowOf marker: GMSMarker) {
//        guard let customMarkerView = marker.iconView as? CustomMarkerView else { return }
//        let img = customMarkerView.img!
//        let customMarker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: customMarkerWidth, height: customMarkerHeight), image: img, borderColor: UIColor.darkGray, tag: customMarkerView.tag)
//        marker.iconView = customMarker
    }
}

