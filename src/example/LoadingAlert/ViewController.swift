//
//  ViewController.swift
//  LoadingAlert
//
//  Created by にか on 2025/02/22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func onButtonTapped(_ sender: Any) {
        LoadingAlertViewController.getInstanceAuto(
            instance: { instance in
                _ = instance.setupLoadingAlert()
                instance.show()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: DispatchWorkItem {
                    instance.hide()
                })
            }
        )
    }
    
}

