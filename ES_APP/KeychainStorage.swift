
import Foundation
import SwiftKeychainWrapper


// KeychainStorage handels storing credentials in KeyChain while using third-party wrapper SwiftKeychainWrapper for simplified handeling of interacting with Apples Keychain mechanism
enum KeychainStorage {
    static let key = "credentials"
    
    // talking here to Keychain API of Apple, SwiftKeychainWrapper simplifies that
    
    static func getCredentials() -> Credentials? {
        if let myCredentialsString = KeychainWrapper.standard.string(forKey: Self.key) {
            return Credentials.decode(myCredentialsString)
        } else {
            return nil
        }
    }
    
    static func saveCredentials(_ credentials: Credentials) -> Bool {
        if KeychainWrapper.standard.set(credentials.encoded(), forKey: Self.key) {
            return true
        } else {
            return false
        }
    }
}
