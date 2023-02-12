//
//  LocationInfoViewModel.swift
//  FindCVS
//
//  Created by Cody on 2023/02/12.
//

import Foundation
import CoreLocation
import MapKit
import Combine

class LocationInfoViewModel: ObservableObject {
    var cancellables = Set<AnyCancellable>()
    
    private let locationService = LocationService()
    
    @Published var isLoading = false
    @Published var locationError: LocationError?
    @Published var isAlertShowing = false
    
    @Published var currentLocation = CLLocationCoordinate2D(latitude: 37.394225, longitude: 127.110341) // 사용자 위치
    @Published var mapCenterPoint: MKCoordinateRegion = MKCoordinateRegion( // 지도 중심
        center: CLLocationCoordinate2D(latitude: 37.394225, longitude: 127.110341),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    ) {
        didSet {
            print("mapCenterPoint: \(mapCenterPoint)")
        }
    }
    @Published var selectAnnotationLocation: CLLocationCoordinate2D? // 선택된 Annotation의 위치
    
    @Published var detailListCellData: [DetailListCellData] = [] // Map, List에 표시될 Data
    
    @Published var documentData: [KLDocument] = []
    
    init(model: LocationInfoModel = LocationInfoModel()) {
        // 위치 권한 요청
        locationService.requestWhenInUseAuthorization()
            .sink { completion in
                if case .failure(let error) = completion {
                    self.locationError = error
                }
                self.isLoading = false
            } receiveValue: { }
            .store(in: &cancellables)

        // 지도 중심점 설정
        // 현재 위치 버튼 눌렀을 때 받아온 위치가 갱신되면 mapCenterPoint 반영
        $currentLocation
            .sink(receiveValue: { [weak self] location in
                self?.mapCenterPoint = MKCoordinateRegion(
                    center: location,
                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                )
            })
            .store(in: &cancellables)
        
        // 리스트에서 아이템 눌렀을 때 받아온 위치가 갱신되면 mapCenterPoint 반영
        $selectAnnotationLocation
            .sink(receiveValue: { [weak self] location in
                if let location {
                    self?.mapCenterPoint = MKCoordinateRegion(
                        center: location,
                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                    )
                }
            })
            .store(in: &cancellables)
        
        // locationError시 alert 표시
        $locationError
            .sink(receiveValue: { [weak self] error in
                if error != nil {
                    self?.isAlertShowing = true
                }
                else {
                    self?.isAlertShowing = false
                }
            })
            .store(in: &cancellables)
        
        // documentData -> detailListCellData 변환
        $documentData
            .sink(receiveValue: { [weak self] data in
                self?.detailListCellData = model.documentsToCellData(data)
            })
            .store(in: &cancellables)
    }
    
    public func currentLocationButtonTapped() {
        fetchLocation()
    }
    
    func fetchLocation() {
        isLoading = true
        locationService.requestWhenInUseAuthorization()
            .flatMap { self.locationService.requestLocation() }
            .sink { completion in
                if case .failure(let error) = completion {
                    self.locationError = error
                }
                self.isLoading = false
            } receiveValue: { location in
                self.currentLocation = location.coordinate
            }
            .store(in: &cancellables)
    }
}

