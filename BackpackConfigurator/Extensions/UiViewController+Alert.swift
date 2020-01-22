//
//  UiViewController+Alert.swift
//  BackpackConfigurator
//
//  Created by Vojtěch Srb on 27/02/2019.
//  Copyright © 2019 Vojtěch Srb. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Warning", message:
            message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func changeCellColor (cellIndex: String, whatColor: UIColor, collectionView: UICollectionView) {
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: items.firstIndex(of: cellIndex)!, section: 0)
            let cell = collectionView.cellForItem(at: indexPath)
            
            if cell?.isSelected == true {
                // do nothing
            }
            else {
                cell?.backgroundColor = whatColor
            }
        }
    }
}

