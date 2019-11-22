//
//  ApiEvent.swift
//  Down?
//
//  Created by user159963 on 11/17/19.
//

import Foundation
import Firebase

public struct EventDate {
    var startDate: Date
    var endDate: Date
    
    public init(startDate: Date, endDate: Date) {
        self.startDate = startDate
        self.endDate = endDate
    }
}

public struct EventLocation {
    var latitude: Double
    var longitude: Double
    var place: String?
    
    public init(latitude: Double, longitude: Double) {
        self.longitude = longitude
        self.latitude = latitude
    }
    
    public init?(geoPoint: GeoPoint?) {
        guard let geoPoint = geoPoint else { return nil }
        self.longitude = geoPoint.longitude
        self.latitude = geoPoint.latitude
    }
    
}

public struct Event {
    var originalPoster: String
    var uid: String
    var isPublic: Bool
    var numDown: Int
    var autoID: String?
    var description: String?
    var title: String?
    var location: EventLocation?
    var dates: EventDate
    
    public init(displayName: String, uid: String, startDate: Date, endDate: Date, isPublic: Bool, description: String?, title: String?, latitude: Double?, longitude: Double?) {
        var location: EventLocation? {
            if let lat = latitude, let long = longitude {
                return EventLocation(latitude: lat, longitude: long)
            }
            return nil
        }
        
        self.numDown = 0
        self.uid = uid
        self.originalPoster = displayName
        self.title = title
        self.dates = EventDate(startDate: startDate, endDate: endDate)
        self.isPublic = isPublic
        self.description = description
        self.location = location
    }
    
    public init(displayName: String, uid: String, date: EventDate, isPublic: Bool, description: String?, title: String?, location: EventLocation?) {
        self.numDown = 0
        self.uid = uid
        self.originalPoster = displayName
        self.title = title
        self.dates = date
        self.isPublic = isPublic
        self.description = description
        self.location = location
    }
    
    public init(dict: [String: Any], autoID: String) {
        let startTimeStamp = dict["startDate"] as? Timestamp
        let endTimeStamp = dict["endDate"] as? Timestamp
        let geoPoint = dict["location"] as? GeoPoint
        
        
        self.numDown = dict["numDown"] as? Int ?? 0
        self.autoID = autoID
        self.uid = dict["uid"] as? String ?? ""
        self.originalPoster = dict["displayName"] as? String ?? ""
        self.dates = EventDate(startDate: startTimeStamp?.dateValue() ?? Date(),
                               endDate: endTimeStamp?.dateValue() ?? Date())
        self.location = EventLocation(geoPoint: geoPoint)
        self.isPublic = dict["isPublic"] as? Bool ?? false
        self.description = dict["description"] as? String
        self.title = dict["title"] as? String
        }
    
}

public class ApiEvent {
    private static let db = Firestore.firestore()
    
    //private static let MAX_QUERY: UInt = 50
    //https://stackoverflow.com/questions/27341888/iterate-over-snapshot-children-in-firebase
    //https://stackoverflow.com/questions/53159028/firebase-firestore-structure-for-getting-un-seen-trending-posts-social
    public static func getDownEventIDs(uid: String, completion: @escaping ([String]) -> Void) {
        var downEventIDs = [String]()

        db.collection("user_events").document(uid).collection("down").getDocuments() { snapshot, error in
            if error != nil { return }
            guard let documents = snapshot?.documents else { return }
            for document in documents {
                let downEventID = document.documentID
                downEventIDs.append(downEventID)
            }
        }
        completion(downEventIDs)
    }
    
    public static func getNotDownEventIDs(uid: String, completion: @escaping ([String]) -> Void) {
        var notDownEventIDs = [String]()

        db.collection("user_events").document(uid).collection("not_down").getDocuments() { snapshot, error in
            if error != nil { return }
            guard let documents = snapshot?.documents else { return }
            for document in documents {
                let notDownEventID = document.documentID
                notDownEventIDs.append(notDownEventID)
            }
        }
        completion(notDownEventIDs)
    }
    
    public static func getViewedEventIDs(uid: String, completion: @escaping ([String]) -> Void) {
        getDownEventIDs(uid: uid) { downEventIDs in
            getNotDownEventIDs(uid: uid) { notDownEventIDs in
                completion(downEventIDs + notDownEventIDs)
            }
        }
    }
    
    //https://medium.com/@oleary.audio/understanding-the-firebase-observe-function-14c9f73808bc
    public static func getUnviewedEvent(uid: String, completion: @escaping ([Event]) -> Void) {
        getViewedEventIDs(uid: uid) { viewedEventIDs in
            db.collection("events").getDocuments() { (snapshot, error) in
                var unviewedEvents = [Event]()
                if error != nil { return }
                guard let documents = snapshot?.documents else { return }
                for document in documents {
                    let eventID = document.documentID
                    if !viewedEventIDs.contains(eventID) {
                        let event = Event(dict: document.data(), autoID: eventID)
                        unviewedEvents.append(event)
                    }
                }
                completion(unviewedEvents)
            }
        }
    }

    public static func addEvent(event: Event) -> String? {
        var responseError: Error?
        var eventDict = [
            "title": event.title ?? "",
            "description": event.description ?? "",
            "uid": event.uid,
            "displayName": event.originalPoster,
            "startTime": Timestamp(date: event.dates.startDate),
            "endTime": Timestamp(date: event.dates.endDate),
            "numDown": event.numDown,
            "isPublic": event.isPublic
            ] as [String : Any]
        if let location = event.location {
            eventDict["location"] = GeoPoint(latitude: location.latitude,
                                                   longitude: location.longitude)
        }
        let ref = db.collection("events").addDocument(data: eventDict) { error in
            if let error = error {
                responseError = error
            }
        }
        if responseError != nil { return nil }
        
        //get the autoID
        let autoID = ref.documentID
        
        
        return autoID
    }
    
    public static func getEventDetails(autoID: String, completion: @escaping (Event?) -> Void) {
        db.collection("events").document(autoID).getDocument() { (document, error) in
            if error != nil { return }
            
            if let responseDocument = document, responseDocument.exists {
                guard let data = responseDocument.data() else { return }
                let event = Event(dict: data, autoID: autoID)
                completion(event)
            }
        }
    }
    
    public static func addUserDown(event: Event, completion: @escaping () -> Void) {
        guard let eventID = event.autoID else { return }
        
        db.collection("user_events").document(event.uid).collection("down").addDocument(data: [eventID: true]) { error in
            if error != nil { return }
            completion()
        }
    }
    
    public static func addUserNotDown(event: Event, completion: @escaping () -> Void) {
        guard let eventID = event.autoID else { return }

        db.collection("user_events").document(event.uid).collection("not_down").addDocument(data: [eventID: true]) { error in
            if error != nil { return }
            completion()
        }
    }
}

