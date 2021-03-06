//
//  CreateEventTableViewController.swift
//  CalendarFrontEnd
//
//  Created by Victor Zhong on 6/17/18.
//  Copyright © 2018 Victor Zhong. All rights reserved.
//

import UIKit

protocol CreateEventTableViewControllerDelegate {
    func createdEvent(_ event: Event)
    func needsRefresh()
}

class CreateEventTableViewController: UITableViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var startTimePicker: UIDatePicker!
    @IBOutlet weak var endTimePicker: UIDatePicker!
    @IBOutlet weak var datePicker: UIDatePicker!

    var delegate: CreateEventTableViewControllerDelegate!
    var event: Event?
    var dateString: String?
    var dateManager: DateManager!
    var apiClient: APIRequestManager!

    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))

        self.view.addGestureRecognizer(tap)
        apiClient = dateManager.apiClient
        titleTextField.delegate = self

        populateFields()
    }

    @objc func dismissKeyboard() {
        titleTextField.resignFirstResponder()
    }

    @IBAction func finishButtonTapped(_ sender: Any) {
        createEntry()
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

    func alertUser(_ message: String?) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    func createEntry() {
        guard titleTextField.text != "" else { alertUser("Please enter a title!"); return }
        guard startTimePicker.date <= endTimePicker.date else { alertUser("Start time cannot occur after end time!"); return }

        dateManager.performEventDataTask(titleTextField.text!, startTimeDate: startTimePicker.date, endTimeDate: endTimePicker.date, date: datePicker.date, event: event) { [weak self] event in
            DispatchQueue.main.async {
                if let event = event {
                    self?.delegate.createdEvent(event)
                } else {
                    self?.delegate.needsRefresh()
                }
            }
        }
    }
}

extension CreateEventTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)

        return false
    }
}
