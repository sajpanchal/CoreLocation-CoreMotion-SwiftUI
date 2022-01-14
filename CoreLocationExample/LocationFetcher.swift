//
//  CoreLocation.swift
//  CoreLocationExample
//
//  Created by saj panchal on 2022-01-11.
//

import Foundation
import CoreLocation

class LocationFetcher: NSObject, CLLocationManagerDelegate, ObservableObject {
    //starts and stops location based events.
    let manager = CLLocationManager()
    
    //a struct type object holding lat and long of any location
    @Published var currentLocation: CLLocation?
    @Published var previousLocation: CLLocation?
    @Published var totalDistance: Double = 0.0
    @Published var speed: Double = 0.0
    override init() {
        super.init()
        //now we are assigning this class instance as a delegate to our location manager object to use its method and call them when certain events occur.
        manager.delegate = self
      
        manager.pausesLocationUpdatesAutomatically = false
        
        //allow location updates in background
        manager.allowsBackgroundLocationUpdates = true
        
        //show the background location update indicator on status bar.
        manager.showsBackgroundLocationIndicator = true
    }
    
    func start() {
        // delegate method to ask for user permission to allow location access whether or not the app is in use.
        manager.requestAlwaysAuthorization()
        //do not pause the location updates by itself
        manager.pausesLocationUpdatesAutomatically = false
      
        
        totalDistance = 0.0
        //this method will make sure user's updated location are returned as soon as it changes.
        manager.startUpdatingLocation()
    }
    
    //a delegate method that will be called every time the user loctation updates.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      
        // set the previous locations as the currentlocation and if it is not available set it as last updated location
        previousLocation = currentLocation ?? locations.last
        
        //set the current location as latest updated location
        currentLocation = locations.last
        
        //get the speed of the current location
        speed = getSpeed(currentLocation: currentLocation!)
        
        //if the device is moving i.e. speed is > 0
        if speed > 0.00 {
        // calculate the distance travelled.
        totalDistance += getDistance(previousLocation: previousLocation!, currentLocation: currentLocation!)
        }
    }

    func getDistance(previousLocation: CLLocation, currentLocation: CLLocation) -> Double {
        // use the distance function of CLLocation object to measure distance from one CLLocation to other CLLocation object. it will be in meters.
        let distance = previousLocation.distance(from: currentLocation)
        
        //convert meters distance to km.
        let distInkm = Double(distance)/1000
        print("location is updated... \(distInkm)")
        return distInkm
    }
    
    func getSpeed(currentLocation: CLLocation)-> Double {
        //CLLocation object has a prop called speed that gives a speed calculated at a given location.
        let speed = Double(currentLocation.speed*3.6)
                       
        return speed < 0 ?  0 : speed
    }
    
    
}

