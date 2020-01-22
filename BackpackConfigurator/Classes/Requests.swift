//
//  Requests.swift
//  BackpackConfigurator
//
//  Created by Vojtěch Srb on 27/07/2019.
//  Copyright © 2019 Vojtěch Srb. All rights reserved.
//

import Foundation

class Requests {
    
    func loginRequest(completionBlock: @escaping (String) -> Void) {
                
        // prepare json data
        let json: [String: Any] = ["email": "staff",
            "password": "golem"]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create POST request
        let url = URL(string: "http://10.46.4.4:6505/api/Account/Login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // parameters
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            
        if let stringData = String(data: data, encoding: String.Encoding.utf8)
        {
                completionBlock(stringData);
        }
    }
        
        task.resume()
    }
    
    func changeGameRequest(id: String, whatGame: String, token: String) {
        
                var token = token
        
                // remove double quotes
                token.removeFirst()
                token.removeLast()
                
                // prepare data
                let game: Data? = whatGame.data(using: .utf8)
                
                // create POST request
                let url = URL(string: "http://10.46.4.4:6505/api/Rigs/" + id)!
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                
                // parameters
                request.httpBody = game
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    guard let _ = data, error == nil else {
                        print(error?.localizedDescription ?? "No data")
                        return
                    }
                }
                
                task.resume()
            }

    func getRequest(id: Int, token: String, completionBlock: @escaping (Data) -> Void) {
        
                var token = token
        
                // remove double quotes
                token.removeFirst()
                token.removeLast()
                
                /// create GET request
                let url = URL(string: "http://10.46.4.4:6505/api/Rigs/" + String(id))!
                var request = URLRequest(url: url)
                
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

                // create dataTask using the session object to send data to the server
                let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
                    
                    guard error == nil else {
                        return
                    }
                    
                    guard let data = data else {
                        return
                    }
                    
                    completionBlock(data)
                })
                task.resume()
            }
        }
