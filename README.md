####Meetup Events pulling from your device’s location. 
If location in simulator is **not set up**, the default location is New York. 
The api key in this repo is **free** to use.
<img src = "https://github.com/guangLess/pullMeetupNearYourDevice/blob/master/screenShot/screenShot_1.png" width = "200”>—
<img src = "https://github.com/guangLess/pullMeetupNearYourDevice/blob/master/screenShot/screenShot_2.png" width = "200”>—
<img src = "https://github.com/guangLess/pullMeetupNearYourDevice/blob/master/screenShot/guang-appwalkthrough-ny2.gif" width = "200">

**Summery** : The app requests device location, then uses the location coordinates to request Meetup's open api /2/open_events with the user’s latitude/longitude. It displays 10 events ordered by distance to the user on a table view, and shows the relevant city name at the top of the screen. Tapping into each event shows the details of the event along with a favorite button than can be toggled (and remembers changes).

——-Networking——
struct **Event** is a model structured around the specs required for this code test (event/ group names, rsvp, who, time, etc). Event’s optional init method is used to help parse JSON data results in the networking call. 

struct **Resource** is an abstract structure with a variable url, and a closure variable that takes NSData, then uses NSJSONSerialization to return a generic type. Since Event is the data type that is being conformed later, it is better to keep each modular independent (which I learned from objc.io). 

class **MeetupService** handles networking requests with NSURLSession, function load captures the data returned from Meetup service, and struct Resource parses this returned data and captures it as an array of type Event.

——-Location—-
struct **DeviceLocation** is a location related model with variables of lat, long, and cityName for data. However, city name is a result from reverseGeocodeLocation, his method takes time. Its return String cityName was not actually used as I designed to. The city name is copied from Meetup api ca

struct DeviceLocation is a location related model containing variables of lat, long, and cityName. I wrote a method to convert the lat/long to a city name using reverseGeocodeLocation, but realized the threading time was unexpectedly slower to return a result. This is an area I would improve, but for the short time of the code test, I decided to take the city name of the venue from the closest Event for a quick fix.

class **Location** conforms to **CLLocationmanagerDelegate**. It requests device’s location while using the app. Request stops after the location is found.

—-Protocols——-
**canGetLocation** protocol handles location request. LoadingAPI protocol handles Meetup api calls.

**ViewController** adapts canGetLocation and LoadingAPI protocols. EventViewController shows the detail of the event. 

**eventList** Array is a global variable that stores the events. It’s not the best practice for a real app, however I needed it to be global in order to save the favorite states from EventViewController.



