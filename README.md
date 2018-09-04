JonAlert
===========
[![CocoaPods Compatible](https://img.shields.io/badge/pod-1.0.0-red.svg)](https://cocoapods.org/pods/JonAlert)

A simple and elegant alert like Spotify's one, written in Swift. JonAlert can be used to give feedbacks to the user after he/she performed some action.

![BackgroundImage](https://raw.githubusercontent.com/jonSurrey/JonAlert/master/alert_single_message.png)
![BackgroundImage](https://raw.githubusercontent.com/jonSurrey/JonAlert/master/alert_success.png)
![BackgroundImage](https://raw.githubusercontent.com/jonSurrey/JonAlert/master/alert_error.png)

Easy to use
----

### How to use

```swift
// First import the library to the ViewController you want to use it.
import JonAlert

// Then, you just have to call the alert anywhere you desire:
JonAlert.show(message: "Simple message...")
```

### Success and Error Alerts

```swift
// If you want to show feedback for a success or error situation, 
// you can simply call:
JonAlert.showSuccess(message: "Success!!")
JonAlert.showError(message: "Something went wrong...")
```

### Display a custom icon

```swift
// Last but not least, you can use a custom image to be displayed:
let myImage = UIImage(named: "myImage")
JonAlert.show(message: "Simple message...", andIcon: myImage)
```

### Changing the alert displaying speed

```swift
// The alert default displaying speed is 1 second. So, when you
// call any of the "show" methods the time between the alert 
// appearing and disappearing will be of 1 second. 

// To change de default time (in seconds) of the alert, use: 
JonAlert.show(message: "", duration: 5.0)
```

Installation
---

JonAlert is not available through Cocoapods yet, but will be soon. 

### Manual installation

First download the "JonAlert" folder. Then, in Xcode, right-click on the root of your project node in the project navigator. Click "Add Files" to “YOURPROJECTNAME”. In the file chooser, navigate to where "Jon Alert" folder is and select JonAlert.xcodeproj. Click "Add" to add JonAlert.xcodeproj as a sub-project.

Select the top level of your project node to open the project editor. Click the YOUR_PROJECT_NAME target, and then go to the General tab.

Scroll down to the Embedded Binaries section. Drag JonAlert.framework from the Products folder of JonAlert.xcodeproj onto this section.

You should be good to go now!

Collaboration
---

This is a simple libray that I created to help myself in my own work since I didnt find any other that would do what I wanted. I know that there is still here a lot of space for improvements and adding new features, so please, any ideas or issues, feel free to collaborate!

## Author

Jonathan Martins, jon.martinsu@gmail.com

## License

JonAlert is available under the MIT license. See the LICENSE file for more info.
