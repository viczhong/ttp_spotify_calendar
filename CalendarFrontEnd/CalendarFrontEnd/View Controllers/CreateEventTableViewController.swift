//
//  CreateEventTableViewController.swift
//  CalendarFrontEnd
//
//  Created by Victor Zhong on 6/17/18.
//  Copyright © 2018 Victor Zhong. All rights reserved.
//

import UIKit

protocol EventManipulationDelegate {
    func createdEvent(_ event: Event)
}

class CreateEventTableViewController: UITableViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var startTimePicker: UIDatePicker!
    @IBOutlet weak var endTimePicker: UIDatePicker!
    @IBOutlet weak var datePicker: UIDatePicker!

    var delegate: EventManipulationDelegate!
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
        guard titleTextField.text != "" else { alertUser("Please enter a title!"); return }
        guard startTimePicker.date < endTimePicker.date else { alertUser("Start time cannot be after end time!"); return }

        dateManager.performEventDataTask(titleTextField.text!, startTimeDate: startTimePicker.date, endTimeDate: endTimePicker.date, date: datePicker.date, event: event) { [weak self] event in
            guard let event = event else { return }
            self?.delegate.createdEvent(event)
//            self.navigationController?.popViewController(animated: true)
            
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

    func alertUser(_ message: String?) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
