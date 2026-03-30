//
//  NewsListViewModel.swift
//  NewsApp
//
//  Created by Praveen on 27/03/26.
//

import Foundation
import Combine

@MainActor
final class NewsViewModel: ObservableObject {
    
    // MARK: - UI State
    @Published var articles: [Article] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchText: String = ""
    
    private let repository: NewsRepositoryProtocol
    
    init(repository: NewsRepositoryProtocol) {
        self.repository = repository
    }
    
    func fetchNews(forceRefresh: Bool = false) async {
        errorMessage = nil
        
        if !forceRefresh {
            // Load cached first
            let local = repository.loadArticles()
            if !local.isEmpty {
                articles = local
            } else {
                isLoading = true
            }
        } else {
            isLoading = true
        }
        
        do {
            let freshArticles = try await repository.getNews()
            if freshArticles != articles {
                articles = freshArticles
                repository.saveArticles(freshArticles)
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    var filteredArticles: [Article] {
        guard !searchText.isEmpty else { return articles }
        
        let lower = searchText.lowercased()
        
        return articles.filter {
            $0.title.lowercased().contains(lower)
        }
    }
}
