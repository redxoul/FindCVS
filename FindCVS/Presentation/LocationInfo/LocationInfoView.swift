//
//  ContentView.swift
//  FindCVS
//
//  Created by Cody on 2023/02/08.
//

import SwiftUI
import MapKit

struct LocationInfoView: View {
    @ObservedObject var viewModel: LocationInfoViewModel
    
    @State private var trackingMode: MapUserTrackingMode = .follow
    
    init(viewModel: LocationInfoViewModel = LocationInfoViewModel()) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationView {
            VStack {
                ZStack(alignment: .bottom) {
                    Map(coordinateRegion: $viewModel.mapCenterPoint, showsUserLocation: true, userTrackingMode: $trackingMode, annotationItems: viewModel.detailListCellData) {
                        MapMarker(coordinate: $0.point)
//                            .onTapGesture(count: 1) {
//                                print("Tap MapMarker")
//                            }
                    }
                    
                    HStack {
                        Button {
                            viewModel.currentLocationButtonTapped()
                        } label: {
                            Image(systemName: "scope")
                                .frame(width: 40, height: 40)
                        }
                        .background(Color.white)
                        .clipShape(Circle())
                        .padding(12)
                        
                        Spacer()
                    }
                }
                
                if viewModel.detailListCellData.count == 0 {
//                if viewModel.detailListCellData.count > 0 {
                    ScrollViewReader { proxy in
                        List(0 ..< 10, id: \.self) { index in
                            Button {
                                proxy.scrollTo(index, anchor: .top)
                            } label: {
                                HStack {
                                    VStack(alignment: .leading, spacing: 3) {
                                        Text("이마트24 R판교알파돔 2호점")
                                            .fontWeight(.bold)
                                            .font(.title3)
                                        Text("경기 성남시 분당구 판교역로 152")
                                            .fontWeight(.light)
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                    
                                    Spacer()
                                    
                                    Text("\(10*index)m")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .listStyle(.plain)
                    }
                }
                else {
                    VStack {
                        Spacer()
                        
                        Text("""
                    🤔
                    500m 근처에 편의점이 없습니다.
                    지도 위치를 옮겨서 재검색해주세요.
                    """)
                        .multilineTextAlignment(.center)
                        
                        Spacer()
                    }
                }
            }
            .navigationTitle("🏪내 주변 편의점🔍")
            .navigationBarTitleDisplayMode(.inline)
            .alert("문제가 발생했습니다.", isPresented: $viewModel.isAlertShowing
            ) {
                Button("확인") {}
            } message: {
                Text("\(viewModel.locationError?.errorDescription ?? "")")
            }
        }
    }
}

struct LocationInfoView_Previews: PreviewProvider {
    static var previews: some View {
        LocationInfoView()
    }
}
