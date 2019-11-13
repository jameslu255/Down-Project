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
We decided to split our work to specific view controllers. James got Login/setup views, Jonathan will figure out how to uses Firebase and work with James to set it up, Caleb works on Homescreen, Maxim worked on event creation screen. We plan on working on our own individual branches and merging them together when we meet up.

James: 
Finished first load screen, login view, login screens and signup screens. 
Setup the layout of the app. 
Worked with Jonathan to setup Firebase to work with login/signup.
https://github.com/ECS189E/project-f19-down/tree/Login-View


Jonathan: 
Studied how to use Firebase.
Worked with James to add Firebase functionality to login/signup.
https://github.com/ECS189E/project-f19-down/tree/API-Login-View
https://github.com/ECS189E/project-f19-down/tree/Nov-09-API

Caleb:
Created the homescreen of the app.
Added button view controller that can be accessed on the home screen.

Maxim:
Created the event creation view.
Began to add map functionality to events.
https://github.com/ECS189E/project-f19-down/tree/create-event


## What we plan to do ##
We plan on meeting up to merge all of our branches so that we have all the minimum features for the app to work by Thursday for our Milestone 1.

The plan is to have, Login/Signup, Homescreen, and Event creation already finished so that a user can begin creating events. We will work on allowing other users to see the events and respond to them later.

## Any Issues ##
Some problems that we might need to address: How will we get other users to see events created by other users? How do we keep track of the events that should expire and should be removed from the table? How will keep track of the location of the events so that the closest ones will be displayed to the user?
