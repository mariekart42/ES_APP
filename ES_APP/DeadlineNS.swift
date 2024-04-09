//
//  DeadlinesNS.swift
//  My IP Port
//
//  Created by Dominik Remo on 07.06.22.
//

import Foundation
import SwiftUI


// MARK: DeadlineNS
/// A `NetworkService` for fetching `Deadline`s from the Worklfow Service API.
class DeadlineNS {
    typealias Element = Deadline

    /// Fetches `Deadline`s from the DMZ Server
    /// - Returns: Fetched data as `DeadlineParsing`
    func fetchDeadlineData() async throws -> DeadlineParsing {
        
        let credentials = KeychainStorage.getCredentials()!

        let base64LoginString = await LoginService.getBase64LoginString(username: credentials.email, password: credentials.password)

        
        
        // HEHE Deadlines
        let getListFlt1 = "https://ipm02.eisenfuhr.com/workflow/GetList?context=P6.FRST&listId=APP+001P6.FRST&rowCount=1000&json=True"
        
        let url = URL(string: getListFlt1)!

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        //request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")

        let token = Authentication.token
        print("TOKEN IN DEADLINES: ", token)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        
        let (data, response) = try await URLSession.shared.data(for: request)

        if let httpURLResponse = response as? HTTPURLResponse {
            let statusCode = httpURLResponse.statusCode
            if statusCode != 200 {
                throw APIError.genericError("Failed to fetch Deadline Data from API")
            }
        }
        return try JSONDecoder().decode(DeadlineParsing.self, from: data)
    }
}
