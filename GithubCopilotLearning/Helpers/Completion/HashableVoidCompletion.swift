//
//  HashableVoidCompletion.swift
//  GithubCopilotLearning
//
//  Created by Rishita Panchal on 26/03/2026.
//  Copyright © 2026 Simform Solutions. All rights reserved.
//
import Foundation
typealias VoidCompletion = (() -> Void)
/// A `Hashable` wrapper for a `VoidCompletion` closure, enabling unique identification and use in `Hashable` collections.
///
/// `HashableVoidCompletion` allows you to work with closures (of type `VoidCompletion`) in contexts that require conformance to `Hashable`.
/// Each instance is uniquely identified by an internal UUID, ensuring that each closure instance is treated as distinct even if the closure
/// code is identical.
///
/// - Warning: The equality (`==`) and hashing (`hash(into:)`) are based solely on the UUID, not the closure content. This means that
///   two instances of `HashableVoidCompletion` with identical closure code will be treated as different instances if they have different UUIDs.
struct HashableVoidCompletion: Hashable {
    let id: UUID = UUID()
    let completion: VoidCompletion
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func == (lhs: HashableVoidCompletion, rhs: HashableVoidCompletion) -> Bool {
        return lhs.id == rhs.id
    }
}
// MARK: - Usage Example
/// Usage:
/// ```swift
/// // Define an enum for navigation destinations, including a case with `HashableVoidCompletion`
/// enum DashboardSectionRouterDestination: Hashable {
///     case secondView(didUpdateData: HashableVoidCompletion)
/// }
///
/// // In the source view, create a unique `HashableVoidCompletion` instance and navigate to the destination
/// struct FirstView: View {
///     @State private var routerPath = NavigationPath()
///
///     var body: some View {
///         NavigationStack(path: $routerPath) {
///             Button("Go to Second View") {
///                 // Passing a unique `HashableVoidCompletion` to `SecondView`
///                 let hashableCompletion = HashableVoidCompletion(completion: { print("Hello from Second View") })
///                 routerPath.append(DashboardSectionRouterDestination.secondView(didUpdateData: hashableCompletion))
///             }
///             .navigationDestination(for: DashboardSectionRouterDestination.self) { destination in
///                 switch destination {
///                 case .secondView(let didUpdateData):
///                     SecondView(didUpdate: didUpdateData)
///                 }
///             }
///         }
///     }
/// }
///
/// // In the destination view, execute the closure when required
/// struct SecondView: View {
///     var didUpdate: HashableVoidCompletion?
///
///     var body: some View {
///         Button("Execute Completion") {
///             didUpdate?.completion()
///         }
///     }
/// }
/// ```