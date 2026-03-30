//
//  APIService.swift
//  NewsApp
//
//  Created by Praveen on 27/03/26.
//

import Foundation

final class NewsRepository: NewsRepositoryProtocol {
    private let apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
    
    func getNews() async throws -> [Article] {
        return try await apiService.fetchNews()
    }
}

final class URLSessionClient: NetworkClient {
    func data(from url: URL) async throws -> (Data, URLResponse) {
        try await URLSession.shared.data(from: url)
    }
}

final class APIService: APIServiceProtocol {
    
    private let client: NetworkClient
    
    init(client: NetworkClient = URLSessionClient()) {
        self.client = client
    }
    
    func fetchNews() async throws -> [Article] {
        guard let url = buildURL() else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await client.data(from: url)
        
        // Validate response
        guard let httpResponse = response as? HTTPURLResponse,
              200...299 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        
        let decoded = try JSONDecoder().decode(NewsResponse.self, from: data)
        return decoded.articles
    }
    
    // Helper URL builder
    private func buildURL() -> URL? {
        var components = URLComponents(string: NewsConstants.APIConstants.baseURL + NewsConstants.APIConstants.Endpoints.topHeadlines)
        
        components?.queryItems = [
            URLQueryItem(name: NewsConstants.APIConstants.Query.country, value: "us"),
            URLQueryItem(name: NewsConstants.APIConstants.Query.apiKey, value: NewsConstants.APIConstants.apiKey)
        ]
        
        return components?.url
    }
}
