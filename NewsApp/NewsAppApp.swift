//
//  NewsAppApp.swift
//  NewsApp
//
//  Created by Praveen on 27/03/26.
//

import SwiftUI
import SwiftData

@main
struct NewsAppApp: App {
    var body: some Scene {
        WindowGroup {
            NewsView(viewModel:
                        NewsViewModel(repository: NewsRepository(apiService: APIService())))
                .modelContainer(for: ArticleEntity.self)
        }
    }
}
