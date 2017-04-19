//
//  ViewController.swift
//  MapKitTrials
//
//  Created by Guilherme Paciulli on 19/04/17.
//  Copyright © 2017 Guilherme Paciulli. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    var coordinate = CLLocation(latitude: -23.490121, longitude: -46.628618)
    
    let r: CLLocationDistance = 500
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.mapType = MKMapType.hybrid
        
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        updateMap()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func localSearch(text: String) {
        let r = MKLocalSearchRequest()
        r.naturalLanguageQuery = text
        r.region = self.mapView.region
        let search = MKLocalSearch(request: r)
        search.start {
            (response, error) in
            if error == nil {
                if let res = response {
                    for local in res.mapItems {
                        self.mapView.addAnnotation(local.placemark)
                    }
                }
            }
        }
    }
    
    func createPinOnLocation() {
        let point = MKPointAnnotation()
        point.title = "You"
        point.coordinate = coordinate.coordinate
        mapView.addAnnotation(point)
    }
    
    func setRegion() {
        let region = MKCoordinateRegionMakeWithDistance(coordinate.coordinate, r, r)
        mapView.setRegion(region, animated: true)
    }
    
    func updateMap() {
        coordinate = locationManager.location!
        setRegion()
        createPinOnLocation()
        localSearch(text: "Restaurante")
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let overlay = overlay as? MKCircle
        let overlayRenderer = MKCircleRenderer(overlay: overlay!)
        overlayRenderer.fillColor = UIColor(red: 244/255, green: 66/255, blue: 66/255, alpha: 0.1)
        overlayRenderer.strokeColor = UIColor(red: 1, green: 35/255, blue: 35/255, alpha: 0.3)
        overlayRenderer.lineWidth = 1
        return overlayRenderer
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if manager.location!.distance(from: coordinate) > 100 {
            updateMap()
        }
    }
}

