//
//  LoginViewModel.swift
//  My IP Port
//
//  Created by Julian Heiß on 01.06.22.
//

import Foundation

class LoginViewModel: ObservableObject {
    @Published var credentials = Credentials()
    @Published var showProgressView = false
    @Published var error: Authentication.AuthenticationError?
    @Published var storeCredentialsNext = false
    
    
    var loginDisabled: Bool {
        credentials.email.isEmpty || credentials.password.isEmpty || credentials.firm.isEmpty
    }
//    Validates the Data of the login by checking via API call
    // @escaping means, instance of function outlives scope of function -> runns in memory
    // [common thing for Network calls cause they can take a long time]
    func login(completion: @escaping (Bool) -> Void) {
        showProgressView = true
        print("---- IN LOGIN: credentials: ", credentials)
        do {
            APIService.shared.login(credentials: credentials) {
                [unowned self] (result:Result<Bool, Authentication.AuthenticationError>) in
                showProgressView = false
                switch result {
                case .success:
                    if storeCredentialsNext {
                        if KeychainStorage.saveCredentials(credentials) {
                            storeCredentialsNext = false
                        }
                    }
                    completion(true)
                case .failure(let authError):
                    print("DEBUG: login failure")
                    credentials = Credentials()
                    error = authError
                    completion(false)
                }
            }
        }
    }
    
    func saveCredentials() {
        KeychainStorage.saveCredentials(credentials)
    }
}
