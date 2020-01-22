//
//  ViewController.swift
//  BackpackConfigurator
//
//  Created by Vojtěch Srb on 19/02/2019.
//  Copyright © 2019 Vojtěch Srb. All rights reserved.
//

import UIKit
import KeychainAccess

    var items = ["1", "2", "3", "4", "5", "6", "7", "8" ,"9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28"]

    let keychain = Keychain(service: "com.divrlabs.BackpackConfigurator-token")

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
        
    @IBOutlet weak var backpackCellView: UICollectionView!
    @IBOutlet weak var GolemButton: UIButton!
    @IBOutlet weak var ArachnoidButton: UIButton!
    
    let reuseIdentifier = "cell"

    var selectedBackpacks:[Int?] = []
    var selectedBackpacksNumbers:[String?] = []
    var oldColor = UIColor.red
    var backpackIndexPaths:[IndexPath] = []
    private let margin: CGFloat = 20.0

    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView.allowsMultipleSelection = true
        return items.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! MyCollectionViewCell
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        cell.myLabel.text = items[indexPath.item]
        
        // make cell more visible in our example project
        cell.backgroundColor = UIColor.lightGray
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        
        return cell
    }
    
    // get indexPath for selected Backpacks
    var selectedBackpackIndexPath: IndexPath? {
        didSet {
            var indexPaths: [IndexPath] = []
            if let selectedBackpackIndexPath = selectedBackpackIndexPath {
                indexPaths.append(selectedBackpackIndexPath)
                print(selectedBackpackIndexPath.item)
            }
        }
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    // change color when selected
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        
        // alert if selected is offline
        let cell = collectionView.cellForItem(at: indexPath)
        if cell?.backgroundColor == UIColor.lightGray {
            showAlert(message: "Backpack Offline")
            backpackCellView.deselectItem(at: indexPath, animated: true)
        }
        else {
            cell?.backgroundColor = UIColor.orange
            
            selectedBackpackIndexPath = indexPath
            backpackIndexPaths.append(indexPath)
            selectedBackpacks.append(selectedBackpackIndexPath?.item)
            print(selectedBackpacks)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You deselected cell #\(indexPath.item)!")
        
        selectedBackpacks.removeAll {$0 == indexPath.item}
        print(selectedBackpacks)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        Requests().loginRequest() { output in
            do { keychain["golem"] = output
            }
        }
        
        _ = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) {
            timer in
            DispatchQueue.global(qos: .background).async {
               Network().pingBackpacks(timer: timer, collectionView: self.backpackCellView)
            }
        }
    }
    
    // MARK: - Button Handlers
    
    // change game to golem
    @IBAction func changeToGolem(_ sender: Any) {
        
        guard  selectedBackpacks.count > 0 else {
            showAlert(message: "No Backpack Selected")
            return
        }
        
        let token = try? keychain.getString("golem")
        print(token ?? "token")
        
        // change game via POST request
        for i in 0...selectedBackpacks.count - 1
        {
            Requests().changeGameRequest(id: items[selectedBackpacks[i]!], whatGame: #""golem""#, token: token!)
            print(items[selectedBackpacks[i]!])
        }
        
        // deselect backpack
        backpackCellView.selectItem(at: nil, animated: true, scrollPosition: [])
        
        // remove from selection
        selectedBackpacks.removeAll()
        backpackIndexPaths.removeAll()
    }
    
    // change game to arachnoid
    @IBAction func changeToArachnoid(_ sender: Any) {
        
        guard  selectedBackpacks.count > 0 else {
            showAlert(message: "No Backpack Selected")
            return
        }
        
        let token = try? keychain.getString("golem")
        print(token ?? "token")
        
        // change game via POST request
        for i in 0...selectedBackpacks.count - 1
        {
            Requests().changeGameRequest(id: items[selectedBackpacks[i]!], whatGame: #""arachnoid""#, token: token!)
            print(items[selectedBackpacks[i]!])
        }
        
        // deselect backpack
        backpackCellView.selectItem(at: nil, animated: true, scrollPosition: [])
        
        // remove from selection
        selectedBackpacks.removeAll()
        backpackIndexPaths.removeAll()
    }
}
