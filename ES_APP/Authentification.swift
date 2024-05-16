//
//  Authentification.swift
//  My IP Port
//
//  Created by Maximilian Hau on 29.06.22.
//

import SwiftUI
import LocalAuthentication

class Authentication: ObservableObject {
    @Published var isValidated = false
    @Published var isAuthorized = false
    @Published var isUnlocked = false
    
    static var token: String = ""
        
    static func updateToken(newToken: String) {
        token = newToken
    }
    
    enum BiometricType {
        case none
        case face
        case touch
    }
    
    enum AuthenticationError: Error, LocalizedError, Identifiable {
        case invalidCredentials
        case deniedAccess
        case noFaceIdEnrolled
        case noFingerprintEnrolled
        case biometrictError
        case credentialsNotSaved
        
        var id: String {
            self.localizedDescription
        }
        
        var errorDescription: String? {
            switch self {
            case .invalidCredentials:
                return NSLocalizedString("Falscher Benutzername oder falsches Passwort.", comment: "")
            case .deniedAccess:
                // swiftlint:disable:next line_length
                return NSLocalizedString("FaceID nicht aktiviert. Bitte aktivieren Sie FaceID in den Einstellungen.", comment: "")
            case .noFaceIdEnrolled:
                return NSLocalizedString("Keine FaceID aktiviert", comment: "")
            case .noFingerprintEnrolled:
                return NSLocalizedString("Keine Fingerabdrücke aktiviert.", comment: "")
            case .biometrictError:
                return NSLocalizedString("FaceID oder Fingerabdruck nicht erkannt", comment: "")
            case .credentialsNotSaved:
                // swiftlint:disable:next line_length
                return NSLocalizedString("Ihre Logindaten wurden nicht gespeichert", comment: "")
            }
        }
    }
    
    func updateValidation(success: Bool) {
        withAnimation {
            objectWillChange.send()
            if success {
                let userDefaults = UserDefaults.standard
                userDefaults.set(true, forKey: "loginStatus")
            } else {
                let userDefaults = UserDefaults.standard
                userDefaults.removeObject(forKey: "loginStatus")
            }
        }
    }
    
    func updateUnlockStatus(success: Bool) {
        withAnimation {
            isUnlocked = success
        }
    }
    
    func biometricType() -> BiometricType {
        let authContext = LAContext()
        let _ = authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        switch authContext.biometryType {
        case .none:
            return .none
        case .touchID:
            return .touch
        case .faceID:
            return .face
        @unknown default:
            return .none
        }
    }
    
    func initiateLogOut() -> Void {
        self.updateValidation(success: false)
    }
    
    func requestBiometricUnlockNoCredentials(completion: @escaping (Result<Credentials, AuthenticationError>) -> Void) {
        var credentials = Credentials(username: "", password: "", firm: "")
        let context = LAContext()
        var error: NSError?
        let canEvaluate = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        if let error = error {
            switch error.code {
            case -6:
                completion(.failure(.deniedAccess))
            case -7:
                if context.biometryType == .faceID {
                    completion(.failure(.noFaceIdEnrolled))
                } else {
                    completion(.failure(.noFingerprintEnrolled))
                }
            default:
                completion(.failure(.biometrictError))
            }
            return
        }
        if canEvaluate {
            if context.biometryType != .none {
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Need to access credentials.") { success, error in
                    DispatchQueue.main.async {
                        if error != nil {
                            completion(.failure(.biometrictError))
                        } else {
                            completion(.success(credentials))
                        }
                    }
                }
            }
        }
    }
    
    func requestBiometricUnlock(completion: @escaping (Result<Credentials, AuthenticationError>) -> Void) {

        var credentials = KeychainStorage.getCredentials()
        guard var credentials = credentials else {
            completion(.failure(.credentialsNotSaved))
            return
        }
        let context = LAContext()
        var error: NSError?
        let canEvaluate = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        if let error = error {
            switch error.code {
            case -6:
                completion(.failure(.deniedAccess))
            case -7:
                if context.biometryType == .faceID {
                    completion(.failure(.noFaceIdEnrolled))
                } else {
                    completion(.failure(.noFingerprintEnrolled))
                }
            default:
                completion(.failure(.biometrictError))
            }
            return
        }
        if canEvaluate {
            if context.biometryType != .none {
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Need to access credentials.") { success, error in
                    DispatchQueue.main.async {
                        if error != nil {
                            completion(.failure(.biometrictError))
                        } else {
                            completion(.success(credentials))
                        }
                    }
                }
            }
        }
    }
}
