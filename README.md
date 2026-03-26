# GithubCopilotLearning
[![Platform][iOS-badge]][apple-developer]
[![Swift 5.0][swift-badge]][swift-org]
[![Target][minimum-platform-badge]][iOS-version-wiki]
[![CocoaPods][cocoa-badge]][cocoa-org]
Add some project description here.
## Getting Started
These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.
### Prerequisites
Add project prerequisites here and remove this line. Below are the example, may or may not apply to your project
- [Xcode 15.0+][xcode-releases]
- [HomeBrew][brew]
- [CocoaPods][cocoa-org]
- [Arkana][arkana]
### Dependencies
Third-party frameworks and libraries are managed using [Cocoapods][cocoa-org] and [SPM][spm].
#### SPM packages used
- [NetworkEngine][network-engine]: Network engine is the networking XCFramework on top of [Alamofire][alamofire], for simplified and testable network management.
- [swift-log][swift-log]: A Logging API for Swift.
#### Pods used 
- [R.swift][rswift]: This library is to manage static strings in the application
- [Kingfisher][kingfisher]: Used for download images
- [Bagel]: Network debugging tool for IOS
- [Sentry]: Error tracking and performance monitoring tool
- [SSAppUpdater]: To get the essential app details from app URL
- [Navajo-Swift]: Password Validator & Strength Evaluator
- [SwiftMessages]: Presentation library use to show snackbar
- [PhoneNumberKit]: For parsing, formatting and validating international phone numbers.
- [SFSafeSymbols]: Safely access Apple's SF Symbols using static typing
- [SwiftDate]: Parse, validate, compare dates
- [Connectivity]: To check internet connectivity
- [Arkana]: To store secrets away from SourceCode
### Swift Style Guide
Code follows [Raywenderlich][style-guide] style guide.
Project uses [SwiftLint][swift-lint] to enforce Swift style and conventions before sending a pull request.
## How to setup project?
1. Clone this repository into a location of your choosing, like your projects folder
2. Add the .env file with the API keys and project secrets where arkana.yml exists. (The .env should have all the keys for every environment mentioned in arkana.yml)
4. Open terminal - > Navigate to the directory containing `arkana.yml`, run arkana by typing in terminal: `arkana`
5. Then install pods into your project by typing in terminal: `pod install`
5. You are all set now. Open the .xcworkspace file from now on and hit Xcode's 'run' button. 🚀
### How to use? 
  -  UAT : Set the active scheme as GithubCopilotLearning UAT to run the project in UAT environment.
  -  Staging : Set the active scheme as GithubCopilotLearning Staging to run the project in Staging environment.
 ## Architecture
The project uses MVVM architecture. [MVVM in iOS-SwiftUI][mvvm-ios-swiftui] projects
Describe other additional patterns here and remove this instruction line.
## Beta Testing
We are using [TestFlight][test-flight] to download the app for beta testing.
To test beta versions of apps using TestFlight, you'll need to receive an invitation email from the developer or get access to a public invitation link, and have a device that you can use to test.
**Internal testers** Members of the developer’s team in App Store Connect can participate as internal testers and will have access to all builds of the app.
**External testers** Anyone can participate as an external tester and will have access to builds that the developer makes available to them. A developer can invite you to test with an invitation email or a public invitation link. An Apple ID is not required. If you are part of the developer’s team in App Store Connect, you can be added as an external tester if you aren’t already an internal tester.
### **Installing a Beta iOS App from an Invitation Email or Public Link**
1. Install [TestFlight](https://testflight.apple.com/join/rLn3xRPy) on the iOS device that you'll use for testing.
2. Open your invitation email or tap on the public link on your iOS device.
3. Tap View in TestFlight or Start Testing; or tap Accept, Install, or Update for the app you want to test.
## Important credentials
**Sentry**: sentry account id
## Copyright
Copyright © {% now 'local', '%Y' %} {{cookiecutter.company_name}}. All rights reserved.
[//]: # (These are reference links used in the body of this note and get stripped out when the markdown processor does its job. There is no need to format nicely because it shouldn't be seen. Thanks SO - http://stackoverflow.com/questions/4823468/store-comments-in-markdown-syntax)
   [swift-badge]: <https://img.shields.io/badge/Swift-5.0-orange.svg?style=flat>
   [swift-org]: <https://swift.org>
   [cocoa-badge]: <https://img.shields.io/badge/dependency-cocoapods-red>
   [cocoa-org]: <https://cocoapods.org>
   [spm]: <https://www.swift.org/package-manager/>
   [swift-date]: <https://github.com/malcommac/SwiftDate>
   [swift-log]: <https://github.com/apple/swift-log>
   [iOS-badge]: <https://img.shields.io/badge/platform-iOS-blue>
   [apple-developer]: <https://developer.apple.com/ios/>
   [minimum-platform-badge]: <https://img.shields.io/badge/support-iOS%20{{cookiecutter.iOS_minimum_deployment_target}}-blue>
   [iOS-version-wiki]: <https://en.wikipedia.org/wiki/IOS_{{cookiecutter.iOS_minimum_deployment_target}}>
   [brew]: <https://brew.sh/>
   [xcode-releases]: <https://xcodereleases.com/>
   [style-guide]: <https://github.com/raywenderlich/swift-style-guide>
   [rswift]: <https://github.com/mac-cain13/R.swift>
   [network-engine]: <https://github.com/mobile-simformsolutions/NetworkEngineXC>
   [alamofire]: <https://github.com/Alamofire/Alamofire>
   [bagel]: <https://github.com/yagiz/Bagel>
   [reachability-swift]: <https://github.com/ashleymills/Reachability.swift>
   [iq-keyboard-manager-swift]: <https://github.com/hackiftekhar/IQKeyboardManager>
   [swift-messages]: <https://github.com/SwiftKickMobile/SwiftMessages>
   [kingfisher]: <https://github.com/onevcat/Kingfisher>
   [sentry]: <https://github.com/getsentry/sentry-cocoa>
   [ssspinner-button]: <https://github.com/simformsolutions/SSSpinnerButton>
   [swift-lint]: <https://github.com/realm/SwiftLint>
   [arkana]: <https://github.com/rogerluan/arkana>
   [mvvm-ios-swiftui]: <https://www.avanderlee.com/swiftui/mvvm-architectural-coding-pattern-to-structure-views/>
   [test-flight]: <https://developer.apple.com/testflight/>
   [adaptive-layout]: <https://rodionartyukhin.medium.com/adaptive-layout-for-ios-in-swift-20842307116f>
   [ssappupdater]: <https://github.com/SimformSolutionsPvtLtd/SSAppUpdater>
   [swiftlint]: <https://github.com/realm/SwiftLint>