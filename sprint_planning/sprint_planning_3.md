# November 8, 2019 Sprint Planning #

# Summary # 
Down? is an app that allows users to put up small-scale events that will happen within the day. The idea is to let users use Down? as a way to spontaneously meetup and do something together rather than carefully planning when and what is going on like facebook. Users can post events that they are going to be doing (ex. Studying for ECS 189, Playing Video Games: need a player 2!, Getting Raja's: Anyone else down?) and other users will see the events and mark that they are down to join.

# Links #

## Trello Board Link ##
https://trello.com/b/GnoBa4dZ/down

## Google Doc of Features we want to add (and who is assigned to them) ##
https://docs.google.com/document/d/1u9fCno2mnBhMV4XySzwLCMdz7slrgkXB8fR7AhyXl54/edit?usp=sharing


# Main Meeting #
## What we did ##
The priority for this sprint is allowing events to show on the app's home view. This required a backend
architecture and code to easily interface the backend. We are polishing the home view to start showing dummy
information about the events, and there is a bar on the top for filtering events. The event creation screen
is receiving a revamp where the date time picker bugs are fixed and categories are included for the user to select.


James: 
* Started working on the creation of filter button view
* Added a table collection view with buttons of specifications to filter the events
https://github.com/ECS189E/project-f19-down/tree/Login-View


Jonathan: 
* Started working on app connection to backend
* Designed the backend schema
* Made methods to easily add events and post them to database
* Created event structure to represent user event data from database
https://github.com/ECS189E/project-f19-down/tree/api-event/sprint_planning

Caleb:
* Worded on event tiles layout (for hours on end)
* Started designing event details popup

Maxim:
* Redesigned the create event screen
* Added category selector for create event screen
* Preliminary autofill for start time, end time, and current location


## What we plan to do ##
We are trying to have the event functionality implemented before the next milestone. 
We will also need to test the flow with the updated view controllers.

## Any Issues ##
* Unoptimal backend design
* Merge conflicts
