//
//  MainCollectionViewController.swift
//  iOSAssignment-B
//
//  Created by Villasini Patel on 14/07/18.
//  Copyright © 2018 vils. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MainCollectionViewController: UICollectionViewController {
    
    let reusableCellId = "CollectionViewCell"
    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        collectionView?.backgroundColor = UIColor.red
        collectionView?.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier:reusableCellId)
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        FetchTheContentDetail()
        
    }
    
    func FetchTheContentDetail(){
        Alamofire.request(Constants.JSONURL).responseString(completionHandler: {(response) in
            switch response.result{
            case.success(let value):
              let jsonContent = JSON(value)
                print(jsonContent)
            case.failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier:reusableCellId, for: indexPath)
        return collectionCell
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 30)
    }
    
}



