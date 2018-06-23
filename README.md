# TTP Spotify Calendar

Another year, another TTP project for the Spotify Apprenticeship!

## Run

Open `~/CalendarFrontEnd/CalendarFrontEnd.xcodeproj` with Xcode and run the project.

## Bonus Features

* Switch between months and years
* Fits multiple events per box on a given day.
* Can update/delete events by tapping on an existing event.
* Shows correct days.

## Screens

Main View | Landscape with preview text
--- | ---
![Main Screen](images/main.png) | ![Main Screen Flipped](images/mainflipped.png)

Date View with Delete | All Events with Delete | Create / Edit Screen
--- | --- | ---
![Date Screen](images/date.png) | ![All Events](images/allevents.png) | ![Create Screen](images/addeditscreen.png)

## Front End

Made with Swift 4 with no imported libraries for less dependencies, using a combination of MVC and MVVM architecture (for reusability and easier unit testing). 

## Back End

Made with Heroku using Angular CLI, Node and MongoDB. Deployed at [https://desolate-cliffs-10757.herokuapp.com/events/](https://desolate-cliffs-10757.herokuapp.com/events/)

P.S. Left out 300 mb of Node, e2e, and misc files to save space so cloning this project isn't a nightmare. 