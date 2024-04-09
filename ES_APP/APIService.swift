//
//  APIService.swift
//  My IP Port
//
//  Created by Maximilian Hau on 29.06.22.
//

import Foundation

// SINGLETON:
// - used when uniques is required
// - globally accessabel
//      - can cause problems, good practice:
//          - dont use SINGLETON gobally BUT
//          - dependency injection


enum APIError: Error {
    case genericError(String)
}



class APIService {
    // shared as conventional name for SINGLETON
    // shared only gets created once, and used for every call of this class
    static let shared = APIService()
    var wrongCredentials = true
    
    
    
    func getValue(from response: String, forKey key: String) -> String? {
        print("----In get value: response: ", response)
        guard let range = response.range(of: "\"\(key)\":\"") else { return nil }
        let start = range.upperBound
        let remaining = response[start...]
        guard let end = remaining.range(of: "\"")?.lowerBound else { return nil }
        return String(remaining[..<end])
    }
    
    
    func login(credentials: Credentials,
               completion: @escaping (Result<Bool, Authentication.AuthenticationError>) -> Void) {
        //code inside the Task block is asynchronous
        Task {
            wrongCredentials = true
                
            let firm = credentials.firm
            let user = credentials.email
            let password = credentials.password
            
//            let lol_endpoint = "https://ipm02.eisenfuhr.com/Eisenf%C3%BChrSpeiser/api/auth"
//            let lol = URL(string: lol_endpoint)!
//
//
            
            
            
            // Create URL
            let authURLString = "https://ipm02.eisenfuhr.com/Eisenf%C3%BChrSpeiser/api/auth"
            guard let authURL = URL(string: authURLString) else {
                print("Error: Invalid URL")
                return
            }

            // Create URL request
            var authRequest = URLRequest(url: authURL)
            authRequest.httpMethod = "GET"

            // Create URLSession task
            let task = URLSession.shared.dataTask(with: authRequest) { data, response, error in
                // Check for errors
                if let error = error {
                    print("Error: \(error)")
                    return
                }
                
                // Check if data is received
                guard let data = data else {
                    print("Error: No data received")
                    return
                }
                
                // Convert data to string
                if let authResponse = String(data: data, encoding: .utf8) {
                    // Parse response to extract token
                    print("___ auth response: ", authResponse)
                    if let token = self.getValue(from: authResponse, forKey: "Message") {
                        print("Token: \(token)")
                    } else {
                        print("Error: Unable to retrieve token from response")
                    }
                } else {
                    print("Error: Unable to decode response data")
                }
            }

            // Resume URLSession task
            task.resume()
            
            
            
            
            
//            var request = URLRequest(url: lol)
//            let pop = await LoginService.getBase64LoginString(username: credentials.email, password: credentials.password)
//            request.setValue("Basic \(pop)", forHTTPHeaderField: "Authorization")
//            request.httpMethod = "GET"
//            // Assuming this code is inside a method or closure
//            let task = URLSession.shared.dataTask(with: request) { data, response, error in
//                guard let data = data else {
//                    print("Error: No data received")
//                    return
//                }
//
//                // Print the entire response object
//                print("Response: \(response)")
//
//                // Attempt to decode the response data into a string
//                if let authResponse = String(data: data, encoding: .utf8) {
//                    print("Auth response: \(authResponse)")
//
//                    // Attempt to extract token from the response
//                    if let token = self.getValue(from: authResponse, forKey: "Message") {
//                        print("Token: \(token)")
//
//                        // Update token and make another request
//                        Authentication.updateToken(newToken: token)
//                        let listURL = "\(lol)/List?context=GS.FRMN&filter=NONE.PKEYEXACT&value=\(firm)"
//                        var newRequest = URLRequest(url: URL(string: listURL)!)
//                        newRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//
//                        let listTask = URLSession.shared.dataTask(with: newRequest) { data, response, error in
//                            // Handle response...
//                        }
//                        listTask.resume()
//                    } else {
//                        print("Error: Unable to retrieve token")
//                    }
//                } else {
//                    print("Error: Unable to decode auth response")
//                }
//            }
//            task.resume()

            
            
            
            
            

            let endpoint = "https://ipm02.eisenfuhr.com/Eisenf%C3%BChrSpeiser/"
            let url = URL(string: endpoint)!
            var request = URLRequest(url: url)

            // build login string with username and password -> Authorization: Basic email:password
            let base64LoginString = await LoginService.getBase64LoginString(username: credentials.email, password: credentials.password)
            request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
            request.httpMethod = "GET"

            do {
                let (data, response) = try await URLSession.shared.data(for: request)
                if let httpURLResponse = response as? HTTPURLResponse {
                    print(httpURLResponse)
                    let statusCode = httpURLResponse.statusCode
                    if statusCode != 200 {
                        self.wrongCredentials = true
                    } else {
                        self.wrongCredentials = false
                    }
                } else {
                    print("Unexpected response type.")
                    self.wrongCredentials = true
                }
            } catch {
                print("DEBUG: catch error in NSURLConnection: ", error)
                print(error)
            }
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                if self.wrongCredentials {
                    print("DEBUG: wrong credentials in DispatchQueue Login")
                    completion(.failure(.invalidCredentials))
                } else {
                    completion(.success(true))
                }
            }
        }
    }
}
