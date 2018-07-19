//
//  Constants.swift
//  iOSAssignment-B
//
//  Created by Villasini Patel on 14/07/18.
//  Copyright © 2018 vils. All rights reserved.
//

import Foundation
class Constants {
    // MARK: List of Constants
    static let jsonUrl = "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json"
    static let imagePlaceHolder = "PlaceHolder"
    static let networkErrorMessage = "Make sure your device is connected to the internet."
    static let networkErrorMessageTitle = "No Internet Connection"
    static let imageInvalidUrlMessage = "Due to invalid images path,Few images are not getting display."
    static let imageInvalidUrlMessageTitle = "Message"
    static let collectionViewReusableCellId = "collectionResuableCell"
    static let okOptionText = "Ok"
    static let titleKey = "title"
    static let itemDescKey = "description"
    static let itemImageRef = "imageHref"
    static let rowsContentKey = "rows"
    static let urlRegex = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
    static let errorTitle = "Error"
}
