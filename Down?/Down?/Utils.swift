//
//  Utils.swift
//  Down?
//
//  Created by Caleb Bolton on 12/4/19.
//

import Foundation
import MapKit

// MARK: - UIViewController extension functions

extension UIViewController {
    
    /// Presents the specified view controller in the specified storyboard
    func present(viewControllerWithName viewControllerName: String, inStoryboardWithName storyboardName: String, withStyle style: UIModalPresentationStyle, isAnimated: Bool) {
            let storyBoard = UIStoryboard(name: storyboardName, bundle: nil)
            let viewController = storyBoard.instantiateViewController(identifier: viewControllerName)
            viewController.modalPresentationStyle = style
            self.present(viewController, animated: isAnimated, completion: nil)
    }
    
}

// MARK: - Map utility functions

/// Opens Apple Maps on the specified EventLocation
func openMap(location: EventLocation) {
    let lat = location.latitude
    let long = location.longitude
    let clLocation = CLLocation(latitude: lat, longitude: long)
    CLGeocoder().reverseGeocodeLocation(clLocation) { placemarks, error in
        if let error = error {
            print(error)
            return
        }
        
        guard let placemarks = placemarks else {
            return
        }
        
        if let name = placemarks[0].name {
            openMap(lat: lat, long: long, name: name)
        }
    }
}

/// Opens Apple Maps on the given coordinates displaying the given name
func openMap(lat: Double, long: Double, name: String) {
    let regionDistance:CLLocationDistance = 100
    let coordinates = CLLocationCoordinate2DMake(lat, long)
    let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
    let options = [
        MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
        MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
    ]
    let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
    let mapItem = MKMapItem(placemark: placemark)
    mapItem.name = name
    mapItem.openInMaps(launchOptions: options)
}

// MARK: - UIImage extension utilities

// Found on StackOverflow
// Will be used in future releases with profile pictures and event pictures
extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }

    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ quality: JPEGQuality) -> Data? {
        return self.jpegData(compressionQuality: quality.rawValue)
    }
    
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
        return UIGraphicsImageRenderer(size: canvas, format: imageRendererFormat).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvas = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        return UIGraphicsImageRenderer(size: canvas, format: imageRendererFormat).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
}

// MARK: - Filter utility functions

//https://www.geodatasource.com/developers/swift
///  This function converts decimal degrees to radians
func deg2rad(_ deg:Double) -> Double {
    return deg * Double.pi / 180
}

///  This function converts radians to decimal degrees
func rad2deg(_ rad:Double) -> Double {
    return rad * 180.0 / Double.pi
}

///  This function calculates the distance between two corrdinates in miles
func distanceInMiles(lat1:Double, lon1:Double, lat2:Double, lon2:Double) -> Double {
    let theta = lon1 - lon2
    var dist = sin(deg2rad(lat1)) * sin(deg2rad(lat2)) + cos(deg2rad(lat1)) * cos(deg2rad(lat2)) * cos(deg2rad(theta))
    dist = acos(dist)
    dist = rad2deg(dist)
    dist = dist * 60 * 1.1515

    return dist
}

/// Filters events by a given distance and returns the filtered events
func filterByDistance(events: [Event], currentLocation: EventLocation, distance: Double) -> [Event] {
    var filtered = [Event]()
    for event in events {
        if let lat = event.location?.latitude, let lon = event.location?.longitude {
            let distFromCurrLocation = distanceInMiles(lat1: currentLocation.latitude,
                                                       lon1: currentLocation.longitude, lat2: lat, lon2: lon)
            if distFromCurrLocation <= distance {
                print("curr: \(distFromCurrLocation) dist:\(distance)")
                filtered.append(event)
            }
        }
    }
    return filtered
}

/// Used to load all event locations after the events have been fetched
func loadLocations(events: [Event], completion: @escaping ([String?]) -> Void) {
    let group = DispatchGroup()
    //we don't use append because async appends are a bad idea
    var geoLocations: [String?] = Array(repeating: nil, count: events.count)
    for (index, event) in events.enumerated() {
        if let lat = event.location?.latitude, let long = event.location?.longitude {
            let location = CLLocation(latitude: lat, longitude: long)
            group.enter()
            CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
                if error != nil {
                  geoLocations[index] = nil
                  group.leave()
                  return
              }
                if let placemark = placemarks?[0], let name = placemark.name {
                    geoLocations[index] = name
                } else {
                    geoLocations[index] = nil
                }
                group.leave()
            }
        } else {
            geoLocations[index] = nil
        }
    }
    group.notify(queue: .main) {
        completion(geoLocations)
    }
}

/// Used to load all event locations after the events have been fetched
func loadLocations(completion: @escaping ([String?]) -> Void) {
    let group = DispatchGroup()
    //we don't use append because async appends are a bad idea
    var geoLocations: [String?] = Array(repeating: nil, count: events.count)
    for (index, event) in events.enumerated() {
        if let lat = event.location?.latitude, let long = event.location?.longitude {
            let location = CLLocation(latitude: lat, longitude: long)
            group.enter()
            CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
                if error != nil {
                  geoLocations[index] = nil
                  group.leave()
                  return
              }
                if let placemark = placemarks?[0], let name = placemark.name {
                    geoLocations[index] = name
                } else {
                    geoLocations[index] = nil
                }
                group.leave()
            }
        } else {
            geoLocations[index] = nil
        }
    }
    group.notify(queue: .main) {
        completion(geoLocations)
    }
}
