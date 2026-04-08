# BoomerangFX Development Guidelines

This document outlines the coding standards, best practices, and development guidelines for the BoomerangFX iOS application.

---

## Project Architecture

BoomerangFX follows a strict MVVM (Model-View-ViewModel) architecture with a clear separation of concerns:

### Data Flow Pattern
1. **Data Flow Pattern**: Model → ViewModel → Controller → View
   - API calls are made from ViewModels, never directly from Controllers
   - Controllers observe ViewModels for state changes using delegates
   - UI updates only happen in Controllers/Views, never in ViewModels

### Key Components
2. **Key Components**:
   - **APIRequestServices**: Central service class that orchestrates all API calls
   - **NetworkService**: Low-level networking using Alamofire
   - **Delegates**: Primary communication pattern between components
   - **UserSingleton**: Manages authenticated user state

### Navigation Flow
3. **Navigation Flow**:
   - `AppDelegate` manages the app's initial routing based on authentication state
   - Screen transitions are handled using UINavigationController, leveraging push and pop operations for navigation.
   - Don't create new instances of view controllers that should be part of the navigation flow
   
   ```swift
       // Bad example:
       @IBAction func onBackButtonTapped(_ sender: UIButton) {
           // Creating a new instance instead of popping back
           let appointmentsVC = AppointmentsViewController()
           navigationController?.setViewControllers([appointmentsVC], animated: true)
       }
       
       // Good example:
       @IBAction func onBackButtonTapped(_ sender: UIButton) {
           // Simply pop back to the previous view controller
           navigationController?.popViewController(animated: true)
       }
   ```
   
   - Don't reset the entire navigation stack for simple navigation
   ```swift
       // Bad example:
       func goToHomeScreen() {
           // Completely replacing the navigation stack instead of popping
           let homeVC = HomeViewController()
           let navController = UINavigationController(rootViewController: homeVC)
           UIApplication.shared.windows.first?.rootViewController = navController
       }
       
       // Good example:
       func goToHomeScreen() {
           // Pop to root view controller if you want to return to the home screen
           navigationController?.popToRootViewController(animated: true)
           
           // Or if you need to pop to a specific view controller in the stack:
           if let homeVC = navigationController?.viewControllers.first(where: { $0 is HomeViewController }) {
               navigationController?.popToViewController(homeVC, animated: true)
           }
       }
   ```
   
4. **Avoid Hardcoding Colours and Images**
- If hardcoding is necessary, define them within a dedicated struct or enum inside the respective class. Use these constants wherever required to ensure consistency and maintainability.

   ```swift
   // DO load views from XIBs when appropriate:
    enum AppColors {
        static let primary = "PrimaryColor"
        static let secondary = "SecondaryColor"
    }

    enum AppImages {
        static let logo = "AppLogo"
        static let placeholder = Placeholder"
    }
    
    // Usage
    let primaryColor = UIColor(named: AppColors.primary)
    let logoImage = UIImage(named: AppImages.logo)
   ```

---

## Key Workflows

### Connectivity Handling
1. **Connectivity Handling**:
   - Use `Connectivity.verifyInternetConnection()` before making API calls
   - App has built-in handling for session expiry and internet disconnection

### Data Binding Pattern
2. **Data Binding Pattern**:
   - Use protocol delegate pattern for communication between ViewModel and Controller
   - Controllers implement delegate methods to receive updates from ViewModels
   - If we create any service class use also protocol delegate pattern for communication
   - For API calls, use protocol delegates instead of closures to handle success and failure in ViewControllers

   ```swift
   // DON'T use closures for API callbacks:
   class IncorrectViewModel {
       func fetchUserData(userId: String, completion: @escaping (Result<User, Error>) -> Void) {
           APIRequestServices().getUserProfile(userId: userId) { result in
               if let userData = result.data as? UserResponseModel {
                   completion(.success(userData))
               } else if let error = result.error {
                   completion(.failure(error))
               }
           }
       }
   }
   
   class IncorrectViewController: UIViewController {
       private let viewModel = IncorrectViewModel()
       
       override func viewDidLoad() {
           super.viewDidLoad()
           loadUserData()
       }
       
       private func loadUserData() {
           viewModel.fetchUserData(userId: "12345") { [weak self] result in
               switch result {
               case .success(let user):
                   self?.updateUI(with: user)
               case .failure(let error):
                   self?.showError(error)
               }
           }
       }
   }
   
   // DO use protocol delegates for API callbacks:
   protocol UserDataDelegate: AnyObject {
       func didFetchUserData(_ user: User)
       func didFailToFetchUserData(_ error: Error)
   }
   
   class CorrectViewModel {
       weak var delegate: UserDataDelegate?
       
       func fetchUserData(userId: String) {
           APIRequestServices().getUserProfile(userId: userId) { result in
               if let userData = result.data as? UserResponseModel {
                   self.delegate?.didFetchUserData(userData)
               } else if let error = result.error {
                   self.delegate?.didFailToFetchUserData(error)
               }
           }
       }
   }
   
   class CorrectViewController: UIViewController, UserDataDelegate {
       private let viewModel = CorrectViewModel()
       
       override func viewDidLoad() {
           super.viewDidLoad()
           viewModel.delegate = self
           viewModel.fetchUserData(userId: "12345")
       }
       
       // MARK: - UserDataDelegate
       func didFetchUserData(_ user: User) {
           updateUI(with: user)
       }
       
       func didFailToFetchUserData(_ error: Error) {
           showError(error)
       }
   }
   ```

---

## Project Structure

The BoomerangFX project follows a modular MVVM architecture with clear separation of concerns:

- **Model**: Data models and business logic (/BoomerangFX/Model/)
  - Includes request/response models for API communication
  - Models for business entities like Packages, Memberships, etc.
  
- **View**: UI components and storyboards (/BoomerangFX/View/)
  - Custom UI components, table/collection view cells
  - XIB files for reusable views
  
- **ViewModel**: ViewModels for MVVM pattern (/BoomerangFX/ViewModel/)
  - Business logic layer between Models and Controllers
  - Network request handlers and data processing
  
- **Controller**: UIViewControllers (/BoomerangFX/Controller/)
  - Screen controllers organized by feature
  - UI logic and event handling
  
- **Extensions**: Swift extensions for added functionality (/BoomerangFX/Extensions/)
  - Extensions to UIKit and Foundation classes
  
- **Utilities**: Helper classes and utility functions (/BoomerangFX/Utilities/)
  - Common utilities like Connectivity checker
  - Helper classes for common tasks
  
- **Tools**: Core functionality like networking, analytics, etc. (/BoomerangFX/Tools/)
  - NetworkService and APIRequestServices for API communication
  - Analytics integration
  
- **Resources**: Assets, fonts, and other resources (/BoomerangFX/Resources/)
  - Images, color assets, fonts
  - JSON files and other static resources
  
- **Constant**: Application constants and configuration (/BoomerangFX/Constant/)
  - API endpoints, app keys, and configuration values
  - Static strings and constants

---

## Coding Standards

### Networking Guidelines
1. **Always use Alamofire for networking**: Do not use URLSession directly. Alamofire provides a cleaner API, better error handling, and more consistent request/response processing.
   ```swift
   // DON'T use URLSession:
   URLSession.shared.dataTask(with: url) { data, response, error in
       // Handle response, errors, parse data
       guard let data = data, error == nil else {
           print("Network error: \(error?.localizedDescription ?? "Unknown error")")
           return
       }
       // Parse data manually...
   }.resume()
   
   // DO use Alamofire with NetworkService:
   NetworkService().performGetRequest(
       url: API.GET_APPOINTMENTS+"?\(ParameterKey.patientId)=\(patientId)",
       requestMethod: .get,
       responseType: AppointmentsResponseModel.self) { result in
           if let responseData = result.data as? AppointmentsResponseModel {
               // Handle successful response
           } else {
               // Handle error
           }
       }
   ```

2. Use the `NetworkService` class for all API requests - this ensures consistent handling of authentication, error management, and logging.

   ```swift
   // DON'T make direct Alamofire calls:
   AF.request(url).responseDecodable(of: ResponseType.self) { response in
       // Handle response
   }
   
   // DO use the NetworkService layer in APIRequestServices.swift:
   func getUserPackageList<Resource: ApiResource<Any>>(request: PatientpackagesRequestModel, completion: @escaping(Resource) -> Void) {
       NetworkService().performGetRequest(
           url: API.UserPackageList+"\(request.patientId)", 
           requestMethod: .get, 
           responseType: [PatientpackagesResponseModel].self, 
           completion: completion
       )
   }
   ```

3. All API endpoints should be centralized in a single location, defined using enums or structs. In the AppKey file, declare them as static let constants.

   ```swift
   // DO define API endpoints in AppKey.swift:
   static let GET_APPOINTMENTS = "\(BASE_ORIGIN)pms/api/PatientAppAppointment/GetPatientAppointments"
   static let GET_PATIENT_MEMBERSHIP = "\(BASE_ORIGIN)patientapp/api/PatientMembership/GetPatientMembership/"
   
   // DON'T hardcode API URLs in individual files:
   let appointmentsUrl = "https://bfxnonprod-cu.boomerangfxalpha.com/dev-pms/pms/api/PatientAppAppointment/GetPatientAppointments"
   ```

### Code Organization
4. **Code Organization Guidelines:**
 - Use extensions to organize your code into logical blocks of functionality.
 - Each extension should be preceded by a // MARK: - comment to keep the code well-organized and easy to navigate.

   ```swift
   // DO organize code with MARK comments and extensions:
   class HomeViewController: UIViewController {
       // Core properties and outlets
       @IBOutlet weak var tableView: UITableView!
       private var viewModel = HomeViewModel()
   }
   
   // MARK: - Overridden Methods
   extension {
       override func viewDidLoad() {
           super.viewDidLoad()
           setupUI()
           bindViewModel()
       }
   }
   
   // MARK: - Private Methods
   extension HomeViewController {
        private func setupUI() {
           tableView.delegate = self
           tableView.dataSource = self
        }
       
        private func bindViewModel() {
           viewModel.dataUpdated = { [weak self] in
               self?.tableView.reloadData()
           }
        }
   }

   // MARK: - UITableViewDelegate, UITableViewDataSource
   extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return viewModel.items.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           // Cell configuration
       }
   }
   ```


### Code Quality

5. **Eliminate Dead or Redundant Code**: Removing unused or redundant code keeps your codebase clean, easier to maintain, and more professional. Eliminate anything that does not contribute to the current functionality of your app. ✅ What to Remove:

 - Unused variables, functions, or classes that are no longer referenced.
 - Commented-out code that is not relevant or planned for immediate use.
 - Boilerplate or template methods that serve no functional purpose e.g., sceneDidDisconnect(_:), unused UITableViewDataSource methods.
 - Methods that only call super without adding meaningful behavior.
 - Unnecessary imports that are not used in the file (e.g., importing UIKit in a pure SwiftUI file).

   ```swift
   // DON'T keep commented out code or unused methods:
   func viewDidLoad() {
       super.viewDidLoad()
       setupTable()
       // Old implementation - to be deleted
       // self.fetchDataLegacy()
       // self.configureLegacyUI()
   }
   
   // func fetchDataLegacy() {
   //     // Old code we're not using anymore
   // }
   
   // DO clean up your code by removing unused methods:
   func viewDidLoad() {
       super.viewDidLoad()
       setupTable()
   }
   ```

### Code Structure

6. **Prefer guard Statements for Early Exit**

 - Use guard statements to handle conditions that would cause a function to exit early. This approach improves readability and reduces nesting, making your code cleaner and easier to follow.
 
   ```swift
   // DON'T use nested if statements:
   func processUser(userId: String?) {
       if let userId = userId {
           if let user = fetchUser(userId: userId) {
               if user.isActive {
                   // Process the user
               } else {
                   showError("User is not active")
                   return
               }
           } else {
               showError("User not found")
               return
           }
       } else {
           showError("User ID is missing")
           return
       }
   }
   
   // DO use guard statements for early exits:
   func processUser(userId: String?) {
       guard let userId = userId else {
           showError("User ID is missing")
           return
       }
       
       guard let user = fetchUser(userId: userId) else {
           showError("User not found")
           return
       }
       
       guard user.isActive else {
           showError("User is not active")
           return
       }
       
       // Process the user
   }
   ```

### Naming and Typing

7. **Consistent Naming Conventions**: Follow Swift's naming conventions for variables, functions, and types. Use camelCase for variables and functions, and PascalCase for types.

   ```swift
   // DON'T use inconsistent naming:
   class userdata {
       var User_name: String?
       var EMAIL_ADDRESS: String?
       
       func GetUserInfo() {
           // ...
       }
   }
   
   // DO follow Swift naming conventions:
   class UserData {
       var userName: String?
       var emailAddress: String?
       
       func getUserInfo() {
           // ...
       }
   }
   ```

### Safety and Type Handling

8. **Safe Optional Handling:**
 - Always unwrap optionals safely using guard let or if let statements. Avoid force unwrapping (!) and force casting (as!) unless absolutely certain, as they can cause runtime crashes.

   ```swift
   // DON'T force unwrap optionals:
   func displayUsername(user: User?) {
       let username = user!.username // Will crash if user is nil
       nameLabel.text = username
   }
   
   // DO safely unwrap optionals:
   func displayUsername(user: User?) {
       guard let user = user else {
           nameLabel.text = "Guest"
           return
       }
       
       nameLabel.text = user.username
   }
   ```

9. **Prefer Value Types:**
 - Use structs instead of classes when possible. Value types provide safer memory management, better immutability, and reduce unintended side effects compared to reference types.

   ```swift
   // DO prefer value types for simple data models:
   struct AppointmentDetails {
       let id: String
       let date: Date
       let doctorName: String
       let procedureName: String
       let status: AppointmentStatus
   }
   
   // DON'T use classes when structs would be more appropriate:
   class AppointmentDetails {
       var id: String
       var date: Date
       var doctorName: String
       var procedureName: String
       var status: AppointmentStatus
       
       init(id: String, date: Date, doctorName: String, procedureName: String, status: AppointmentStatus) {
           self.id = id
           self.date = date
           self.doctorName = doctorName
           self.procedureName = procedureName
           self.status = status
       }
   }
   ```

### UI Development

10. **Storyboards and XIBs:**
 - Use Storyboards and XIB files for UI development where appropriate to ensure consistency, reusability, and easier collaboration within the team.

11. **Size Classes**
- Use Size Classes with Storyboards and XIBs to create adaptive UI layouts that work seamlessly across devices, orientations, and screen sizes. Follow these rules for typography and layout:

  - Base font sizes and constraints should be defined for compact classes (e.g., iPhone).
  - For iPad Regular × Regular size class, increase the base font size by at least 4 points for better readability.
  - Ensure consistency in scaling across all text styles to maintain a clean and accessible design.

## UI Guidelines

### Threading and UI Updates
1. Implement UI updates on the main thread.
   ```swift
   // DON'T update UI directly from background threads:
   DispatchQueue.global().async {
       let image = self.processImage()
       self.imageView.image = image // Crash: UI updates must be on main thread
   }
   
   // DO dispatch UI updates to the main thread:
   DispatchQueue.global().async {
       let image = self.processImage()
       DispatchQueue.main.async {
           self.imageView.image = image
       }
   }
   ```

### Design Principles
2. Follow Apple's Human Interface Guidelines.
   - Use native iOS UI patterns and interactions where possible
   - Maintain consistent spacing, padding, and alignment
   - Follow platform conventions for navigation and gestures

## Documentation

### Code Documentation
1. Use documentation comments for all methods and classes.
   ```swift
      /**
         Processes the user's payment with the given payment information.
         
         - Parameters:
           - amount: The payment amount.
           - currency: The currency code (default: "USD").
           - description: A description of the payment.
         
         - Returns: 
           A Boolean indicating whether the payment was successful.
     */
   ```

## Performance Considerations

### Image Handling
1. Optimize image loading and caching using Kingfisher.
   ```swift
   // DO set resource options for better performance
   let processor = DownsamplingImageProcessor(size: imageView.bounds.size)
   imageView.kf.setImage(
       with: URL(string: imageUrlString),
       options: [
           .processor(processor),
           .scaleFactor(UIScreen.main.scale),
           .cacheOriginalImage
       ]
   )
   ```

### Thread Management
2. Minimise main thread blocking operations.
   ```swift
   // DON'T perform heavy operations on the main thread
   func viewDidLoad() {
       super.viewDidLoad()
       let processedData = processLargeDataSet() // Blocks UI
       updateUI(with: processedData)
   }
   
   // DO move heavy operations to background queues
   func viewDidLoad() {
       super.viewDidLoad()
       DispatchQueue.global(qos: .userInitiated).async {
           let processedData = self.processLargeDataSet()
           DispatchQueue.main.async {
               self.updateUI(with: processedData)
           }
       }
   }
   ```

## Active Technologies
- Swift 5.9+ / iOS 18.0+ + SwiftUI (UI layer), NetworkEngine 2.0.1 (Alamofire-based, via `APITarget`), Connectivity (offline detection via `ReachabilityManager`), LocalAuthentication (Face ID / Touch ID), UserNotifications (push permission request) (003-incomm-signup-flow)
- None — signup session state is in-memory only; no CoreData, Keychain, or UserDefaults writes during the flow (003-incomm-signup-flow)

## Recent Changes
- 003-incomm-signup-flow: Added Swift 5.9+ / iOS 18.0+ + SwiftUI (UI layer), NetworkEngine 2.0.1 (Alamofire-based, via `APITarget`), Connectivity (offline detection via `ReachabilityManager`), LocalAuthentication (Face ID / Touch ID), UserNotifications (push permission request)
