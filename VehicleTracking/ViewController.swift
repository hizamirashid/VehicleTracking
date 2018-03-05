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
    let customMarkerHeight: Int = 106
    
    var ref: DatabaseReference!
    var vehiclesArr: [Vehicles] = []
    var markers: [GMSMarker] = []
    var countdownTimer: Timer!
    var totalTime = 0
    var currentLocationIndex = 0
    
    let previewDemoData = [(title: "The Polar Junction", img: #imageLiteral(resourceName: "restaurant1"), price: "10"), (title: "The Nifty Lounge", img: #imageLiteral(resourceName: "restaurant2"), price: "8"), (title: "The Lunar Petal", img: #imageLiteral(resourceName: "restaurant3"), price: "12")]
    
    var vehiclePreviewView: VehiclePreviewView = {
        let v = VehiclePreviewView()
        return v
    }()
    
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
        setupViews()
        
        // Firebase initialization
        ref = Database.database().reference()
        
        ref?.child("vehicles").observe(.value, with: { (snapshots) in
            self.vehiclesArr.removeAll()
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
    
    func setupViews() {
        vehiclePreviewView = VehiclePreviewView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width-16, height: 150))
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
            
            // check if coordinates exist
            if let coordinate_number = item.coordinates?.count {
                // at least 1 coordinate
                if coordinate_number > 0 {
                    // add coordinated to path, so we can draw to map
                    for i in 0..<coordinate_number {
                        
                        guard let latitude = item.coordinates![i].latitude else { break }
                        guard let longitude = item.coordinates![i].longitude else { break }
                        
                        path.add(CLLocationCoordinate2DMake(latitude, longitude))
                        
                        // draw market to this last coordinate
                        if i == coordinate_number-1 {
                            let marker=GMSMarker()
                            let coin = arc4random_uniform(2) + 1
                            let customMarker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: customMarkerWidth, height: customMarkerHeight), image: UIImage(named:"\(coin)")!, borderColor: UIColor.darkGray, tag: count, plateNumber: item.plate!)
                            marker.iconView=customMarker
                            marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                            marker.map = self.googleMapView
                            
                            // ADD TO array or gmsmarker
                            markers.append(marker)
                        } // end if i == coordinate_number-1
                    } // end for i in 0..<coordinate_number
                } // end if coordinate_number > 0
            } // end if let coordinate_number = item.coordinates?.count
            
            let rectangle = GMSPolyline(path: path)
            rectangle.strokeWidth = 2.0
            rectangle.strokeColor = UIColor.random
            rectangle.map = googleMapView
            
            count += 1
        } // end for item in vehiclesArr
        
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
//        let lat = (location?.coordinate.latitude)!
//        let long = (location?.coordinate.longitude)!
        
//        showPartyMarkers()
    }
    
    // MARK: GOOGLE MAP DELEGATE
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        guard let customMarkerView = marker.iconView as? CustomMarkerView else { return false }
        let img = customMarkerView.img!
        let customMarker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: customMarkerWidth, height: customMarkerHeight), image: img, borderColor: UIColor.orange, tag: customMarkerView.tag, plateNumber: customMarkerView.plateNumber)
        
        marker.iconView = customMarker
        
        return false
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoContents marker: GMSMarker) -> UIView? {
        guard let customMarkerView = marker.iconView as? CustomMarkerView else { return nil }
        let data = vehiclesArr[customMarkerView.tag]
        var lastLocation : Coordinates = (data.coordinates?[0])!
        // check if coordinates exist
        if let coordinate_number = data.coordinates?.count {
            // at least 1 coordinate
            if coordinate_number > 0 {
                lastLocation = (data.coordinates?[coordinate_number-1])!
            }
        }
        
        // custom date style
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.locale = Locale.init(identifier: "en_GB")
        let datetime = dateFormatter.date(from: lastLocation.time!)
        
        dateFormatter.dateFormat = "MMM, dd yyyy"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let dateString = dateFormatter.string(from: datetime!)
        
        let timeAgo = timeAgoSince(datetime!)
        
        if let engine = lastLocation.engine, let speed = lastLocation.speed {
            vehiclePreviewView.setData(engine: "\(engine)", speed: "\(speed)", date: dateString, time: timeAgo, roadLbl: "")
        } else {
            vehiclePreviewView.setData(engine: "0", speed: "0", date: dateString, time: timeAgo, roadLbl: "")
        }
        return vehiclePreviewView
    }
    
    func mapView(_ mapView: GMSMapView, didCloseInfoWindowOf marker: GMSMarker) {
        guard let customMarkerView = marker.iconView as? CustomMarkerView else { return }
        let img = customMarkerView.img!
        let customMarker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: customMarkerWidth, height: customMarkerHeight), image: img, borderColor: UIColor.darkGray, tag: customMarkerView.tag, plateNumber: customMarkerView.plateNumber)
        marker.iconView = customMarker
    }
}

