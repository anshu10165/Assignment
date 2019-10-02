# Assignment: Flickr Image Search
 An application dealing with image search for any random input provided.
 * Supported version: iOS 11, 12, 13.
 * Xcode: 11.0
 
 ## Usage:
 ```
 Run the Application.
 Search form shows up, with button Disabled at first and focus on text field, as you type in the text, button enables up.
 
 Two ways to get the search done:
 Type in the Text and hit Enter or press the search button.
 The title shows Image Search and can change based on whether API sends photos or not.
 The images will be shown in a three column grid vie.
 Once the images have loaded, scroll down the screen, there will be more loading and so on as you keep scrolling.
 
 ```
  ## Architecture/Design:
  
  * This project uses ```MVVM and Protocol Oriented Programming``` as a whole. 
  * The parent controller(```ImageSearchController```) has its associated viewModel(```ImageSearchViewModel```). 
  * The ImageCell displaying image has again its associated viewModel(```ImageCellViewModel```) which contains the url of image to display.
  * Project contains separated ```Services``` group to take care of the networking part.
  * Unit-Tests coverage has been added for ViewModels conatining business logic, ViewControllers and Network Layer.

  ![Screenshot](https://github.com/anshu10165/Images/blob/master/Screenshot%202019-10-02%20at%2012.24.18%20PM.png)
  
  ## OUTPUT
  ![Screenshot](https://github.com/anshu10165/Images/blob/master/Screenshot%202019-10-02%20at%2012.31.46%20PM.png)
  
  ## VALIDATIONS
  
  * User hitting ```Enter``` button without inputting text higlights the TextField in Red prompting user to input. 
  ```(For a Production ready, can be made better by adding some message asking user to input.)```
  
  ![Screenshot](https://github.com/anshu10165/Images/blob/master/Screenshot%202019-10-02%20at%2012.33.21%20PM.png)
  
  * For some random inputs, which doesn't yield in photos from API, for time being this updated the ```navigation title``` 
  with message No Results Found.
  
  ```For a Production ready, can be made better by displaying better error message on screen with some animation to make it more engaging )```
  
  ![Screenshot](https://github.com/anshu10165/Images/blob/master/Screenshot%202019-10-02%20at%2012.33.33%20PM.png)
  
  ## NOTES:
  In case the cursor is stuck on the textfield and user is not able to type, Please kill the simulator and restart, this is a bug that rarely
  happens on iOS 13 sim as decribed and discussed here:
  
  https://forums.developer.apple.com/thread/122972
  https://stackoverflow.com/questions/56526966/xcode-11-beta-ios-13-simulator-uitextfield-with-placeholder-getting-app-cras	
  
  
