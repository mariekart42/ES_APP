//
//  LoginService.swift
//  My IP Port
//
//  Created by Dominik Remo on 07.06.22.
//
import SwiftUI

// MARK: LoginService
/// Service for creating a login string
class LoginService {
    @EnvironmentObject var loginViewModel: LoginViewModel
    
    
    /// Function for getting Login credentials
    /// - Parameters:
    ///   - username: the user's username
    ///   - password: the user's password
    ///   - firm: the user's association
    /// - Returns: encoded `String` containing the formatted login data
    static func getLoginData (username: String, password: String, firm: String) -> String {
        let loginString = username + "@" + firm + ":" + password
        let loginData = loginString.data(using: String.Encoding.utf8)!
        return loginData.base64EncodedString()
    }
    
    
    static func getBase64LoginString(username: String, firm: String, password: String) -> String {
        let loginString = username + "@" + firm + ":" + password
        let loginData = loginString.data(using: String.Encoding.utf8)!
        return loginData.base64EncodedString()
    }
}
