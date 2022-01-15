//
//  MotionManager.swift
//  CoreLocationExample
//
//  Created by saj panchal on 2022-01-15.
//
import SwiftUI
import Foundation
import CoreMotion
struct MotionManager: View {
    let motionManager = CMMotionManager()
    let queue = OperationQueue()
    
    @ObservedObject var locationFetcher = LocationFetcher()
    
    @State var pitch: Double = 0.0
    @State var yaw: Double = 0.0
    @State var roll: Double = 0.0
    @State var phoneStatus = "Unknown"
    
    var body: some View {
        VStack {
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
        }
        .onAppear(perform: startUpdatingMotion)
     
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

struct MotionManager_Previews: PreviewProvider {
    static var previews: some View {
        MotionManager()
    }
}
