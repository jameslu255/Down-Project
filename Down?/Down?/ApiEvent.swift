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
    
    /**
     Constructs an EventDate object
        
     - parameter startDate: The start Date
     - parameter endDate: The end Date
     - returns: EventDate object

    */
    public init(startDate: Date, endDate: Date) {
        self.startDate = startDate
        self.endDate = endDate
    }
}

public struct EventLocation {
    var latitude: Double
    var longitude: Double
    
    /**
     Constructs an EventLocation object given latitude and longitude as Double
        
     - parameter latitude: The latitude
     - parameter longitude: The longitude
     - returns: EventLocation object

    */
    public init(latitude: Double, longitude: Double) {
        self.longitude = longitude
        self.latitude = latitude
    }
    
        /**
     Constructs an EventLocation object GeoPoint optional. This is a failable constructor
      because is optionally stored on Firestore
        
     - parameter geoPoint: The GeoPoint optional
     - returns: EventLocation object

    */
    public init?(geoPoint: GeoPoint?) {
        guard let geoPoint = geoPoint else { return nil }
        self.longitude = geoPoint.longitude
        self.latitude = geoPoint.latitude
    }
    
}

public struct ApiUser {
    var uid: String
    var displayName: String
    var profilePicture: UIImage?
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
    var categories: [String]?
    var dates: EventDate
    
    /**
     Constructs an Event object using default parameters
        
     - parameter displayName: The user's display name
     - parameter uid: The user's ID
     - parameter startDate: The start Date of the event
     - parameter endDate: The end Date of the event
     - parameter isPublic: Visibility of the event
     - parameter description: The event's description
     - parameter title: The event's title
     - parameter latitude: The event's latitude
     - parameter longitude: The event's longitude
     - parameter categories: The array of event categories

     - returns: Event object

    */
    public init(displayName: String, uid: String, startDate: Date, endDate: Date, isPublic: Bool, description: String?, title: String?, latitude: Double?, longitude: Double?, categories: [String]?) {
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
        self.categories = categories
    }
    /**
     Constructs an Event object using struct parameters
        
     - parameter displayName: The user's display name
     - parameter uid: The user's ID
     - parameter eventDate: The event's date
     - parameter isPublic: Visibility of the event
     - parameter description: The event's description
     - parameter title: The event's title
     - parameter eventLocation: The event's coordinates
     - parameter categories: The array of event categories

     - returns: Event object

    */
    public init(displayName: String, uid: String, date: EventDate, isPublic: Bool, description: String?, title: String?, location: EventLocation?, categories: [String]?) {
        self.numDown = 0
        self.uid = uid
        self.originalPoster = displayName
        self.title = title
        self.dates = date
        self.isPublic = isPublic
        self.description = description
        self.location = location
        self.categories = categories
    }
    
    /**
     Constructs an Event object using dictionary
        
     - parameter dict: The event's details
     - parameter autoID: The auto ID of the event

     - returns: Event object

    */
    init(dict: [String: Any], autoID: String) {
        let startTimeStamp = dict["startTime"] as? Timestamp
        let endTimeStamp = dict["endTime"] as? Timestamp
        let geoPoint = dict["location"] as? GeoPoint
        let categories = dict["categories"] as? [String:Int] ?? [:]
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
        self.categories = Array(categories.keys)
        }
    
}

public class ApiEvent {
    private static let db = Firestore.firestore()
    
    
    /**
     Fetches a list of event IDs that the user is down for.

     - parameter uid: The user ID to fetch IDs of down events
     - parameter completion: Closure whose callback will contain the list of the event IDs
     - returns: Void

    */
    private static func getDownEventIDs(uid: String, completion: @escaping ([String]) -> Void) {
        var downEventIDs = [String]()
        
        //get the ID of the down events
        db.collection("user_events").document(uid).collection("down")
            .getDocuments() { snapshot, error in
            if error != nil { return }
            guard let documents = snapshot?.documents else { return }
            for document in documents {
                let downEventID = document.documentID
                downEventIDs.append(downEventID)
            }
            completion(downEventIDs)
        }
    }
    
    /**
     Fetches a list of event IDs that the user is not down for.

     - parameter uid: The user ID to fetch down events
     - parameter completion: Closure whose callback will contain the list of the event IDs
     - returns: Void

    */
    public static func getDownEvents(uid: String, completion: @escaping ([Event]) -> Void) {
        var downEvents = [Event]()
        //synchronize event lookup
        let group = DispatchGroup()
        //get the user's down events
        db.collection("user_events").document(uid).collection("down").getDocuments() { snapshot, error in
            if error != nil { return }
            guard let documents = snapshot?.documents else { return }
            for document in documents {
                group.enter()
                let downEventID = document.documentID
                self.getEventDetails(autoID: downEventID) { event in
                    if let event = event {
                        downEvents.append(event)
                    }
                    group.leave()
                }
            }
            //the query is finished
            group.notify(queue: .main) {
                completion(downEvents)
            }
        }
    }
    
    /**
     Fetches a list of event objects that the user is down for.

     - parameter uid: The user ID
     - parameter completion: Closure whose callback will contain the list of the event objects
     - returns: Void

    */
    public static func getNotDownEvents(uid: String, completion: @escaping ([Event]) -> Void) {
        var notDownEvents = [Event]()
        //synchronize event lookup
        let group = DispatchGroup()
        db.collection("user_events").document(uid).collection("not_down").getDocuments() { snapshot, error in
            if error != nil { return }
            guard let documents = snapshot?.documents else { return }
            for document in documents {
                group.enter()
                let notDownEventID = document.documentID
                self.getEventDetails(autoID: notDownEventID) { event in
                    if let event = event {
                        notDownEvents.append(event)
                    }
                    group.leave()
                }
            }
            //the query is finished
            group.notify(queue: .main) {
                completion(notDownEvents)
            }
        }
    }
    
    /**
     Fetches a list of event objects that the user has previously created

     - parameter uid: The id of the user to fetch created events
     - parameter completion: Closure whose callback will contain the list of the event objects
     - returns: Void

    */
    public static func getCreatedEvents(uid: String, completion: @escaping ([Event]) -> Void) {
        var createdEvents = [Event]()
        //synchronize event lookup
        let group = DispatchGroup()
        db.collection("user_events").document(uid).collection("created").getDocuments() { snapshot, error in
            if error != nil { return }
            guard let documents = snapshot?.documents else { return }
            for document in documents {
                group.enter()
                let createdEventID = document.documentID
                self.getEventDetails(autoID: createdEventID) { event in
                    if let event = event {
                        createdEvents.append(event)
                    }
                    group.leave()
                }
            }
            group.notify(queue: .main) {
                completion(createdEvents)
            }
        }
    }
    
    /**
     Fetches a list of event objects that the user is not down for.

     - parameter uid: The ID of the user to fetch not down events
     - parameter completion: Closure whose callback will contain the list of the event objects
     - returns: Void

    */
    private static func getNotDownEventIDs(uid: String, completion: @escaping ([String]) -> Void) {
        var notDownEventIDs = [String]()

        db.collection("user_events").document(uid).collection("not_down")
            //.whereField("date", isGreaterThanOrEqualTo: Timestamp(date: Date()))
            .getDocuments() { snapshot, error in
            if error != nil { return }
            guard let documents = snapshot?.documents else { return }
            for document in documents {
                let notDownEventID = document.documentID
                notDownEventIDs.append(notDownEventID)
            }
            completion(notDownEventIDs)
        }
    }
    
    /**
     Fetches a list of event IDs  that the user has responded to. This list will contain the concatentation of
      the user's down event IDs and not down event IDs

     - parameter uid: The user ID
     - parameter completion: Closure whose callback will contain the list of the event IDs
     - returns: Void

    */
    public static func getViewedEventIDs(uid: String, completion: @escaping ([String]) -> Void) {
        getDownEventIDs(uid: uid) { downEventIDs in
            getNotDownEventIDs(uid: uid) { notDownEventIDs in
                completion(downEventIDs + notDownEventIDs)
            }
        }
    }
    
    /**
     Fetches a list of event objects that the user did not respond to.
     
     # Notes: #
      This makes three separate API calls to get the down event IDs, not down event IDs, and the event IDs that
       are not present in the those two former lists.

     - parameter uid: The ID of the user to query unviewed events
     - parameter completion: Closure whose callback will contain the list of the event objects
     - returns: Void

    */
    public static func getUnviewedEvent(uid: String, completion: @escaping ([Event]) -> Void) {
        //get IDs of events the user has responded to
        //make sure the event is still valid
        getViewedEventIDs(uid: uid) { viewedEventIDs in
            db.collection("events")
                .whereField("endTime", isGreaterThanOrEqualTo: Timestamp(date: Date()))
                .getDocuments() { (snapshot, error) in
                    var unviewedEvents = [Event]()
                    if error != nil { return }
                    guard let documents = snapshot?.documents else { return }
                    for document in documents {
                        let eventID = document.documentID
                        //the user has not responded to this event before
                        if !viewedEventIDs.contains(eventID) {
                            let event = Event(dict: document.data(), autoID: eventID)
                            unviewedEvents.append(event)
                        }
                    }
                    completion(unviewedEvents)
            }
        }
    }
    
    /**
        Fetches a list of event objects that the user did not respond to by optional filters.
        
        # Notes: #
         This makes three separate API calls to get the down event IDs, not down event IDs, and the event IDs that
          are not present in the those two former lists.

        - parameter uid: The user ID
        - parameter categories: The list of categories
        - parameter completion: Closure whose callback will contain the list of the event objects
        - returns: Void

       */
    public static func getUnviewedEventFilter(uid: String, categories: [String], completion: @escaping ([Event]) -> Void) {
        //get the viewed event IDs
        getViewedEventIDs(uid: uid) { viewedEventIDs in
            //only get events that are still happening
            let ref = db.collection("events")
                .whereField("endTime", isGreaterThanOrEqualTo: Timestamp(date: Date()))
            ref.getDocuments() { (snapshot, error) in
                var unviewedEvents = [Event]()
                if error != nil { return }
                guard let documents = snapshot?.documents else { return }
                for document in documents {
                    let eventID = document.documentID
                    //the user hasn't responded to this event yet
                    if !viewedEventIDs.contains(eventID) {
                        let event = Event(dict: document.data(), autoID: eventID)
                        if let eventCat = event.categories, !categories.isEmpty {
                            //if the event categories intersects with the user set categories
                            if categories.intersects(with: eventCat) {
                                unviewedEvents.append(event)
                            }
                        } else {
                            unviewedEvents.append(event)
                        }
                    }
                }
                completion(unviewedEvents)
            }
        }
    }

    /**
     Formats the event for storage into Firestore and adds it to the `events` collection

     - parameter event: The event object to be added to Firestore
     - returns: AutoID of newly added event if added to events on Firestore

    */
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
            "isPublic": event.isPublic,
            ] as [String : Any]
        if let categories = event.categories {
            var categoryDict = [String:Bool]()
            for category in categories {
                categoryDict[category] = true
            }
            eventDict["categories"] = categoryDict
        }
        
        //we can't hae null doubles, so this is a workaround
        if let location = event.location {
            eventDict["location"] = GeoPoint(latitude: location.latitude,
                                            longitude: location.longitude)
        }
        
        //add to the events collection
        let ref = db.collection("events").addDocument(data: eventDict) { error in
            if let error = error {
                responseError = error
            }
        }
        if responseError != nil { return nil }
        
        
        //get the autoID
        let autoID = ref.documentID
        
        //add to user events table
        db.collection("user_events")
            .document(event.uid)
            .collection("created")
            .document(autoID)
            .setData(["date": Timestamp(date: Date())]) { error in
            if let error = error {
                responseError = error
            }
        }
        if responseError != nil { return nil }
        
        
        return autoID
    }
    
    /**
     Fetches information of the event from Firestore from  the `events` collection

     - parameter autoID: The auto ID of the event
     - parameter completion: Closure whose callback will contain the event object
     - returns: Void

    */
    public static func getEventDetails(autoID: String, completion: @escaping (Event?) -> Void) {
        //get the event from events
        db.collection("events").document(autoID).getDocument() { (document, error) in
            if error != nil {
                completion(nil)
                return
            }
            //we could find the event
            if let responseDocument = document, responseDocument.exists {
                guard let data = responseDocument.data() else {
                    completion(nil)
                    return
                }
                let event = Event(dict: data, autoID: autoID)
                completion(event)
            } else {
                completion(nil)
            }
        }
    }
    
    /**
     Adds the event ID as `user_events/<user_id>/down/<event_id>/`
        
     # Note: #
     The event ID document is a reference to the `events` table. In addition, the document will contain
      a key called `date`, which is a timestamp of when the user pressed down

     - parameter eventID: The event ID to be added
     - parameter uid: The ID of the user who pressed down
     - parameter completion: Closure whose callback will contain the list of the event objects
     - returns: Void

    */
    public static func addUserDown(eventID: String, uid: String, completion: @escaping () -> Void) {
      //add the event to the user's down collection with the time
        db.collection("user_events")
            .document(uid)
            .collection("down")
            .document(eventID)
            .setData(["date": Timestamp(date: Date())]) { error in
                if error != nil { return }
                db.collection("events").document(eventID).updateData(["numDown": FieldValue.increment(Int64(1))])
                completion()
        }
    }
    
    /**
     Adds the event ID as `user_events/<user_id>/not_down/<event_id>/`
        
     # Note: #
     The event ID document is a reference to the `events` table. In addition, the document will contain
      a key called `date`, which is a timestamp of when the user pressed down

     - parameter eventID: The event ID to be added
     - parameter uid: The ID of the user who pressed not down
     - parameter completion: Closure whose callback will contain the list of the event objects
     - returns: Void

    */
    public static func addUserNotDown(eventID: String, uid: String, completion: @escaping () -> Void) {
        //add the event to the user's not down collection with the time
        db.collection("user_events")
            .document(uid)
            .collection("not_down")
            .document(eventID)
            .setData(["date": Timestamp(date: Date())]) { error in
                if error != nil { return }
                completion()
        }
    }
    
    /***
    Updates the event information on Firestore on the `events` collection

      - parameter eventID: The event ID to be added to Firestore
      - returns: AutoID of newly added event if added to events on Firestore

     */
    public static func updateEvent(event: Event, completion: @escaping () -> Void) {
        guard let eventID = event.autoID else { return }
        //prepare the event dictionary to be added to firestore
        var eventDict = [
            "title": event.title ?? "",
            "description": event.description ?? "",
            "uid": eventID,
            "displayName": event.originalPoster,
            "startTime": Timestamp(date: event.dates.startDate),
            "endTime": Timestamp(date: event.dates.endDate),
            "numDown": event.numDown,
            "isPublic": event.isPublic,
            ] as [String : Any]
        //if the user set categories
        if let categories = event.categories {
            var categoryDict = [String:Bool]()
            for category in categories {
                categoryDict[category] = true
            }
            eventDict["categories"] = categoryDict
        }
        //we can't hae null doubles, so this is a workaround
        if let location = event.location {
            eventDict["location"] = GeoPoint(latitude: location.latitude,
                                             longitude: location.longitude)
        }
        
        //add to the events collection
        db.collection("events").document(eventID).setData(eventDict) { error in
            if let error = error {
                print(error)
            } else {
                completion()
            }
        }
    }
    
    /**
     Undo the user's action on the event

     - parameter eventID: The event ID
     - parameter uid: The user's event
     - parameter from: Undo action from either `down` or `not_down`
     - parameter completion: Closure whose callback will contain the list of the event objects
     - returns: Void

    */
    public static func undoEventAction(eventID: String, uid: String, from: String, completion: @escaping () -> Void) {
        //should only be able to modify down or not down
        if (from != "down" && from != "not_down") { return }
        db.collection("user_events").document(uid).collection(from).document(eventID).delete() { error in
            if let error = error {
                print(error)
            } else {
                if from == "down" {
                    //atomically decrement numDown
                    db.collection("events").document(eventID).updateData(["numDown": FieldValue.increment(Int64(-1))])
                }
                completion()
            }
        }
    }
    
    /**
     Removes the event from the `event` collection
     
     # Note: #
     This only removes the event object from `event`, but it doesn't remove the references from
     the `user_events` tables

     - parameter eventID: The event ID
     - parameter completion: Closure whose callback will contain the list of the event objects
     - returns: Void

    */
    public static func deleteEvent(eventID: String, completion: @escaping () -> Void) {
        //delete the event from the events
        db.collection("events").document(eventID).delete() { error in
            if let error = error {
                print(error)
            } else {
                completion()
            }
        }
    }
}


// Display functionality
extension Event {
    var stringShortFormat: String {
        get{
            var result: String = ""
            let formatter = DateFormatter()
            formatter.dateStyle = .none
            formatter.timeStyle = .short
            let start = formatter.string(from: self.dates.startDate)
            let end = formatter.string(from: self.dates.endDate)
            result = "\(start) - \(end)"
            result = result.replacingOccurrences(of: ":00", with: "")
            return result
        }
    }
}

//used to find events with certain categories
extension Sequence where Iterator.Element : Hashable {
    //nice O(n) intersection function that uses set
    func intersects<S : Sequence>(with sequence: S) -> Bool
        where S.Iterator.Element == Iterator.Element
    {
        let sequenceSet = Set(sequence)
        return self.contains(where: sequenceSet.contains)
    }
}
