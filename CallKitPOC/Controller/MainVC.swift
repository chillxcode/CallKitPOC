//
//  ViewController.swift
//  CallKitPOC
//
//  Created by Emre Celik on 12.02.2020.
//  Copyright © 2020 Emre Celik. All rights reserved.
//

import UIKit
import CallKit

class MainVC: UIViewController {
    
    var detailType: detailType!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("View Loaded")
    }
    
    @IBAction func addUserClicked(_ sender: Any) {
        let alert = UIAlertController(title: "Add User", message: nil, preferredStyle: .alert)
        alert.addTextField { (tf) in tf.placeholder = "Name" }
        alert.addTextField { (tf) in
            tf.placeholder = "905392772612"
        }
        let action = UIAlertAction(title: "Submit", style: .default) { (_) in
            guard let name = alert.textFields?.first?.text , let phoneText = alert.textFields?.last?.text else { return }
            if name == "" || phoneText == "" { return }
            let sqlUser = SQLUserModel()
            sqlUser.name = name
            sqlUser.phone = Int64(phoneText)
            sqlUser.insert(model: sqlUser)
        }
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func listUsersClicked(_ sender: Any) {
        self.detailType = .users
        performSegue(withIdentifier: "ToDetail", sender: nil)
    }
    
    @IBAction func updateUserClicked(_ sender: Any) {
    }
    
    @IBAction func deleteUserClicked(_ sender: Any) {
        let alert = UIAlertController(title: "Delete User", message: nil, preferredStyle: .alert)
        alert.addTextField { (tf) in tf.placeholder = "905392772612" }
        let action = UIAlertAction(title: "Submit", style: .default) { (_) in
            guard let phoneText = alert.textFields?.first?.text else { return }
            if phoneText == "" { return }
            
            let sqlUser = SQLUserModel()
            sqlUser.phone = Int64(phoneText)
            sqlUser.delete(model: sqlUser)
        }
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func deleteUsersClicked(_ sender: Any) {
        SQLUserModel().deleteAll()
    }
    
    
    @IBAction func refreshCallKitClicked(_ sender: Any) {
        CXCallDirectoryManager.sharedInstance.getEnabledStatusForExtension(withIdentifier: "com.emrecelik.CallKitPOC.KocSistem", completionHandler: { (enabledStatus,error) -> Void in
            if let error = error {
                print(error.localizedDescription)
            }
            if enabledStatus == .disabled {
                self.showAlert(title: "Please Open Extension", message: "in settings...")
                return
            }
            CXCallDirectoryManager.sharedInstance.reloadExtension(withIdentifier:"com.emrecelik.CallKitPOC.KocSistem", completionHandler: {
                (error) -> Void in
                if let error = error {
                    print(error.localizedDescription)
                    self.showAlert(title: "Error", message: error.localizedDescription)
                    return
                }
                self.showAlert(title: "Success", message: "Successfuly Reloaded")
            })
            print("No error")
        })
    }
    
    @IBAction func callKitInfoClicked(_ sender: Any) {
        self.detailType = .info
        performSegue(withIdentifier: "ToDetail", sender: nil)
    }
    
    @IBAction func deleteInfosClicked(_ sender: Any) {
        SQLInfoModel().deleteAll()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToDetail" {
            if let destinationVC = segue.destination as? DetailVC {
                destinationVC.detailType = self.detailType
            }
        }
    }
    
}

extension MainVC {
    func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}


public enum Code : Int {
    public typealias _ErrorType = CXErrorCodeCallDirectoryManagerError

    case unknown

    case noExtensionFound

    case loadingInterrupted

    case entriesOutOfOrder

    case duplicateEntries

    case maximumEntriesExceeded

    case extensionDisabled

    @available(iOS 10.3, *)
    case currentlyLoading

    @available(iOS 11.0, *)
    case unexpectedIncrementalRemoval
}
