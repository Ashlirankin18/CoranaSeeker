//
//  DataManager.swift
//  CoranaSeeker
//
//  Created by Ashli Rankin on 3/29/20.
//  Copyright © 2020 Ashli Rankin. All rights reserved.
//

import Foundation

class DataManager {
    
    private let networkHelper: NetworkHelper
    
    init(networkHelper: NetworkHelper) {
        self.networkHelper = networkHelper
    }
    
    func retrieveCountries(urlEndPointString: String, completion: @escaping (Result<[Country], AppError>) -> Void) {
        networkHelper.performDataTask(urlEndPoint: urlEndPointString) { (result) in
            switch result {
            case let .failure(error):
                print(error)
            case let .success(data):
                do {
                    let countries = try JSONDecoder().decode([Country].self, from: data)
                    completion(.success(countries))
                } catch{
                    completion(.failure(AppError.networkError(error)))
                }
            }
        }
    }
    
      func retrieveCountryStatistics(urlEndPointString: String, completion: @escaping (Result<[CountryCase], AppError>) -> Void) {
          networkHelper.performDataTask(urlEndPoint: urlEndPointString) { (result) in
              switch result {
              case let .failure(error):
                  print(error)
              case let .success(data):
                  do {
                      let countries = try JSONDecoder().decode([CountryCase].self, from: data)
                      completion(.success(countries))
                  } catch{
                      completion(.failure(AppError.networkError(error)))
                  }
              }
          }
      }
    
    func retrieveNewsArticles(urlEndPointString: String, completion: @escaping (Result<[Article], AppError>) -> Void) {
        networkHelper.performDataTask(urlEndPoint: urlEndPointString) { (result) in
            switch result {
            case let .failure(error):
                completion(.failure(AppError.networkError(error)))
            case let .success(data):
                do {
                    let articles = try JSONDecoder().decode(ArticleResult.self, from: data).articles
                    completion(.success(articles))
                } catch{
                    completion(.failure(AppError.networkError(error)))
                }
            }
        }
    }
}
