//
//  ViewController.swift
//  VehicleTracking
//
//  Created by Norhizami  on 02/03/2018.
//  Copyright © 2018 Media Prima Digital - Norhizami. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import Firebase

class ViewController: UIViewController {

    // IBOutlets
    @IBOutlet weak var theMap: MKMapView!
    
    // Variables
    var manager:CLLocationManager!
    var myLocations: [CLLocation] = []
    
    var ref: DatabaseReference?
    var handle: DatabaseHandle?
    var vehiclesArr: [Vehicles]! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup our Location Manager
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
        
        //Setup our Map View
        theMap.delegate = self
        theMap.mapType = MKMapType.standard
        theMap.showsUserLocation = true
        
        // Firebase initialization
        ref = Database.database().reference()
        
        ref?.child("vehicles").observe(.value, with: { (snapshots) in
            
            for item in snapshots.children {
                let child = item as! DataSnapshot
                let dict = child.value as! NSDictionary
                let vehicle = Vehicles(dictionary: dict)
                self.vehiclesArr.append(vehicle!)
            }
            
            print(self.vehiclesArr[0].name)
            
        })
        
        // show artwork on map
        for item in vehiclesArr {
            let artwork = Artwork(locationName: item.name as! String,
                                  coordinate: CLLocationCoordinate2D(latitude: item.coordinates![0].latitude as! CLLocationDegrees, longitude: item.coordinates![0].longitude as! CLLocationDegrees))
            theMap.addAnnotation(artwork)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ViewController: CLLocationManagerDelegate, MKMapViewDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        myLocations.append(locations[0] )
        
        let spanX = 0.007
        let spanY = 0.007
        let newRegion = MKCoordinateRegion(center: theMap.userLocation.coordinate, span: MKCoordinateSpanMake(spanX, spanY))
//        theMap.setRegion(newRegion, animated: true)
        
        if (myLocations.count > 1){
            let sourceIndex = myLocations.count - 1
            let destinationIndex = myLocations.count - 2
            
            let c1 = myLocations[sourceIndex].coordinate
            let c2 = myLocations[destinationIndex].coordinate
            var a = [c1, c2]
            let polyline = MKPolyline(coordinates: &a, count: a.count)
            theMap.add(polyline)
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        polylineRenderer.strokeColor = UIColor.blue
        polylineRenderer.lineWidth = 4
        return polylineRenderer
    }
}
