//
//  NewsRepositoryTests.swift
//  NewsAppTests
//
//  Created by Praveen on 30/03/26.
//

import XCTest
import SwiftData
@testable import NewsApp

@MainActor
final class NewsRepositoryTests: XCTestCase {

    var repository: NewsRepository!
    var mockService: MockAPIService!
    var container: ModelContainer!
    var context: ModelContext!

    // MARK: - Setup
    override func setUp() {
        super.setUp()
        
        mockService = MockAPIService()
        
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try! ModelContainer(
            for: ArticleEntity.self,
            configurations: config
        )
        
        context = container.mainContext
        
        repository = NewsRepository(
            apiService: mockService,
            context: context
        )
    }

    // MARK: - API Tests
    func test_getNews_success() async throws {
        // Given
        let article = Article(
            title: "Repo",
            description: nil,
            url: nil,
            urlToImage: nil,
            publishedAt: nil
        )
        mockService.mockArticles = [article]

        // When
        let result = try await repository.getNews()

        // Then
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.title, "Repo")
    }

    func test_getNews_failure() async {
        // Given
        mockService.shouldFail = true

        // When / Then
        do {
            _ = try await repository.getNews()
            XCTFail("Expected error")
        } catch {
            XCTAssertTrue(true)
        }
    }

    // MARK: - DB Tests
    
    func test_saveArticles_and_loadArticles() {
        // Given
        let articles = [
            Article(
                title: "A1",
                description: "Desc1",
                url: "url1",
                urlToImage: nil,
                publishedAt: nil
            )
        ]

        // When
        repository.saveArticles(articles)
        let loaded = repository.loadArticles()

        // Then
        XCTAssertEqual(loaded.count, 1)
        XCTAssertEqual(loaded.first?.title, "A1")
    }

    func test_saveArticles_replacesOldData() {
        // Given
        let oldArticles = [
            Article(title: "Old", description: nil, url: nil, urlToImage: nil, publishedAt: nil)
        ]
        
        let newArticles = [
            Article(title: "New", description: nil, url: nil, urlToImage: nil, publishedAt: nil)
        ]

        // When
        repository.saveArticles(oldArticles)
        repository.saveArticles(newArticles)
        
        let loaded = repository.loadArticles()

        // Then
        XCTAssertEqual(loaded.count, 1)
        XCTAssertEqual(loaded.first?.title, "New")
    }

    func test_loadArticles_emptyDatabase() {
        // When
        let loaded = repository.loadArticles()

        // Then
        XCTAssertTrue(loaded.isEmpty)
    }
}

final class MockAPIService: APIServiceProtocol {
    
    var shouldFail = false
    var mockArticles: [Article] = []
    
    func fetchNews() async throws -> [Article] {
        if shouldFail {
            throw URLError(.badServerResponse)
        }
        return mockArticles
    }
}
