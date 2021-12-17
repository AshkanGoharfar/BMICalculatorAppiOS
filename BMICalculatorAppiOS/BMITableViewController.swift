//
//  BMITableViewController.swift
//  BMICalculatorAppiOS
//
//  Created by Ashkan Goharfar on 9/25/1400 AP.
//
import RealmSwift
import UIKit
import SwiftUI

class BMITableViewController: UIViewController, UITableViewDelegate ,UITableViewDataSource {

    public var data = [BMIListObject]()
    @IBOutlet var table: UITableView!
    private let realmDB = try! Realm()
    public var deletionHandler: (() -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        render()
        table.reloadData()
        table.delegate = self
        table.dataSource = self
    }
    
    func render() {
        let bMIList = try! realmDB.objects(BMIListObject.self)
        for bmi in bMIList {
            data.append(bmi)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "cell")
        }
        cell?.textLabel?.text = "Weight: " + data[indexPath.row].weight
        
        var dateFormatter = DateFormatter()
//        cell?.detailTextLabel?.text = String(data[indexPath.row].currentDate)
        print("Date :::::::")

        dateFormatter.dateFormat = "yyyy-MM-dd h:mm:ss a"
        var formatteddate = dateFormatter.string(from: data[indexPath.row].currentDate)
        print(formatteddate)
        cell?.detailTextLabel?.text = formatteddate
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
        label.text = "BMI: " + data[indexPath.row].currentBMIImperial + data[indexPath.row].currentBMIMetric
        cell!.accessoryView = label
        return cell!
    }
    
    /**
     * This function aims to create a swipe of left to right to show blue edit button and after pressing the edit button navigate to edit screen.
     */
     func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

         // delete
         let deleteSwipe = UIContextualAction(style: .normal, title: "Delete") { (action, view, completionHandler) in
         completionHandler(true)
         self.realmDB.beginWrite()
         self.realmDB.delete(self.data[indexPath.row])
         try! self.realmDB.commitWrite()

         // we use ? because the function is optional
         self.deletionHandler?()

        self.data.remove(at: indexPath.row)
        self.table.deleteRows(at: [indexPath], with: .automatic)
     }
     deleteSwipe.image = UIImage(systemName: "trash")
     deleteSwipe.backgroundColor = .red
     let swipeLeftToRight = UISwipeActionsConfiguration(actions: [deleteSwipe])
       
       return swipeLeftToRight
     }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = data[indexPath.row]
        
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "Edit") as? EditViewController else {
            return
        }
        vc.bMIRecord = item
        vc.deletionHandler = { [weak self] in
            self?.refresh()
        }
        vc.afterEditHandler = { [weak self] in
            self?.refresh()
        }
        
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.title = data[indexPath.row].name
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func pressedAddNewTaskButton()
    {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "View") as? ViewController else {
            return
        }
        vc.afterEditHandler = { [weak self] in
            self?.refresh()
        }
        vc.title = "Personal Information Screen"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }

    
    // This function will give all of data from Realm database and will reload our tableview
    func refresh()
    {
        // Update the data according to the database
        data = realmDB.objects(BMIListObject.self).map({ $0 })
        table.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
