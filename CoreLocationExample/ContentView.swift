//
//  ContentView.swift
//  CoreLocationExample
//
//  Created by saj panchal on 2022-01-11.
//

import SwiftUI
import CoreMotion
struct ContentView: View {
    @ObservedObject var locationFetcher = LocationFetcher()
    
    let motionManager = CMMotionManager()
    let queue = OperationQueue()
    
    @State var pitch = 0.0
    @State var yaw = 0.0
    @State var roll = 0.0
    @State var phoneStatus = "Unknown"
    @State var driveMode = true
    
    var body: some View {
        
        NavigationView {
            VStack {
                HStack {
                    Spacer()
                    Text("Core Location Data")
                        .font(.headline)
                        .fontWeight(.black)
                    Spacer()
                }
                .background(.blue)
                VStack {
                    Text("Distance travelled: \(locationFetcher.totalDistance, specifier: "%.2f") KM")
                       
                    Text("Speed: \(locationFetcher.speed, specifier: "%.2f") KM/h")
                }
                .padding(2)
                HStack {
                    Spacer()
                    Text("Core Motion Data")
                        .font(.headline)
                        .fontWeight(.black)
                       
                    Spacer()
                }
                .background(.pink)
                VStack {
                    Text("Pitch: \(pitch, specifier: "%.5f")")
                    Text("Yaw: \(yaw, specifier: "%.5f")")
                    Text("Roll: \(roll, specifier: "%.5f")")
                   
                }
                .padding(2)
                Text("Device Status:\(phoneStatus)")
                    .fontWeight(.black)
                    .font(.subheadline)
                    .padding(5)
                    .background(.yellow)
                    .cornerRadius(10)
            } .onAppear(perform: {
                startFetchinglocationData()
                startUpdatingMotion()
                    
            }).navigationTitle("Location-Motion Test")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {self.driveMode.toggle()
                               if self.driveMode == false {
                                   locationFetcher.manager.stopUpdatingLocation()
                                   print("location update has been stopped.")
                               }
                               else {
                                   startFetchinglocationData()
                               }}, label: {
                                   Text(driveMode ? "Disable Location" : "Enable Location")
                                       
                                       .font(.footnote)
                                       .fontWeight(.semibold)
                                       .padding(.trailing, 10)
                                       .padding(.vertical, 4)
                                       .frame(alignment: .center)
                               }
                                )
                        .background(driveMode ? Color.red : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(50)
                }
                }
                   
        }
            
    }
    func startFetchinglocationData() {
        self.locationFetcher.start()
        if let location = self.locationFetcher.currentLocation {
            print("Your location is \(location).")
            print("Distance traveled is \(locationFetcher.totalDistance)")
        }
        else {
            print("Your location is unknown.")
        }
    }
    func startUpdatingMotion() {
        //method that will start updating device motion activity.
        self.motionManager.startDeviceMotionUpdates(to: self.queue) {(data: CMDeviceMotion?, error: Error?) in
            guard let data = data else {
                print("Error: \(error!)")
                return
            }
            //device orientation data.
            let attitude: CMAttitude = data.attitude
            DispatchQueue.main.async {
                //device angle with a screen facing to the user
                self.pitch = attitude.pitch
                
                //device angle with a screen rotating facing to the user
                self.yaw = attitude.yaw
                
                //device angle with a screen rotating from user face to other side.
                self.roll = attitude.roll
                if self.pitch >= -0.1 && self.pitch <= 0.1 && self.roll >= -0.5 && self.roll <= 0.5 {
                    self.phoneStatus = "is Sitting Idle"
                }
                else if self.pitch >= 0.0 && self.pitch <= 1.2 && self.roll >= -0.2 && self.roll <= 1.3 && self.yaw >= -3.3 && self.yaw <= 3.3  {
                    self.phoneStatus = "in user's hand"
                    if self.locationFetcher.speed > 5.00 {
                        self.phoneStatus = "Driving"
                    }
                    else if self.locationFetcher.speed < 5.00 && self.locationFetcher.speed >= 1.00 {
                        self.phoneStatus = "Walking/Jogging"
                    }
                    else {
                        self.phoneStatus = "In user's hand"
                    }
                }
                else if self.pitch >= 0.7 && self.pitch <= 1.3 && self.roll >= -0.3 && self.roll <= 0.3 && self.yaw >= -0.3 && self.yaw <= 0.3  {
                   
                }
                
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
