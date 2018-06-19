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
}
