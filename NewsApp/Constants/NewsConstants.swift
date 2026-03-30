//
//  NewsConstants.swift
//  NewsApp
//
//  Created by Praveen on 27/03/26.
//
import Foundation

enum NewsConstants {
    static let someThingWentWrong = "Something went wrong"
    static let noResultsFound = "No results found"
    static let noArticles = "No articles"
    static let noNewsAvailable = "No news available right now."
    static let tryDifferentKey = "Try different keywords."
    static let navigationNewsTitle = "News"
    static let navigationDetailsTitle = "Article Details"
    static let placeholderValue = "Search News"
    static let publishedAt = "Published: %@"
    static let readFullArticle = "Read full article"
    
    enum Image {
        static let newsPaper = "newspaper"
        static let magnifyingGlass = "magnifyingglass"
        static let exclamationmarkTriangle = "exclamationmark.triangle"
        static let arrowClockWise = "arrow.clockwise"
        static let photo = "photo"
    }
    
    enum Spacing {
        static let spacing8 = 8.0
        static let spacing6 = 6.0
        static let spacing12 = 12.0
        static let height: CGFloat = 120
        static let width: CGFloat = 120
    }
    
    enum Service {
        static let kBase = "https://newsapi.org"
        static let kPath = "/v2/top-headlines?country=us"
        static let kAPIKey = "apiKey=3455a640fbdf4e88a7500c2201d0166c"
    }
    
    enum APIConstants {
        static let baseURL = "https://newsapi.org"
        static let apiKey = "3455a640fbdf4e88a7500c2201d0166c"
        
        enum Endpoints {
            static let topHeadlines = "/v2/top-headlines"
        }
        
        enum Query {
            static let country = "country"
            static let apiKey = "apiKey"
        }
    }
}
