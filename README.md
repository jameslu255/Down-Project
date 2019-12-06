# README

# Signup/Login - James/Jonathan
If the user is not logged in, upon opening the app, they are presented with a screen that allows the user to signup or login. These methods are connected to Firebase, which handles all the user authentication. The auto-login will occur via the `SceneDelegate` when the Firebase `Auth` class contains authentication information for the last signed-in user.

# Home View - Caleb
## Home Feed
This is a TableView of all the events that the user has not made a decision on. The tableview contains cells that show basic information about the event such as the event title, event creator, duration, location, and number of people down for the event. Each cell can be swiped left or right to indicate whether the user is down or not down for the event. Once the user has swiped on the event, the cell is removed from the table and placed in the Decided events view controller table. Each cell can also be tapped which will bring up a more detailed view of the event including a description if there is one. 

## Decided Events - Caleb
This is a TableView of all the events that the user has “Down”ed and “Not Down”ed. Like the home feed, the events can be swiped, but in this view, the actions of swiping are slightly different. If you swipe left on any of the views in this table, the user is no longer down or not down for the event, it is placed back in the home feed. If the user swipes right, it makes the user down if they were not down and not down if they were down (just makes it the opposite).

## Map View
See Map View under location services for details

## Sign out
This screen makes an API call to Firebase to sign out the current user.

# Filter - James/Jonathan
The two kinds of filter that may occur are filter by categories and filter by distance. Because Firestore only allows equality operations on only field (which we use on event end time), we have to perform these filters locally. The filter by category happens using a custom intersection function that uses set operations. The category filter will find events having categories that intersect the user’s defined categories. The distance filter occurs using trigonometry to find the calculate distance from the user’s current coordinates to the event’s coordinates in miles. This filter will find events whose distance from the user’s coordinates is less than or equal to the user set distance.

# Sort - James
The sort feature takes the current event array and then sorts it in the order of the parameter. You can sort it by Time (which is default), Distance (from the current location), or Downs (number of downs on the events). After sorting the array, we reload the table since the table is being generated using the event array.

# Location Services - Maxim
## Create Event
### Main screen
The create event screen displays a view to the user which will allow them to name their event, select a start and end time, provide a description, set a location, and set categories for their event. Time, location, and event name fields are auto-filled for the user when the view is loaded.

### Search location screen
Locations are quickly and conveniently set by pinning a location to a map. The map will center itself as the user moves as well.

## Map View - with contributions from Caleb
The map view tab on the home screen shows events as pins based on events that the users have filtered for. This pins include annotation views that will display event details when the pin is pressed on. Similarly to the search location screen, the map will center itself as the user moves

## Location services checks
In all screens where a location is used, checks and alerts were put into place to ensure maximum utilization of location services. Users are prompted to enable location services for the app on every screen that uses location if the app does not have the authorization to use location services. Said prompt has the option to take users directly into their settings app.

## Location searching
Every instance where an address or location name is displayed utilizes `CLGeocoder().reverseGeocodeLocation()` to search a location from a `CLLocation` based on an events latitude and longitude. The placemark that is returned from the function call is used to extract the name/address of the selected location.

# Backend - Jonathan

## Firestore
The backend makes use of Firestore’s NoSQL database. The event data is stored in the collection, `events`, and each of its document contains a unique auto-id. These documents represent events and contain information related to the event such as number of downs, time, location, user ID, user’s display name, event title, event description, and categories. 
The collection `user_events` contains information associating users and the events that they created and responded to. Each document in this collection is indexed by the user’s uniquely generated ID. Inside of each document are subcollections containing the auto-ids from the `event_table`: `created` (the user’s created events), `down` (the events that the user responded down), and `not_down` (the events that the user responded not down).

## ApiEvent
To easily interface with the backend, the class `ApiEvent` contains a static reference to the database and static methods to access user events. The static methods in this class modify the collections `event` and `user_events`. The method `getViewedEvents` fetches an array of `down` and `not_down` events that are still going on (i.e. the current time has not exceeded the end time of the event). To get the events in the main feed, the method `getUnviewedEvents` calls `getViewedEvents` to obtain an array of the user’s viewed events. The method then looks in the `events` collection for events that are still going on and are not contained in the array returned from `getViewedEvents`. The class additionally contains embedded descriptions for other developers to easily interface with the database.

## Synchronization
Because we call asynchronous functions to get the events from the backend, these functions need to be synchronized in certain scenarios. When the table views reload their data, they may reload before the closures finish. In addition, the closures may finish before the events are returned. Using dispatch groups is necessary to make sure that the closures finish in sync before critical methods run.

