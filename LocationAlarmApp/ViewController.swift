//
//  ViewController.swift
//  LocationAlarmApp
//
//  Created by Luyuan Xing on 7/2/16.
//  Copyright © 2016 Luyuan Xing. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate {
    
    let locationManager = CLLocationManager()
    let mapView = MKMapView()
    
    let label = UILabel()
    let destinationField = UITextField()
    let submitButton = UIButton()
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.mapView.showsUserLocation = true
        
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.startUpdatingLocation()
        
        self.mapView.delegate = self
        self.mapView.showsUserLocation = true
        
        mapView.frame = CGRect(x: 0, y: self.view.frame.maxY*0.2, width: self.view.frame.width, height: self.view.frame.height*0.8)
        self.view.addSubview(mapView)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(label)
        self.view.addConstraint(NSLayoutConstraint(item: label, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 40))
        self.view.addConstraint(NSLayoutConstraint(item: label, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1.0, constant: -60))
        label.textAlignment = .center
        label.text = "Please enter a destination"
        
        self.destinationField.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(destinationField)
        self.view.addConstraint(NSLayoutConstraint(item: destinationField, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: -40))
        self.view.addConstraint(NSLayoutConstraint(item: destinationField, attribute: .top, relatedBy: .equal, toItem: self.label, attribute: .top, multiplier: 1.0, constant: 30))
        self.view.addConstraint(NSLayoutConstraint(item: destinationField, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 0.6, constant: 0))
        self.destinationField.layer.cornerRadius = 10
        self.destinationField.layer.borderWidth = 1
        self.destinationField.layer.borderColor = UIColor.black().cgColor
        
        self.submitButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(submitButton)
        self.view.addConstraint(NSLayoutConstraint(item: submitButton, attribute: .top, relatedBy: .equal, toItem: self.destinationField, attribute: .top, multiplier: 1.0, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: submitButton, attribute: .height, relatedBy: .equal, toItem: self.destinationField, attribute: .height, multiplier: 1.0, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: submitButton, attribute: .left, relatedBy: .equal, toItem: self.destinationField, attribute: .right, multiplier: 1.0, constant: 25 ))
        self.submitButton.setTitle("submit", for: [])
        self.submitButton.setTitleColor(UIColor.black(), for: [])

        self.submitButton.addTarget(self, action: #selector(ViewController.showDestination), for: .touchUpInside)
        
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        
        self.mapView.setRegion(region, animated: false)
    }
    
    
    func showDestination() {
        if let searchTerm = self.destinationField.text {
            convertAddressToCoordiantes(searchTerm: searchTerm) { location in
                
                let center = CLLocationCoordinate2DMake(location.latitude, location.longitude)
                let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
                self.mapView.setRegion(region, animated: true)
                
            }
        }
    }
    
    func convertAddressToCoordiantes (searchTerm: String, completion: (CLLocationCoordinate2D) -> Void) {
        var location = CLLocation()
        let searchRequest = MKLocalSearchRequest()
        searchRequest.naturalLanguageQuery = searchTerm
        let search = MKLocalSearch(request: searchRequest)
        
        search.start { (response, error) -> Void in
            if let mapItem = response?.mapItems.first {
                location = mapItem.placemark.location!
                completion(location.coordinate)
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                print("No access")
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
            }
        } else {
            print("access denied")
            let alert = UIAlertController(title: "Location Services", message: "This app needs to access your location in order to work.", preferredStyle: UIAlertControllerStyle.alert)
            
            let alertAction = UIAlertAction(title: "Go to Settings", style: UIAlertActionStyle.default, handler: { (_) in
                let settingsUrl = NSURL(string: UIApplicationOpenSettingsURLString)
                if let url = settingsUrl {
                    UIApplication.shared().openURL(url as URL)
                }
            })
            alert.addAction(alertAction)
            
            self.present(alert, animated: true, completion: nil)
        }
        
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    
    
    
    
    
}

