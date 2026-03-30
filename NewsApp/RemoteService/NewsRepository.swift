//
//  NewsRepository.swift
//  NewsApp
//
//  Created by Praveen on 30/03/26.
//

import Foundation
import SwiftData

final class NewsRepository: NewsRepositoryProtocol {
    private let apiService: APIServiceProtocol
    private let context: ModelContext
    
    init(apiService: APIServiceProtocol = APIService(), context: ModelContext) {
        self.apiService = apiService
        self.context = context
    }
    
    func getNews() async throws -> [Article] {
        return try await apiService.fetchNews()
    }
    
    // MARK: - Save to DB
    func saveArticles(_ articles: [Article]) {
        do {
            // Clear old data
            let fetch = FetchDescriptor<ArticleEntity>()
            let existing = try context.fetch(fetch)
            existing.forEach { context.delete($0) }
            
            // Insert new data
            for item in articles {
                let entity = ArticleEntity(
                    title: item.title,
                    description: item.description,
                    url: item.url,
                    urlToImage: item.urlToImage,
                    publishedAt: item.publishedAt
                )
                context.insert(entity)
            }
            
        } catch {
            print("DB Save Error:", error)
        }
    }
    
    // MARK: - Load from DB
    func loadArticles() -> [Article] {
        do {
            let fetch = FetchDescriptor<ArticleEntity>()
            let entities = try context.fetch(fetch)
            
            return entities.map {
                Article(
                    title: $0.title,
                    description: $0.desc,
                    url: $0.url,
                    urlToImage: $0.urlToImage,
                    publishedAt: $0.publishedAt
                )
            }
        } catch {
            print("DB Load Error:", error)
            return []
        }
    }
}
