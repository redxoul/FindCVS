//
//  KakaoLocalNetwork.swift
//  FindCVS
//
//  Created by Cody on 2023/02/12.
//

import Foundation
import CoreLocation
import Combine

class KakaoLocalNetwork {
    var cancellables = Set<AnyCancellable>()
    
    private let session: URLSession
    let api = KakaoLocalAPI()
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func getLocation(by coordinate: CLLocationCoordinate2D) {
        guard let url = api.getLocation(by: coordinate).url else {
            return
        }
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("KakaoAK (Kakao API Key)", forHTTPHeaderField: "Authorization")
        
        session.dataTaskPublisher(for: request as URLRequest)
            .tryMap() { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return element.data
            }
            .decode(type: LocationData.self, decoder: JSONDecoder())
            .sink(receiveCompletion: {
                print ("Received completion: \($0).")
                
            }, receiveValue: { locationDatas in
                print ("Received user: \(locationDatas).")
                
            })
            .store(in: &cancellables)
    }
    
    
//    func getLocation(by coordinate: CLLocationCoordinate2D) -> Single<Result<LocationData, URLError>> {
//        guard let url = api.getLocation(by: coordinate).url else {
//            return .just(.failure(URLError(.badURL)))
//        }
//
//        let request = NSMutableURLRequest(url: url)
//        request.httpMethod = "GET"
//        request.setValue("KakaoAK 3fdf4ed39646c07cbebefac17b554468", forHTTPHeaderField: "Authorization")
//
//        return session.rx.data(request: request as URLRequest)
//            .map { data in
//                do {
//                    let locationData = try JSONDecoder().decode(LocationData.self, from: data)
//                    return .success(locationData)
//                } catch {
//                    return .failure(URLError(.cannotParseResponse))
//                }
//            }
//            .catch { _ in .just(Result.failure(URLError(.cannotLoadFromNetwork))) }
//            .asSingle()
//    }
    
}
