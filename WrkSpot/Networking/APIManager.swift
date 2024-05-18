//
//  APIManager.swift
//  WrkSpot
//
//  Created by Sahil Garg on 18/05/24.
//

import UIKit

class APIManager {
    
    static let shared = APIManager()
    
    func request<T: Codable>(type: T.Type, endPointValues: (url: String, httpMethod: HttpMethod, parameters:[String:Any]?),  headers: [String : String]?, completionHandler: @escaping (Result<T, Error>) -> Void) {
        
        guard let url = URL(string: endPointValues.url) else {
            completionHandler(.failure(HTTPClientError.badURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endPointValues.httpMethod.rawValue
        request.allHTTPHeaderFields = headers
        
        if let parameters = endPointValues.parameters {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch {
                completionHandler(.failure(error))
                return
            }
        }
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request, completionHandler: { (data, _, error) -> Void in
            if let error = error {
                completionHandler(.failure(error))
                return
            }
            
            if let data = data {
                do {
                    completionHandler(.success(try JSONDecoder().decode(type, from: data)))
                } catch {
                    completionHandler(.failure(error))
                    return
                }
            }
        })
        
        dataTask.resume()
    }
    
}
