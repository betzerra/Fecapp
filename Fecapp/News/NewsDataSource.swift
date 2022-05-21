//
//  NewsDataSource.swift
//  Fecapp
//
//  Created by Ezequiel Becerra on 21/05/2022.
//

import Combine
import Foundation
import Pluma

class NewsDataSource {
    let baseURL = URL(string: "https://nyc3.digitaloceanspaces.com")!
    let pluma: Pluma

    @Published var news: [NewsSummary]?

    var cancellables = [AnyCancellable]()

    init() {
        pluma = Pluma(baseURL: baseURL, decoder: nil)

        Task {
            do {
                try await fetchNews()
            } catch {
                LogService.logError(error)
            }
        }
    }

    func fetchNews() async throws {
        LogService.debug("News list request started")

        guard let news: [NewsSummary] = try await pluma.request(
            method: .GET,
            path: "betzerra/feca/summary.json",
            params: nil
        ) else {
            LogService.warning("Didn't get any shops after request")
            return
        }

        self.news = news
        LogService.debug("News list request finished")
    }

    func fetchMarkdownPost(url: URL) async throws -> String {
        LogService.debug("News post request started")

        let data = try await URLSession.shared.data(from: url).0

        LogService.debug("News post request finished")
        return String(decoding: data, as: UTF8.self)
    }
}
