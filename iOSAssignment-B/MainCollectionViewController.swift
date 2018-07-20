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
    
    fileprivate let sectionInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    var contentData = [JsonContentModel]()
    var inValidImagePresent = false as Bool
    
    //MARK: - OVERRIDE VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.refreshControl = refreshCollectionController
        collectionView?.backgroundColor = UIColor.gray
        collectionView?.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier:Constants.collectionViewReusableCellId)
    }
    
    //MARK: - OVERRIDE VIEWWILLAPPEAR
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpCollectionFlowLayout()
        fetchTheContentDetail()
    }
    //MARK: - UPDATE COLLECTIONVIEWFLOWLAYOUT PROPERTIES TO GET DYNAMIC HEIGHT OF UICOLLECTIONVIEWCELL
    func setUpCollectionFlowLayout(){
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 2
        layout.itemSize = UICollectionViewFlowLayoutAutomaticSize
        collectionView?.collectionViewLayout = layout
        
    }
    
    lazy var refreshCollectionController: UIRefreshControl = {
        let  refreshController =  UIRefreshControl()
        refreshController.tintColor = UIColor.black
        refreshController.addTarget(self, action: #selector(refreshContentData), for: .valueChanged)
        return refreshController
    }()
    
    //MARK: - UPDATE CONTENT DATA USING PULL TO REFRESH IN COLLECTIONVIEW
    @objc func refreshContentData(){
        fetchTheContentDetail()
        refreshCollectionController.endRefreshing()
    }
    //MARK: URL VALIDATION
    func isValidUrl (urlString: String?) -> Bool {
        guard let urlString = urlString else {return false}
        guard let url = NSURL(string: urlString) else {return false}
        if !UIApplication.shared.canOpenURL(url as URL) {return false}
        let regEx = Constants.urlRegex
        let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[regEx])
        return predicate.evaluate(with: urlString)
    }
    //MARK: - NOTIFY USER
    func showAlertDialog(_ messageTitle: String,message: String) {
        let alert = UIAlertController(title: messageTitle, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: Constants.okOptionText, style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: -  RETRIEVE DATA USING ALAMOFIRE AND CONTENT PARSING
    func fetchTheContentDetail(){
        if (Reachability.isConnectedToNetwork()){
            if(isValidUrl(urlString:Constants.jsonUrl)){
                Alamofire.request(Constants.jsonUrl).responseString(completionHandler: {(response) in
                    switch response.result{
                    case.success(let value):
                        let jsonContent =  JSON.init(parseJSON: value)
                        let topicTitle = jsonContent[Constants.titleKey]
                        self.contentData.removeAll()
                        self.inValidImagePresent = false;
                        for itemContent in jsonContent[Constants.rowsContentKey].arrayValue{
                            let item = JsonContentModel.init(json: itemContent) as JsonContentModel!
                            if(!(item?.title.isEmpty)!){
                                self.contentData.append(item!)
                            }
                        }
                        DispatchQueue.main.async {
                            self.navigationItem.title = topicTitle.stringValue
                            self.collectionView?.reloadData()
                        }
                    case.failure(let error):
                        DispatchQueue.main.async {
                            self.showAlertDialog(Constants.errorTitle, message: error.localizedDescription)
                        }
                    }
                })
            }else{
                self.showAlertDialog(Constants.imageInvalidUrlMessageTitle, message: Constants.invalidUrlMessageTitle)
            }
        }else{
            showAlertDialog(Constants.networkErrorMessageTitle, message: Constants.networkErrorMessage)
        }
    }
    
    
    // MARK: - DOWNLOAD REQUIRE IMAGES
    func getImageData(parameters: String, completionHandler: @escaping (Data?, NSError?) -> ()) {
        getImagesDownloaded(parameters,completionHandler: completionHandler)
    }
    
    //MARK: - GET IMAGES DATA USING ALAMOFIRE
    func getImagesDownloaded(_ imageUrl: String,completionHandler: @escaping (Data?, NSError?) -> ()){
        Alamofire.request(imageUrl)
            .validate().responseData(completionHandler:{data in
                switch data.result {
                case .success:
                    completionHandler(data.data, nil)
                    break
                case .failure(let error):
                    completionHandler(nil, error as NSError)
                    break
                }
            })
        
    }
}

extension MainCollectionViewController
{
    //MARK: RETURN COLLECTIONVIEW CELL
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier:Constants.collectionViewReusableCellId, for: indexPath) as! CustomCollectionViewCell
        collectionCell.itemName.text =  contentData[indexPath.row].title
        collectionCell.itemDescription.text = contentData[indexPath.row].description
        collectionCell.thumbNailImageView.image = #imageLiteral(resourceName: "PlaceHolder")
        if(isValidUrl(urlString: contentData[indexPath.row].imageHref)){
            getImageData(parameters: contentData[indexPath.row].imageHref) { responseObject, error in
                if((responseObject) != nil){
                    collectionCell.thumbNailImageView.image = UIImage(data: responseObject!)
                    if(collectionCell.thumbNailImageView.image == nil){
                        collectionCell.thumbNailImageView.image = #imageLiteral(resourceName: "PlaceHolder")
                    }
                }
            }
        }else{
            if(!self.inValidImagePresent){
                self.showAlertDialog(Constants.imageInvalidUrlMessageTitle, message: Constants.imageInvalidUrlMessage)
                self.inValidImagePresent = true
            }
        }
        return collectionCell
    }
    
    //MARK: RETURN NUMBEROFITEMS IN SECTION
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return contentData.count
    }
    
}




