## Build tools & versions used
IDE: Xcode 14
Language, frameworks: UIKit, Swift

## Steps to run the app
1. Download&Install Xcode
2. Open `SquareEmployeeDirectory.xcodeproj` file from root folder
3. Press Command+R or Play button in the top right part of the Xcode UI

## What areas of the app did you focus on?
My main focus here

## What was the reason for your focus? What problems were you trying to solve?


## How long did you spend on this project?
~10 hours

## Did you make any trade-offs for this project? What would you have done differently with more time?
1. I made employee type a defined enum. This means that if a new employee type will be added app will return an error during parsing.
2. Which UI limited to 1 screen the best I idea I had to show that app can handle 3 of the list type(malformed list, empty and normal) is to add a separate button for each of them. Pull to refresh always fetches normal list. With more time dedicated to this, I'd like to explore more UI options to communicate this functionality to user, ideally maybe even remove all 3 buttons and just fetch normal list by default.
3. Currently `ImagePersistanceService` is doing 2 things, works with images and file system. With more time I could've refactored work with file system and have dedicated directory for saving images, instead of saving them directly in documents directory.
4. Loading UX. Currently when data is loading, I change navigation bar title at the top to "Loading..." to indicate that, I chose this because it is similar to Telegram app, but it may not be clear to user as it is not attracting user attention, but it also does prevent use from interacting with the app further
 

## What do you think is the weakest part of your project?
1. Like mentioned above, saving images can be done better
2. I'd also say that Unit Test can be improved more
3. Toolbar UX. Right now it is more dev focused, and without reading [project spec](https://square.github.io/microsite/mobile-interview-project/) it may be unclear to use what `Malformed List`, `Empty List` and `Normal List` buttons for.

## Did you copy any code or dependencies? Please make sure to attribute them here!
Not entire code, but I did look into code for my own project to quickly implement `ImageFetchingService`
I also looked at how Apple approaches fetching images asynchronously in their projects. [Here is the doc](https://developer.apple.com/documentation/uikit/views_and_controls/collection_views/updating_collection_views_using_diffable_data_sources) 
As I've never worked with context menus before I looked at [apple doc](https://developer.apple.com/documentation/uikit/uicontrol/adding_context_menus_in_your_app)

## Is there any other information you’d like us to know?
