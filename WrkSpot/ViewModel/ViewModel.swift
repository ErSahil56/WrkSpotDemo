//
//  ViewModel.swift
//  WrkSpot
//
//  Created by Sahil Garg on 18/05/24.
//

import UIKit

extension Dictionary where Value: Equatable {
    func someKey(forValue val: Value) -> Key? {
        return first(where: { $1 == val })?.key
    }
}

enum FilterCase {
    case OneM, FiveM, tenM
    
    func filter() -> Int {
        switch self {
        case .OneM:
            return 1000000
        case .FiveM:
            return 5000000
        case .tenM:
            return 10000000
        }
    }
}

enum FilterType {
    case search, filter
}

class ViewModel {

    private var apiService : APIService!
        
    private(set) var tempCountriesData : [CountryModel]? {
        didSet {
            self.bindViewModelToTableView()
        }
    }
    
    var seachedCountriesData = [CountryModel]()
    var filteredCountriesData = [CountryModel]()
    
    private(set) var timerValue : String? {
        didSet {
            self.bindViewModelToDataLabel(timerValue ?? "")
        }
    }
    
    var countries = [CountryModel]()
    
    var bindViewModelToTableView : (() -> ()) = {}
    var bindViewModelToDataLabel : ((String) -> ()) = {_ in }
    
    var getTimeZoneName: String {
        if let key = TimeZone.abbreviationDictionary.someKey(forValue: TimeZone.current.identifier) {
            return key
        }
        return ""
    }
    
    /// Init view model for param
    /// - Parameter service: API Service Object
    init(service: APIService) {
        self.apiService = service
        self.updateTimer()
        self.callFuncToGetCountriesData()
    }
    
    /// Update timer for date label
    func updateTimer() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM hh:mm a"
            self.timerValue = dateFormatter.string(from: Date.now) + " \(self.getTimeZoneName)"
        }
    }
    
    /// Call API function to get countries
    func callFuncToGetCountriesData() {
        self.apiService.fetchCountries { [weak self] model, errorString in
            guard let self = self else { return }
            if let countries = model {
                self.countries = countries
                self.tempCountriesData = self.countries
            }
        }
    }
    
    /// Clear countries Seach
    /// - Parameter type: FilterType object
    func clearCountriesSearch(type: FilterType) {
        var countryToSearchFrom = countries
        switch type {
        case .filter:
            filteredCountriesData.removeAll()
            if !seachedCountriesData.isEmpty {
                countryToSearchFrom = seachedCountriesData
            }
            tempCountriesData = countryToSearchFrom
        case .search:
            seachedCountriesData.removeAll()
            if !filteredCountriesData.isEmpty {
                countryToSearchFrom = filteredCountriesData
            }
            tempCountriesData = countryToSearchFrom
        }
    }
    
    /// Search Countries By Name
    /// - Parameter searchText: String
    func searchCountriesByName(_ searchText: String?) {
        var countryToSearchFrom = countries
        if !filteredCountriesData.isEmpty {
            countryToSearchFrom = filteredCountriesData
        }
        if let searchString = searchText, !searchString.isEmpty {
            seachedCountriesData = countryToSearchFrom.filter({ $0.name?.localizedCaseInsensitiveContains(searchString) ?? false })
            tempCountriesData = seachedCountriesData
        } else {
            seachedCountriesData = countryToSearchFrom
            tempCountriesData = seachedCountriesData
        }
    }
    
    /// Filter Country based on Population
    /// - Parameter filter: FilterCase object
    func filterCountriesBasedOnPopulation(_ filter: FilterCase) {
        var countryToSearchFrom = countries
        if !seachedCountriesData.isEmpty {
            countryToSearchFrom = seachedCountriesData
        }
        filteredCountriesData = countryToSearchFrom.filter({ ($0.population ?? 0) < filter.filter() })
        tempCountriesData = filteredCountriesData
    }
    
}
