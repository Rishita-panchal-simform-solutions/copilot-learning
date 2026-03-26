//
//  UserListView.swift
//  GithubCopilotLearning
//
//  Created by Rishita Panchal on 26/03/2026.
//  Copyright © 2026 Simform Solutions. All rights reserved.
//
import SwiftUI
import Kingfisher
// MARK: - variable
struct UserListView {
    var user: UserListElement
}
// MARK: - view
extension UserListView: View {
    var body: some View {
        HStack(spacing: 12) {
            userAvatar
            VStack(spacing: 4) {
                Group {
                    Text(user.firstName ?? "")
                    + Text(" ")
                    + Text(user.lastName ?? "")
                    Text(user.email ?? "")
                }
                .font(.systemBold(size: 18))
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, 10)
        .padding(.horizontal, 20)
    }
}
// MARK: - subviews
extension UserListView {
    private var userAvatar: some View {
        KFImageView(
            urlString: user.avatar ?? "",
            frame: .init(width: 100, height: 100)) {
                ShimmerView()
                    .frame(width: 100, height: 100)
            }
    }
}
// swiftlint:disable line_length
#Preview {
    UserListView(user: .init(id: 1, uid: "12324", password: "123243", firstName: "Lyle", lastName: "Wehner", username: "lyle.wehner", email: "lyle.wehner@email.com", avatar: "https://robohash.org/explicabopraesentiumquae123345.png", gender: "Agender", phoneNumber: "+40 166-078-1100", socialInsuranceNumber: "180104127", dateOfBirth: "1995-08-07", employment: .init(title: "District Sales Agent", keySkill: "Proactive"), address: .init(city: "Port Suzieborough", streetName: "Volkman Rapids", streetAddress: "12637 Gricelda Key", zipCode: "46515-9931", state: "Massachusetts", country: "United States", coordinates: .init(lat: 30.225637481581415, lng: -98.64746580813048)), creditCard: .init(ccNumber: "4580318222871"), subscription: .init(plan: "Standard", status: "Pending", paymentMethod: "WeChat Pay", term: "Full subscription")))
}
// swiftlint:enable line_length