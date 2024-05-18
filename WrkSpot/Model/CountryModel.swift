//
//  CountryModel.swift
//  WrkSpot
//
//  Created by Sahil Garg on 18/05/24.
//

import UIKit

struct CountryModel : Codable {

    let abbreviation, capital, currency, name: String?
    let phone: String?
    let population: Int?
    let media: MediaModel?
    let id: Int?
    
}

struct MediaModel : Codable {
    let flag, emblem, orthographic: String?
}
