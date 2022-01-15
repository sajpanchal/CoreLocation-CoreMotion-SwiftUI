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
               MotionManager()
                
            } .onAppear(perform: {
                startFetchinglocationData()
              
                    
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
                                       .padding(.trailing, 2)
                                       .padding(.vertical, 2)
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
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
