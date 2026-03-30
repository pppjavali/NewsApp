//
//  ContentView.swift
//  NewsApp
//
//  Created by Praveen on 27/03/26.
//

import SwiftUI
import Combine
import SwiftData

struct NewsView: View {
    @ObservedObject var viewModel: NewsViewModel
    @Environment(\.modelContext) private var context
    @Query private var savedArticles: [ArticleEntity]
    
    @State private var didSetup = false
    
    var body: some View {
        NavigationStack {
            contentView
                .navigationTitle(NewsConstants.navigationNewsTitle)
                .searchable(
                    text: $viewModel.searchText,
                    placement: .navigationBarDrawer(displayMode: .always)
                )
                .toolbar { refreshButton }
                .onAppear(perform: setup)
        }
    }
}
// MARK: - Private Methods
private extension NewsView {
    func setup() {
        guard !didSetup else { return }
        didSetup = true
        viewModel.setupPersistence(
            load: { loadFromLocal() },
            save: { saveArticles($0) }
        )
        
        Task {
            await viewModel.fetchNews()
        }
    }
}

// MARK: - Database Related
private extension NewsView {
    func saveArticles(_ articles: [Article]) {
        // Clear old data
        savedArticles.forEach { context.delete($0) }
        
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
    }
    
    func loadFromLocal() -> [Article] {
        return savedArticles.map {
            Article(
                title: $0.title,
                description: $0.desc,
                url: $0.url,
                urlToImage: $0.urlToImage,
                publishedAt: $0.publishedAt
            )
        }
    }
}

// MARK: - Private Views
private extension NewsView {
    @ViewBuilder
    var contentView: some View {
        if viewModel.isLoading {
            ProgressView()
            
        } else if let errorMessage = viewModel.errorMessage {
            errorView(message: errorMessage)
            
        } else if viewModel.filteredArticles.isEmpty {
            emptyView
            
        } else {
            listView
        }
    }
    
    func errorView(message: String) -> some View {
        ContentUnavailableView(
            NewsConstants.someThingWentWrong,
            systemImage: NewsConstants.Image.exclamationmarkTriangle,
            description: Text(message)
        )
    }
    
    var emptyView: some View {
        if viewModel.searchText.isEmpty {
            ContentUnavailableView(
                NewsConstants.noArticles,
                systemImage: NewsConstants.Image.newsPaper,
                description: Text(NewsConstants.noNewsAvailable)
            )
        } else {
            ContentUnavailableView(
                NewsConstants.noResultsFound,
                systemImage: NewsConstants.Image.magnifyingGlass,
                description: Text(NewsConstants.tryDifferentKey)
            )
        }
    }
    
    var listView: some View {
        List(viewModel.filteredArticles) { article in
            NavigationLink {
                NewsArticleDetailView(article: article)
            } label: {
                NewsArticleRowView(article: article)
            }
            .buttonStyle(.plain)
            .listStyle(.plain)
        }
        .tint(.clear)
    }
    
    var refreshButton: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                Task {
                    await viewModel.fetchNews(forceRefresh: true)
                }
            } label: {
                Image(systemName: NewsConstants.Image.arrowClockWise)
            }
        }
    }
}

#Preview {
    NewsView(viewModel: NewsViewModel(repository: NewsRepository(apiService: APIService())))
}
