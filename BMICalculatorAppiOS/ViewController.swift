//
//  ViewController.swift
//  BMICalculatorAppiOS
//
//  Created by Ashkan Goharfar on 9/25/1400 AP.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Personal Information Screen"
        view.backgroundColor = .systemGray6
        
        let buttonDone = UIButton(frame: CGRect(x: 30, y:720, width: 130, height: 50))
        view.addSubview(buttonDone)
//        buttonDone.center = view.center
        buttonDone.backgroundColor = .systemMint
        buttonDone.setTitle("Done", for: .normal)
        buttonDone.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
        
        configureItems()
    }
    
    private func configureItems() {
    }
    
    @objc func didTapDoneButton () {
        let vc = UIViewController()
        vc.title = "BMI Tracking Screen"
        navigationController?.pushViewController(vc, animated: true)
    }


}

