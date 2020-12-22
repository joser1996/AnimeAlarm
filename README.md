# AnimeAlarm
AnimeAlarm is a IOS application that allows you to view the current season of airing Anime.
Aside from title other information, if available, is also shown such as..

* Current Episode / Total Episode
* Airing Time of next episode
* Synopsis
* Thumbnail

Aside from viewing this data the user is able to create reminders at any user given time.

## ToDO
  * Create Alarm Functionality
  * Local Notifications
  * UI Tweaks

# How It Works
Upon launching the application fetches data using the [Anilist API](https://anilist.gitbook.io/anilist-apiv2-docs/).
Once data is recieved data is displayed using a collection view with custom cells. Cells display thumbnail, title, and
a truncated synopsis. Selecting a row causes a more detailed view to appear that shows the full synopsis and will include
a button that allows you to create a alarm.

The application will use local notifications in order to notify the user.
**Insert GIF**


## Requirements
Currently only have a IOS applicaiton so **XCode** and **IPhone** will be necessary.

Must be connected to a network in order to fetch data.
Images are cached in memory so numbers of requests to API is reduced

# Install
Once project has been downloaded open in XCode and build and run on your device.
