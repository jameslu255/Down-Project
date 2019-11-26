# November 18, 2019 Sprint Planning #

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
* Finished search button scaling
* Continue implementing Sorting and Filtering functionality
https://github.com/ECS189E/project-f19-down/tree/Filter-Buttons
https://github.com/ECS189E/project-f19-down/tree/Filter-Buttons-V2


Jonathan: 
* Added API calls
* Added API documentation
* Wrote backend documentation
* Created data storage for down, not down, and created events

Caleb:
* Refactored feed table and event cells
* Added downNotDown List View controller
* Made custom tab bar view controller
* Hooked up tables to API
https://github.com/ECS189E/project-f19-down/tree/HomeFeed

Maxim:
* Added map and pin dropping feature for selecting event location
* Added location manager and management
https://github.com/ECS189E/project-f19-down/tree/create-event


## What we plan to do ##
* Implement profile controller.
* Implement API calls for sorted events.
* Finish filter/sorting functionality.
* Finish Auto fill in event creation.

## Any Issues ##
* We have to cut a lot of functionality due to time constraints.
