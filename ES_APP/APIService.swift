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
//        print("----In get value: response: ", response)
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
//            var loginViewModel = LoginViewModel()
            var wrongCredentials:Bool = true // Assuming this variable is defined elsewhere
            
            let firm = credentials.firm
            let user = credentials.username
            let password = credentials.password

            let authURLString = "https://ipm02.eisenfuhr.com/api/auth"
            guard let authURL = URL(string: authURLString) else {
                print("Error: Invalid URL")
                return
            }

            do {
//                var wrongCredentials:Bool = true
                let pop = try await LoginService.getBase64LoginString(username: credentials.username, firm: credentials.firm, password: credentials.password)
                
                var authRequest = URLRequest(url: authURL)
                authRequest.setValue("Basic \(pop)", forHTTPHeaderField: "Authorization")
                authRequest.httpMethod = "GET"
                
                let (data, response) = try await URLSession.shared.data(for: authRequest)
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    if let responseDataString = String(data: data, encoding: .utf8) {
                        
                        if let token = self.getValue(from: responseDataString, forKey: "Message") {
//                            print("Token: \(token)")
//                            AuthManager.shared.token = token
                            Authentication.updateToken(newToken: token)
//                            credentials.setToken(tokenUpdate: token)
                            
//                            loginViewModel.credentials.token = token// Extract token from 'data'
//                            print("print after receiving token: \(AuthManager.shared.token)")
                            wrongCredentials = false // Corrected to assign a Boolean value
                        } else {
                            print("Error: Unable to retrieve token")
                        }
                    } else {
                        print("Error: Unable to retrieve responseDataString")
                    }
                } else {
                    // Authentication failed
                    print("Error: Authentication failed")
                }
            } catch {
                print("Error: \(error)")
            }
            
//            // Handle completion based on the result
//            if wrongCredentials {
//                completion(.failure(.wrongCredentials))
//            } else {
//                completion(.success(true))
//            }
            
            
            
            

            let endpoint = "https://ipm02.eisenfuhr.com/Eisenf%C3%BChrSpeiser/"
            let url = URL(string: endpoint)!
            var request = URLRequest(url: url)

            // build login string with username and password -> Authorization: Basic email:password
            let base64LoginString = await LoginService.getBase64LoginString(username: credentials.username, firm: credentials.firm, password: credentials.password)
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
