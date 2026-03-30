//
//  Article.swift
//  NewsApp
//
//  Created by Praveen on 27/03/26.
//

import Foundation
import SwiftData

struct NewsResponse: Codable {
    let articles: [Article]
}

struct Article: Codable, Identifiable, Equatable {
    let id = UUID()
    let title: String
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case title, description, url, urlToImage, publishedAt
    }
}

@Model
class ArticleEntity {
    var title: String
    var desc: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: String?

    init(title: String, description: String?, url: String?, urlToImage: String?, publishedAt: String?) {
        self.title = title
        self.desc = description
        self.url = url
        self.urlToImage = urlToImage
        self.publishedAt = publishedAt
    }
}
