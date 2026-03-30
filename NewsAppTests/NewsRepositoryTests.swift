//
//  NewsRepositoryTests.swift
//  NewsAppTests
//
//  Created by Praveen on 30/03/26.
//

import XCTest
@testable import NewsApp

final class NewsRepositoryTests: XCTestCase {

    var repository: NewsRepository!
    var mockService: MockAPIService!

    override func setUp() {
        super.setUp()
        mockService = MockAPIService()
        repository = NewsRepository(apiService: mockService)
    }

    func test_getNews_success() async throws {
        // Given
        let article = Article(title: "Repo", description: nil, url: nil, urlToImage: nil, publishedAt: nil)
        mockService.mockArticles = [article]

        // When
        let result = try await repository.getNews()

        // Then
        XCTAssertEqual(result.count, 1)
        let firstTitle = await MainActor.run { result.first?.title }
        XCTAssertEqual(firstTitle, "Repo")
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
