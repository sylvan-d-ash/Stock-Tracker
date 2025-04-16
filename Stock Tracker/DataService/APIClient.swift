//
//  APIClient.swift
//  Stock Tracker
//
//  Created by Sylvan  on 16/04/2025.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case decodingFailed
    case noData
    case unknown
}

protocol APIEndpoint {
    var path: String { get }
    var parameters: [String: Any]? { get }
}

protocol APIClient {
    func fetch<T: Decodable>(_ endpoint: APIEndpoint) async -> Result<T, Error>
}

final class URLSessionaAPIClient: APIClient {
    private let baseURLString = "https://apidojo-yahoo-finance-v1.p.rapidapi.com"

    private static var apiKey: String {
        guard let apiKey = ProcessInfo.processInfo.environment["API_KEY"] else {
            fatalError("API_KEY environment variable not set")
        }
        return apiKey
    }

    func fetch<T>(_ endpoint: APIEndpoint) async -> Result<T, any Error> where T : Decodable {
        guard var url = URL(string: baseURLString) else {
            return .failure(APIError.invalidURL)
        }
        url = url.appending(path: endpoint.path)

        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            return .failure(APIError.invalidURL)
        }
        
        if let parameters = endpoint.parameters {
            components.queryItems = parameters.map { URLQueryItem(name: $0, value: "\($1)") }
        }
        
        guard let url = components.url else {
            return .failure(APIError.invalidURL)
        }

        let headers = [
            "x-rapidapi-key": Self.apiKey,
            "x-rapidapi-host": "apidojo-yahoo-finance-v1.p.rapidapi.com",
            "Content-Type": "application/json",
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                return .failure(APIError.unknown)
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                return .failure(APIError.unknown)
            }

            let decoder = JSONDecoder()
            return .success(try decoder.decode(T.self, from: data))
        } catch _ as DecodingError {
            return .failure(APIError.decodingFailed)
        } catch {
            #if DEBUG
            print("Error: \(error)")
            #endif
            return .failure(APIError.noData)
        }
    }
}
