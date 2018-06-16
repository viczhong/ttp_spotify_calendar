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

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
    }

}

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
//        let paddingSpace = 1 * (itemsPerRow + 1)
        let availableWidth = view.frame.width //- paddingSpace
        let widthPerItem = availableWidth / 7

        return CGSize(width: widthPerItem, height: widthPerItem)
    }
}
