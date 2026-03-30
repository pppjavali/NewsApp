//
//  NewsViewModelTests.swift
//  NewsAppTests
//
//  Created by Praveen on 30/03/26.
//

import XCTest
@testable import NewsApp

@MainActor
final class NewsViewModelTests: XCTestCase {
    
    var viewModel: NewsViewModel!
    var mockRepo: MockNewsRepository!
    
    override func setUp() {
        super.setUp()
        mockRepo = MockNewsRepository()
        viewModel = NewsViewModel(repository: mockRepo)
    }
    
    override func tearDown() {
        viewModel = nil
        mockRepo = nil
        super.tearDown()
    }
    
    
    func test_fetchNews_success_updatesArticles() async {
        // Given
        let article = Article(title: "Test",
                              description: nil,
                              url: nil,
                              urlToImage: nil,
                              publishedAt: nil)
        mockRepo.mockArticles = [article]

        // When
        await viewModel.fetchNews()

        // Then
        XCTAssertEqual(viewModel.articles.count, 1)
        XCTAssertEqual(viewModel.articles.first?.title, "Test")
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func test_fetchNews_failure_setsError() async {
        // Given
        mockRepo.shouldFail = true

        // When
        await viewModel.fetchNews()

        // Then
        XCTAssertNotNil(viewModel.errorMessage)
    }
    
    func test_fetchNews_loadsFromCache_whenAvailable() async {
        // Given
        let cached = [
            Article(title: "Local", description: nil, url: nil, urlToImage: nil, publishedAt: nil)
        ]
        
        viewModel.setupPersistence(
            load: { cached },
            save: { _ in }
        )

        // When
        await viewModel.fetchNews()

        // Then
        XCTAssertEqual(viewModel.articles.first?.title, "Local")
    }
    
    func test_fetchNews_forceRefresh_ignoresCache() async {
        // Given
        let cached = [
            Article(title: "Local", description: nil, url: nil, urlToImage: nil, publishedAt: nil)
        ]
        
        let fresh = [
            Article(title: "API", description: nil, url: nil, urlToImage: nil, publishedAt: nil)
        ]
        
        mockRepo.mockArticles = fresh
        
        viewModel.setupPersistence(
            load: { cached },
            save: { _ in }
        )

        // When
        await viewModel.fetchNews(forceRefresh: true)

        // Then
        XCTAssertEqual(viewModel.articles.first?.title, "API")
    }
    
    func test_filteredArticles_filtersCorrectly() {
        // Given
        viewModel.articles = [
            Article(title: "Apple News", description: nil, url: nil, urlToImage: nil, publishedAt: nil),
            Article(title: "Google News", description: nil, url: nil, urlToImage: nil, publishedAt: nil)
        ]
        
        viewModel.searchText = "Apple"

        // When
        let result = viewModel.filteredArticles

        // Then
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.title, "Apple News")
    }
    
    func test_filteredArticles_emptySearch_returnsAll() {
        // Given
        viewModel.articles = [
            Article(title: "A", description: nil, url: nil, urlToImage: nil, publishedAt: nil),
            Article(title: "B", description: nil, url: nil, urlToImage: nil, publishedAt: nil)
        ]
        
        viewModel.searchText = ""

        // When
        let result = viewModel.filteredArticles

        // Then
        XCTAssertEqual(result.count, 2)
    }
}

final class MockNewsRepository: NewsRepositoryProtocol {
    var shouldFail = false
    var mockArticles: [Article] = []
    
    func getNews() async throws -> [Article] {
        if shouldFail {
            throw URLError(.badServerResponse)
        }
        return mockArticles
    }
}
