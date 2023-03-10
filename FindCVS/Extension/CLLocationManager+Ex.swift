//
//  CLLocationManager+Ex.swift
//  FindCVS
//
//  Created by Cody on 2023/02/12.
//

import Foundation
import Combine
import CoreLocation

//extension CLLocationManager {
//    public static func publishLocation() -> LocationPublisher{
//        return .init()
//    }
//
//    public struct LocationPublisher: Publisher {
//        public typealias Output = CLLocation
//        public typealias Failure = Never
//
//        public func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
//            let subscription = LocationSubscription(subscriber: subscriber)
//            subscriber.receive(subscription: subscription)
//        }
//        
//        final class LocationSubscription<S: Subscriber> : NSObject, CLLocationManagerDelegate, Subscription where S.Input == Output, S.Failure == Failure{
//            var subscriber: S
//            var locationManager = CLLocationManager()
//            
//            init(subscriber: S) {
//                self.subscriber = subscriber
//                super.init()
//                locationManager.delegate = self
//            }
//
//            func request(_ demand: Subscribers.Demand) {
//                locationManager.startUpdatingLocation()
//                locationManager.requestWhenInUseAuthorization()
//            }
//            
//            func cancel() {
//                locationManager.stopUpdatingLocation()
//            }
//            
//            func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//                for location in locations {
//                    _ = subscriber.receive(location)
//                }
//            }
//        }
//    }
//}
