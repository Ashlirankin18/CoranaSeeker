//
//  NetworkHelper.swift
//  CoranaSeeker
//
//  Created by Ashli Rankin on 3/29/20.
//  Copyright © 2020 Ashli Rankin. All rights reserved.
//

import Foundation

/// Manages networking tasks
final class NetworkHelper {
    
    typealias Handle = (Result<Data, AppError>) -> Void
    
    /// Performs the dataTask
    /// - Parameters:
    ///   - urlEndPoint: The endpoint string used to retrieve data
    ///   - completionHandler: Handles the result of asynchronous call.
    func performDataTask(urlEndPoint: String, completionHandler: @escaping Handle) {
        guard let url = URL(string: urlEndPoint) else {
            completionHandler(.failure(.badURL("Unsupported URL")))
            return
        }
        DispatchQueue.main.async {
            
            let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
                
                if let error = error {
                    completionHandler(.failure(.networkError(error)))
                }
                guard let httpResponse = response as? HTTPURLResponse,
                    (200...299).contains(httpResponse.statusCode)
                    else {
                        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -999
                        completionHandler(.failure(.badStatusCode(statusCode.description)))
                        return
                }
                if let data = data {
                    completionHandler(.success(data))
                }
            }
             dataTask.resume()
        }
    }
}
