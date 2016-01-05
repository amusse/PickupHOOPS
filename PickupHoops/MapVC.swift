//
//  MapVC.swift
//  PickupHoops
//
//  Created by Ahmed Musse on 1/3/16.
//  Copyright © 2016 Pickup Sports. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapVC: UIViewController, UISearchBarDelegate, CLLocationManagerDelegate
{
    @IBOutlet weak var sbSearch: UISearchBar!
    @IBOutlet weak var map: MKMapView!
    
    let locationManager = CLLocationManager()
    var currentLocation = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var selectedLocation = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var locationTitle = ""
    var matchingItems: [MKMapItem] = [MKMapItem]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
       
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.map.showsUserLocation = true
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations.last
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        self.map.setRegion(region, animated: true)
        self.locationManager.stopUpdatingLocation()
        currentLocation = center
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
    {
        print("Errors: " + error.localizedDescription)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar)
    {
        searchBar.resignFirstResponder()
        self.performSearch()
    }
    func searchBarCancelButtonClicked(searchBar: UISearchBar)
    {
        searchBar.resignFirstResponder()
    }
    @IBAction func btnCancel(sender: AnyObject)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    // Dismiss the keyboard after touching anywhere on screen
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        self.view.endEditing(true)
    }
    
    func performSearch()
    {
        map.removeAnnotations(map.annotations)
        let span = MKCoordinateSpanMake(1, 1)
        let region = MKCoordinateRegion(center: currentLocation, span: span)
        map.setRegion(region, animated: true)
        
        matchingItems.removeAll()
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = sbSearch.text
        request.region = map.region
        
        let search = MKLocalSearch(request: request)
        search.startWithCompletionHandler { (response, error) in
            guard let response = response else
            {
                print("Search error: \(error)")
                return
            }
            print("Matches found")
            for item in response.mapItems
            {
                print("Name = \(item.name)")
                print("Phone = \(item.phoneNumber)")
                self.matchingItems.append(item as MKMapItem)
                print("Matching items = \(self.matchingItems.count)")
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = item.placemark.coordinate
                annotation.title = item.name
                annotation.subtitle = item.phoneNumber
                self.map.addAnnotation(annotation)
            }
        }

    }
    // Send first name string to next view controller
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if self.map.selectedAnnotations.count > 0
        {
            if let ann: MKAnnotation = self.map.selectedAnnotations[0]
            {
                print("selected annotation: \(ann.title!)")
                
                let c = ann.coordinate
                selectedLocation = ann.coordinate
                locationTitle = ann.title!!
                
                print("coordinate: \(c.latitude), \(c.longitude)")
                
                //do something else with ann...
                
            }
        }
        let prevVC = segue.destinationViewController as! NewGameVC
        prevVC.selectedLocation = selectedLocation
        prevVC.locationTitle = locationTitle
    }

}