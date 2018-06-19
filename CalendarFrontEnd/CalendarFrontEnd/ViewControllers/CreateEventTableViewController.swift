//
//  CreateEventTableViewController.swift
//  CalendarFrontEnd
//
//  Created by Victor Zhong on 6/17/18.
//  Copyright © 2018 Victor Zhong. All rights reserved.
//

import UIKit

class CreateEventTableViewController: UITableViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var startTimePicker: UIDatePicker!
    @IBOutlet weak var endTimePicker: UIDatePicker!
    @IBOutlet weak var datePicker: UIDatePicker!

    var event: Event?
    var dateString: String?
    var dateManager: DateManager!
    var apiClient: APIRequestManager!

    override func viewDidLoad() {
        super.viewDidLoad()

        titleTextField.delegate = self
        apiClient = dateManager.apiClient
        populateFields()
    }

    @IBAction func finishButtonTapped(_ sender: Any) {
        guard startTimePicker.date < endTimePicker.date && titleTextField.text != "" else { return }
        dateManager.performEventDataTask(titleTextField.text!, startTimeDate: startTimePicker.date, endTimeDate: endTimePicker.date, date: datePicker.date, event: event) {
            print("Done!")
            self.navigationController?.popViewController(animated: true)
        }
    }

    func populateFields() {
        if let event = event {
            titleTextField.text = event.title

            guard let startTime = dateManager.eventTimeStringToDate(dateString, event.startTime), let endTime = dateManager.eventTimeStringToDate(dateString, event.endTime) else { return }

            startTimePicker.date = startTime
            endTimePicker.date = endTime
            datePicker.date = startTime
        } else if let _ = dateString, let datePicked = dateManager.eventTimeStringToDate(dateString) {
            datePicker.date = datePicked
        }
    }



    func makeDate(year: Int, month: Int, day: Int, hr: Int, min: Int) -> Date {
        let calendar = Calendar.current
        let components = DateComponents(year: year, month: month, day: day, hour: hr, minute: min)

        return calendar.date(from: components)!
    }
    // MARK: - Table view data source

    //    override func numberOfSections(in tableView: UITableView) -> Int {
    //        // #warning Incomplete implementation, return the number of sections
    //        return 0
    //    }

    //    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        // #warning Incomplete implementation, return the number of rows
    //        return 0
    //    }

    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

     // Configure the cell...

     return cell
     }
     */

    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */

    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */

    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

     }
     */

    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */

}

extension CreateEventTableViewController: UITextFieldDelegate {}
