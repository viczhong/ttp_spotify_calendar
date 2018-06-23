//
//  CalendarViewController.swift
//  CalendarFrontEnd
//
//  Created by Victor Zhong on 6/16/18.
//  Copyright © 2018 Victor Zhong. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController {

    @IBOutlet weak var datePicker: UIPickerView!
    @IBOutlet weak var collectionView: UICollectionView!

    var dateManager: DateManager!
    var dateArray = [DateEntry]() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        dateManager = DateManager(APIRequestManager())
        collectionView.delegate = self
        collectionView.dataSource = self
        datePicker.delegate = self
        datePicker.dataSource = self

        setDatePicker()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        dateManager.setUpMonth(datePicker.selectedRow(inComponent: 0) + 1, dateManager.yearArray[datePicker.selectedRow(inComponent: 1)]) { [weak self] dates in
            self?.dateArray = dates
            self?.navigationItem.title = self?.dateManager.getHeaderString()
            self?.dateManager.getEvents { [weak self] (datesWithEntries, _) in
                guard let datesWithEntries = datesWithEntries else { return }
                self?.dateArray = datesWithEntries
            }
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }

        var rotation: ScreenRotation

        if UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation) {
            rotation = .landscape
        } else {
            rotation = .portrait
        }

        dateManager.rotated(rotation) { [unowned self] in
            self.dateManager.setUpMonth(self.datePicker.selectedRow(inComponent: 0) + 1, self.dateManager.yearArray[self.datePicker.selectedRow(inComponent: 1)]) { dateArray in
                self.dateArray = dateArray
            }
        }

        flowLayout.invalidateLayout()
    }

    @IBAction func datePickerDateChanged(_ sender: Any) {
        dateManager.setUpMonth(datePicker.selectedRow(inComponent: 0) + 1, dateManager.yearArray[datePicker.selectedRow(inComponent: 1)]) {[weak self] dateArray in
            self?.dateArray = dateArray

            DispatchQueue.main.async {
                self?.navigationItem.title = self?.dateManager.getHeaderString()
                self?.collectionView.reloadData()
            }
        }
    }

    func setDatePicker() {
        let today = Date()

        let month = dateManager.calender.component(.month, from: today) - 1
        let yearToday = dateManager.calender.component(.year, from: today)

        let year = dateManager.yearArray.index(of: yearToday)


        datePicker.selectRow(month, inComponent: 0, animated: true)
        datePicker.selectRow(year!, inComponent: 1, animated: true)
    }
}

// MARK: - Collection View Extensions
extension CalendarViewController: UICollectionViewDelegate {

    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        if let tappedCell = sender as? DateCollectionViewCell,
            let indexPathAtCell = collectionView.indexPath(for: tappedCell),
            dateArray[indexPathAtCell.row].placeholder  {
            return false
        }

        return true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "dateSegue",
            let eventsTVC = segue.destination as? DateEventTableViewController,
            let tappedCell = sender as? DateCollectionViewCell,
            let indexPathAtCell = collectionView.indexPath(for: tappedCell) {
            let dateAtCell = dateArray[indexPathAtCell.row]

            guard let month = dateAtCell.month, let date = dateAtCell.date, let year = dateAtCell.year else { return }
            eventsTVC.navigationItem.title = "\(month) \(date), \(year)"
            eventsTVC.dateStringLong = dateAtCell.dateStringLong
            eventsTVC.dateManager = dateManager
            eventsTVC.day = date
            eventsTVC.year = year
            
            if let events = dateArray[indexPathAtCell.row].events {
                eventsTVC.events = events
                 print(events.count)
            }
        }
    }
}

extension CalendarViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dateArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dateCell", for: indexPath) as! DateCollectionViewCell
        let dateAtCell = dateArray[indexPath.row]
        let eventLines = [cell.eventFirstLine, cell.eventSecondLine, cell.eventThirdLine, cell.eventFourthLine]

        var dateString = String()

        cell.imageView.image = nil
        cell.dateLabel.textColor = .black

        _ = eventLines.map { $0?.text = "" }

        if dateManager.screenRotation == .landscape {
            dateString = dateAtCell.dateStringLong

            if let events = dateAtCell.events {
                for x in 0..<events.count {
                    guard x != 3 else {
                        eventLines[x]?.text = "+ \(events.count - x) more event(s)"
                        break
                    }

                    eventLines[x]?.text = "\(events[x].startTime) - \(events[x].title)"
                }
            }
        }

        if dateManager.screenRotation == .portrait {
            dateString = dateAtCell.dateStringShort

            if let _ = dateAtCell.events {
                cell.imageView.image = UIImage(named: "events")
                cell.setNeedsLayout()
            }
        }

        if dateAtCell.placeholder {
            cell.dateLabel.textColor = .gray
        }

        cell.dateLabel.text = dateString
        cell.layer.borderWidth = 1

        return cell
    }
}

extension CalendarViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthPerItem = view.frame.width / 7

        return CGSize(width: widthPerItem, height: widthPerItem)
    }
}

extension CalendarViewController: UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        dateManager.setUpMonth(datePicker.selectedRow(inComponent: 0) + 1, dateManager.yearArray[datePicker.selectedRow(inComponent: 1)]) { [weak self] (dates) in
            self?.dateArray = dates
            self?.navigationItem.title = self?.dateManager.getHeaderString()
        }
    }
}

extension CalendarViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return dateManager.months.count
        } else {
            return dateManager.yearArray.count
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return dateManager.months[row]
        } else {
            return String(dateManager.yearArray[row])
        }
    }

}


