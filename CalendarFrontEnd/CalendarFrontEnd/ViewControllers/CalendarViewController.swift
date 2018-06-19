//
//  CalendarViewController.swift
//  CalendarFrontEnd
//
//  Created by Victor Zhong on 6/16/18.
//  Copyright © 2018 Victor Zhong. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var collectionView: UICollectionView!

    var dateManager: DateManager!
    var dateArray = [DateEntry]() {
        didSet {
            collectionView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        dateManager = DateManager()

        dateManager.setUpMonth(datePicker.date) { [weak self] dateArray in
            self?.dateArray = dateArray
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self

        navigationItem.title = dateManager.getHeaderString()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        dateManager.setUpMonth(datePicker.date, { [weak self] dateArray in
            self?.dateArray = dateArray
        })
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

        dateManager.rotated(rotation) { [weak self] in
            guard let date = self?.datePicker.date else { return }
            self?.dateManager.setUpMonth(date, { dateArray in
                self?.dateArray = dateArray
            })
        }

        flowLayout.invalidateLayout()
    }

    @IBAction func datePickerDateChanged(_ sender: Any) {
        dateManager.setUpMonth(datePicker.date) {[weak self] dateArray in
            self?.dateArray = dateArray

            DispatchQueue.main.async {
                self?.navigationItem.title = self?.dateManager.getHeaderString()
                self?.collectionView.reloadData()
            }
        }
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
                        eventLines[x]?.text = "+ \(events.count - x + 1) more event(s)"
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


