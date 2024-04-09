//
//  User.swift
//  My IP Port
//
//  Created by Maximilian Hau on 29.06.22.
//

import Foundation

// Codable Keyword:
// automatic conformance that satisfies all of the protocol requirements from Encodable and Decodable
struct Credentials: Codable {
    var email: String = ""
    var password: String = ""
    var firm: String = ""
    
    
//TODO: suppressing force_try is not recommended, wrapp both functions in a try-catch block and handle the error
    func encoded() -> String {
        let encoder = JSONEncoder()
        // swiftlint:disable:next force_try
        let credentialsData = try! encoder.encode(self)
        return String(data: credentialsData, encoding: .utf8)!
    }

    static func decode(_ credentialsString: String) -> Credentials {
        let decoder = JSONDecoder()
        let jsonData = credentialsString.data(using: .utf8)
        // swiftlint:disable:next force_try
        return try! decoder.decode((Credentials.self), from: jsonData!)
    }
}
