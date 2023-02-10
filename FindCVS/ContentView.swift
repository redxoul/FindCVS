//
//  ContentView.swift
//  FindCVS
//
//  Created by solgoon on 2023/02/08.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.394225, longitude: 127.110341),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    @State private var trackingMode: MapUserTrackingMode = .follow

    
    var body: some View {
        NavigationView {
            VStack {
                Map(coordinateRegion: $region, showsUserLocation: true, userTrackingMode: $trackingMode)
                
                
                Text("Hello, world!")
            }
            .navigationTitle("🏪내 주변 편의점🔍")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
