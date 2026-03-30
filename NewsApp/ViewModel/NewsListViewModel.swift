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
    @Published var articles: [Article] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchText: String = ""
    
    var loadLocal: (() -> [Article])?
    var saveLocal: (([Article]) -> Void)?
    
    private let repository: NewsRepositoryProtocol
    
    init(repository: NewsRepositoryProtocol) {
        self.repository = repository
    }
    
    func fetchNews(forceRefresh: Bool = false) async {
        errorMessage = nil
        
        // Load cached first
        if !forceRefresh, let local = loadLocal?(), !local.isEmpty {
            articles = local
            if !articles.isEmpty { return } // Avoid API if already have data
        } else {
            isLoading = true
        }
        
        do {
            let freshArticle = try await repository.getNews()
            if freshArticle != articles {
                articles = freshArticle
                saveLocal?(freshArticle)
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
    
    func setupPersistence(
        load: @escaping () -> [Article],
        save: @escaping ([Article]) -> Void
    ) {
        self.loadLocal = load
        self.saveLocal = save
    }
}
