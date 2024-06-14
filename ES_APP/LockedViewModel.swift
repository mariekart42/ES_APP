
import Foundation
import LocalAuthentication
import SwiftUI
class LockedViewModel: ObservableObject {
    @Published var error: Authentication.AuthenticationError?
}
