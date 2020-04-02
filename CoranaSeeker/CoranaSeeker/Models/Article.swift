//
//  Article.swift
//  CoranaSeeker
//
//  Created by Ashli Rankin on 4/1/20.
//  Copyright © 2020 Ashli Rankin. All rights reserved.
//

import Foundation

struct ArticleResult: Codable {
    let articles: [Article]
}

struct Article: Codable {
    let author: String?
    let title: String
    let description: String
    let url: URL
    let imageURL: URL
    
    private enum CodingKeys: String, CodingKey {
        case author, title, description, url
        case imageURL = "urlToImage"
    }
}
