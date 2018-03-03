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
        
        handle = ref?.child("vehicles").observe(.childAdded, with: { (snapshots) in
            
            if let data = snapshots.value {
                guard let vehicles = Vehicle_Base(dictionary: data as! NSDictionary) else { return }
                print(vehicles)
            }
        })
        
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
        theMap.setRegion(newRegion, animated: true)
        
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
