//
//  DetailListCellData.swift
//  SearchCVS
//
//  Created by Cody on 2022/12/01.
//

import Foundation
import CoreLocation

struct DetailListCellData: Identifiable {
    let id = UUID()
    let placeName: String
    let address: String
    let distance: String
    let point: CLLocationCoordinate2D
}
