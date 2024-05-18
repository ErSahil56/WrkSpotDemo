//
//  EndPoint.swift
//  WrkSpot
//
//  Created by Sahil Garg on 18/05/24.
//

enum HTTPClientError: Error {
    case badURL
}

enum HttpMethod:String{
    case get = "get"
    case post = "post"
}

enum EndPoints  {
    
    case getCountries
    
    /// Provide values related to URl
    /// - Returns: url : String
    /// httpMethod: HttpMethod object
    /// parameters: [String:Any] optional object
    func provideValues()->(url: String, httpMethod: HttpMethod, parameters:[String:Any]?) {
        
        switch self {
        case .getCountries:
            return (url: "\(ConfigURl.baseURL)countries/countries", httpMethod: .get, parameters: nil)
        }
        
    }
    
}
