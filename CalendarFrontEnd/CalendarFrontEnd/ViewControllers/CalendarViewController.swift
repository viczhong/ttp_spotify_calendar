//
//  CalendarViewController.swift
//  CalendarFrontEnd
//
//  Created by Victor Zhong on 6/16/18.
//  Copyright © 2018 Victor Zhong. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController {

    var dateManager: DateManager!
    var dateArray = [String]()

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        dateManager = DateManager(year: 2018)

        collectionView.delegate = self
        collectionView.dataSource = self
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }

        // TODO: Account for screen rotation

//        if UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation) {
//            datePicker.isHidden = true
//        } else {
//            datePicker.layer.isHidden = false
//        }

        flowLayout.invalidateLayout()
    }
}

// MARK: - Collection View Extensions
extension CalendarViewController: UICollectionViewDelegate {}

extension CalendarViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dateCell", for: indexPath)

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
