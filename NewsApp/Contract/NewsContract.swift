//
//  NewsContract.swift
//  NewsApp
//
//  Created by Praveen on 27/03/26.
//

import Foundation

protocol APIServiceProtocol {
    func fetchNews() async throws -> [Article]
}

protocol NewsRepositoryProtocol {
    func getNews() async throws -> [Article]
}

protocol NetworkClient {
    func data(from url: URL) async throws -> (Data, URLResponse)
}
