//
//  FileNS.swift
//  My IP Port
//
//  Created by Henri Petuker on 6/9/22.
//

import Foundation
import SwiftUI
import SwiftyJSON

// MARK: FileNS
/// A `NetworkService` for fetching `File`s from the Worklfow Service API.
class FileNS {
    typealias Element = File

    func fetchFileData() async throws -> FileParsing {
        // get the Login Data as a base 64 encoded String
        let credentials = KeychainStorage.getCredentials()!
        
        // swiftlint:disable:next line_length
        let base64LoginString = await LoginService.getBase64LoginString(username: credentials.email, password: credentials.password)
        // HEHE Akten
        //new:
        //https://ipm02.eisenfuhr.com/Eisenf%C3%BChrSpeiser/api/auth/GetList?context=P6.AKTE&listId=APP%20001P6.AKTE&rowCount=1000&json=True
        //old:
        //https://ipm02.eisenfuhr.com/workflow/GetList?context=P6.AKTE&listId=APP%20001P6.AKTE&rowCount=1000&json=True
        let url = URL(string: "https://ipm02.eisenfuhr.com/Eisenf%C3%BChrSpeiser/api/auth/GetList?context=P6.AKTE&listId=APP%20001P6.AKTE&rowCount=1000&json=True")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        //"Bearer \(token)", forHTTPHeaderField: "Authorization"
        
        let token = Authentication.token
        print("+++ token: ", token)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        print("+++ data: ", data)
        print("+++ response: ", response)
        if let httpURLResponse = response as? HTTPURLResponse {
            let statusCode = httpURLResponse.statusCode
            if statusCode != 200 {
                throw APIError.genericError("Failed to fetch Akten Data from API")
            }
        }
        return try JSONDecoder().decode(FileParsing.self, from: data)
    }
    
    func fetchLogo() async throws -> [UInt8] {
                
        let credentials = KeychainStorage.getCredentials()!

        // swiftlint:disable:next line_length

        let base64LoginString = await LoginService.getBase64LoginString(username: credentials.email, password: credentials.password)
        // HEHE Logo
        let url = URL(string: "https://ipm02.eisenfuhr.com/api/Read?firm=DM2&context=GS.FRMN&id=DM2")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
  
        
//        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        let token = Authentication.token
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        

        // Fetch Data
        let (data, _) = try await URLSession.shared.data(for: request)
        let json = try JSON(data: data)
        let title = json["Documents"].arrayValue.map
        {$0["Tables"].arrayValue.map {$0["Rows"].arrayValue.map {$0["ItemArray"].arrayValue } } }
        let result = title[0][0][0][3]
        var bytes: [UInt8] = []
        try result.forEach { item, value in
            bytes.append(value.uInt8Value)
        }
        return bytes
    }
}
