//
//  Network.swift
//  BackpackConfigurator
//
//  Created by Vojtěch Srb on 13/05/2019.
//  Copyright © 2019 Vojtěch Srb. All rights reserved.
//

import Foundation
import SwiftSocket
import SwiftyJSON

    //var ipsBackpacks:[String] = ["10.46.4.110", "10.46.4.164", "10.46.4.227", "10.46.119", "10.46.4.33", "10.46.4.28", "10.46.4.157", "10.46.4.210", "10.46.4.170", "10.46.4.207", "10.46.4.189", "10.46.4.149", "10.46.4.192", "10.46.4.138", "10.46.4.112", "10.46.4.195", "10.46.4.196", "10.46.4.197", "10.46.4.198", "10.46.4.199", "10.46.4.201", "10.46.4.130", "10.46.4.203", "10.46.4.92"]

class Network {
    
    // check online backpacks via GET request
    func pingBackpacks(timer:Timer, collectionView: UICollectionView) {
        
        let token = try? keychain.getString("golem")
        
        for i in 1...items.count
        {
            Requests().getRequest(id: i, token: token!) { rigData in
                do {
                    // json manipulation via SwiftyJSON
                    let json = try! JSON(data: rigData)
                    print(json)
                    
                    // finding values from json
                    let gameName = json["gameName"].stringValue
                    let state = json["state"].stringValue
                    let idrig = json["id"].stringValue
                    
                    print(gameName,state, idrig)
                    
                    switch state {
                    case "Connected":
                        if gameName == "golem" {
                            
                            // change color to brown
                            ViewController().changeCellColor(cellIndex: idrig, whatColor: UIColor.brown, collectionView: collectionView)
                        }
                        else if gameName == "Arachnoid" {
                            
                            // change color to red
                            ViewController().changeCellColor(cellIndex: idrig, whatColor: UIColor.red, collectionView: collectionView)
                        }
                        break
                        
                    case "Disconnected":
                        DispatchQueue.main.async {
                            
                            // change color to lightGray
                            ViewController().changeCellColor(cellIndex: idrig, whatColor: UIColor.lightGray, collectionView: collectionView)
                        }
                        break
                        
                    default:
                        
                        // do nothing
                        print("error")
                    }
                }
            }
        }
    }
}
