//
//  LockedViewModel.swift
//  My IP Port
//
//  Created by Johannes Fuest on 09.07.22.
//

import Foundation
import LocalAuthentication
import SwiftUI
class LockedViewModel: ObservableObject {
    @Published var error: Authentication.AuthenticationError?
}
