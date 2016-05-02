# Thermo

The Thermo iOS app is presently written in Obj-C and should be used with Xcode 7.3. Weekend project that acts as a simple Thermometer/Weather App.


## Tools used

Here is list of tools used in this project

- [Shimmer](https://github.com/facebook/Shimmer) for simple shimmer animation effect.

- [TSMessages](https://github.com/KrauseFx/TSMessages/) provides an easy way to show little notification views on the top of the screen (à la Tweetbot).

- [AFNetworking](https://github.com/AFNetworking/AFNetworking) is a delightful networking library for iOS and Mac OS X.

- [OpenWeatherMap.org](http://openweathermap.org/) is an online service that provides a free API for weather data, including current weather data, forecasts, and historical data to the developers of web services and mobile applications.


## Dependency Management
This project uses [CocoaPods](http://cocoapods.org) to manage dependencies, so you should open the `.xcworkspace` file rather than the `.xcodeproj` file. Note that the `Pods` directory should be checked in to version control so it’s possible to build immediately after checking out from the repository. 

Some of the Tools use Swift, that’s why the `use_frameworks!` feature of CocoaPods is included - one thing to note is that this will likely cause problems with any pod which uses a vendor library - i.e., a compiled `.a` file - instead of just compiling code. 

## To Do

- Unit Tests

- Improve Documentation

- Add FBShimmeringView to the other labels (animation messes up the gradient view)