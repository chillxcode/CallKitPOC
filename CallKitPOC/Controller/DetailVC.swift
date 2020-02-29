//
//  DetailVC.swift
//  CallKitPOC
//
//  Created by Emre Celik on 12.02.2020.
//  Copyright © 2020 Emre Celik. All rights reserved.
//

import UIKit

enum detailType {
    case users
    case info
}

class DetailVC: UIViewController {

    @IBOutlet weak var textView: UITextView!
    var detailType: detailType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switch detailType {
        case .users:
            textView.text = "List User\n\n"
            listUsers()
        case .info:
            textView.text = "CallKit Info\n\n"
            callKitInfo()
        case .none:
            print(".none")
        }
    }
    
    func listUsers () {
        let users = SQLUserModel().selectAll()
        for user in users {
            textView.text += "* \(user.name ?? "") - \(user.phone?.description ?? "")\n"
        }
        textView.text += "_end_if_"
    }
    
    func callKitInfo() {
        let infos = SQLInfoModel().selectAll()
        for info in infos {
            textView.text += "* \(info.info ?? "")\n"
        }
        textView.text += "_end_if_"
    }
    
}
