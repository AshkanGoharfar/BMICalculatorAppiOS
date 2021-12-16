//
//  ViewController.swift
//  BMICalculatorAppiOS
//
//  Created by Ashkan Goharfar on 9/25/1400 AP.
//

import RealmSwift
import UIKit

/**
 * Create To do list object for database and other purposes as it includes a tasks parameters like name of the task, description of the task and etc.
 */
class BMIListObject: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var age: String = ""
    @objc dynamic var id: String = ""
    @objc dynamic var gender: String = ""
    @objc dynamic var scroingType: Bool = false
    @objc dynamic var weight: String = ""
    @objc dynamic var height: String = ""
}


class ViewController: UIViewController {

    private let realmDB = try! Realm()
    private var data = [BMIListObject]()
    
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var bMITypeLabel: UILabel!
    @IBOutlet weak var weightTypeLabel: UILabel!
    @IBOutlet weak var heightTypeLabel: UILabel!
    
    @IBOutlet weak var currentBMIValue: UILabel!
    
    @IBOutlet weak var bMIMessageString: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Personal Information Screen"
        view.backgroundColor = .systemGray6
        
        let buttonDone = UIButton(frame: CGRect(x: 30, y:760, width: 130, height: 50))
        view.addSubview(buttonDone)
//        buttonDone.center = view.center
        buttonDone.backgroundColor = .systemMint
        buttonDone.setTitle("Done", for: .normal)
        buttonDone.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
    }
    
    
    
    @objc func didTapDoneButton () {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "BMITable") as? BMITableViewController else {
            return
        }
        vc.title = "BMI Tracking Screen"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // This function will give all of data from Realm database and will reload our tableview
    func refresh()
    {
        // Update the data according to the database
        data = realmDB.objects(BMIListObject.self).map({ $0 })
    }


}

