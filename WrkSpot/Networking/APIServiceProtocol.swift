//
//  APIServiceProtocol.swift
//  WrkSpot
//
//  Created by Sahil Garg on 18/05/24.
//

import Foundation

protocol APIServiceProtocol {
    func fetchCountries(completion: @escaping ([CountryModel]?, String?) -> Void)
}

final class APIService: APIServiceProtocol {
    
    func fetchCountries(completion: @escaping ([CountryModel]?, String?) -> Void) {
        APIManager.shared.request(type: [CountryModel].self, endPointValues: EndPoints.getCountries.provideValues(),headers: [:]) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let countries):
                    completion(countries, nil)
                case .failure(let error):
                    completion(nil, error.localizedDescription)
                }
            }
        }
    }
    
}
