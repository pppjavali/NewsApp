//
//  NewsAPITests.swift
//  NewsAppTests
//
//  Created by Praveen on 30/03/26.
//

import XCTest
@testable import NewsApp

final class NewsAPIServiceTests: XCTestCase {
    func test_fetchNews_success_returnsArticles() async throws {
        // Given
        let json = """
            {
              "articles": [
                {
                  "title": "Test News",
                  "description": "Desc",
                  "url": "https://example.com",
                  "urlToImage": null,
                  "publishedAt": "2024-03-29T12:00:00Z"
                }
              ]
            }
            """
        
        let mockClient = MockNetworkClient()
        mockClient.mockData = json.data(using: .utf8)
        
        let service = await APIService(client: mockClient)
        
        // When
        let result = try await service.fetchNews()
        
        // Then
        XCTAssertEqual(result.count, 1)
        let firstTitle = await MainActor.run { result.first?.title }
        XCTAssertEqual(firstTitle, "Test News")
        let description = await MainActor.run { result.first?.description }
        XCTAssertEqual(description, "Desc")
    }
    
    func test_fetchNews_failure_badStatusCode_throwsError() async {
        // Given
        let mockClient = MockNetworkClient()
        mockClient.statusCode = 500
        
        let service = await APIService(client: mockClient)
        
        // When / Then
        do {
            _ = try await service.fetchNews()
            XCTFail("Expected badServerResponse error")
        } catch {
            XCTAssertTrue(true)
        }
    }
    
    func test_fetchNews_failure_invalidJSON_throwsDecodingError() async {
        // Given
        let mockClient = MockNetworkClient()
        mockClient.mockData = Data("invalid json".utf8)
        
        let service = await APIService(client: mockClient)
        
        // When / Then
        do {
            _ = try await service.fetchNews()
            XCTFail("Expected decoding error")
        } catch {
            XCTAssertTrue(true)
        }
    }
    
    func test_fetchNews_emptyArticles_returnsEmptyArray() async throws {
        // Given
        let json = """
            {
              "articles": []
            }
            """
        
        let mockClient = MockNetworkClient()
        mockClient.mockData = json.data(using: .utf8)
        
        let service = await APIService(client: mockClient)
        
        // When
        let result = try await service.fetchNews()
        
        // Then
        XCTAssertTrue(result.isEmpty)
    }
}

// MARK: - Mock Network Client

final class MockNetworkClient: NetworkClient {
    
    var mockData: Data?
    var statusCode: Int = 200
    
    func data(from url: URL) async throws -> (Data, URLResponse) {
        let response = HTTPURLResponse(
            url: url,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        )!
        
        return (mockData ?? Data(), response)
    }
}
