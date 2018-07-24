//
//  Services.swift
//  iOSAssignment-B
//
//  Created by Villasini Patel on 22/07/18.
//  Copyright © 2018 vils. All rights reserved.
//

import Foundation
import Alamofire
import UIKit
public class Services {
    
//MARK - IMAGES DOWNLOAD FROM ALAMOFIRE
  public  class func getImagesDownloaded(_ imageUrl: String,completionHandler: @escaping (Data?, NSError?) -> ()){
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
    //MARK - FETCH CONTENT DETAIL FROM SERVER
   public class func fetchContentDetail(completionHandler: @escaping (String?, NSError?) -> ()){
        Alamofire.request(Constants.jsonUrl)
            .validate().responseString(completionHandler:{response in
                switch response.result {
                case .success:
                    completionHandler(response.value, nil)
                    break
                case .failure(let error):
                    completionHandler(nil, error as NSError)
                    break
                }
            })
    }
    
    //MARK: URL VALIDATION
  public class func isValidUrl (urlString: String?) -> Bool {
        guard let urlString = urlString else {return false}
        guard let url = NSURL(string: urlString) else {return false}
        if !UIApplication.shared.canOpenURL(url as URL) {return false}
        let regEx = Constants.urlRegex
        let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[regEx])
        return predicate.evaluate(with: urlString)
    }
    
    
}

