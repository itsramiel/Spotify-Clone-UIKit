//
//  APIManager.swift
//  Spotify
//
//  Created by Rami Elwan on 23.07.24.
//

import Foundation

final class APIManager {
    static let shared = APIManager()

    private init() {}

    enum Constants {
        static let baseUrl = "https://api.spotify.com/v1"
    }

    enum APIError: Error {
        case UnAuthenticated
        case FailedToGetData
    }

    public func getCurrentUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseUrl)/me") else {
            fatalError("Invalid URL")
        }

        httpRequest(url: url, method: .GET, completion: { result in
            switch result {
            case let .success(data):
                do {
                    let jsonDecoder = JSONDecoder()
                    jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

                    try completion(.success(jsonDecoder.decode(UserProfile.self, from: data)))
                } catch {
                    print(error)
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }

        })
    }

    public func getAlbumDetailWith(albumId: String, completion: @escaping (Result<AlbumDetail, Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseUrl)/albums/\(albumId)") else {
            fatalError("Invalid URL")
        }

        httpRequest(url: url, method: .GET, completion: { result in
            switch result {
            case let .success(data):
                do {
                    let jsonDecoder = JSONDecoder()
                    jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

                    try completion(.success(jsonDecoder.decode(AlbumDetail.self, from: data)))
                } catch {
                    print(error)
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }

        })
    }

    public func getPlaylistDetailWith(playlistId: String, completion: @escaping (Result<PlaylistDetail, Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseUrl)/playlists/\(playlistId)") else {
            fatalError("Invalid URL")
        }

        httpRequest(url: url, method: .GET, completion: { result in
            switch result {
            case let .success(data):
                do {
                    let jsonDecoder = JSONDecoder()
                    jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

                    try completion(.success(jsonDecoder.decode(PlaylistDetail.self, from: data)))
                } catch {
                    print(error)
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }

        })
    }

    public func getNewReleases(completion: @escaping (Result<NewReleasesResponse, Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseUrl)/browse/new-releases") else {
            fatalError("Invalid URL")
        }

        httpRequest(url: url, method: .GET, completion: { result in
            switch result {
            case let .success(data):
                do {
                    let jsonDecoder = JSONDecoder()
                    jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

                    try completion(.success(jsonDecoder.decode(NewReleasesResponse.self, from: data)))
                } catch {
                    print(error)
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }

        })
    }

    public func getFeaturedPlaylists(completion: @escaping (Result<FeaturedPlaylistsResponse, Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseUrl)/browse/featured-playlists") else {
            fatalError("Invalid URL")
        }

        httpRequest(url: url, method: .GET, completion: { result in
            switch result {
            case let .success(data):
                do {
                    let jsonDecoder = JSONDecoder()
                    jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

                    try completion(.success(jsonDecoder.decode(FeaturedPlaylistsResponse.self, from: data)))
                } catch {
                    print(error)
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }

        })
    }

    struct GetGenreSeedsResponse: Codable {
        let genres: [String]
    }

    public func getGenreSeeds(completion: @escaping (Result<GetGenreSeedsResponse, Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseUrl)/recommendations/available-genre-seeds") else {
            fatalError("Invalid URL")
        }

        httpRequest(url: url, method: .GET, completion: { result in
            switch result {
            case let .success(data):
                do {
                    let jsonDecoder = JSONDecoder()
                    jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

                    try completion(.success(jsonDecoder.decode(GetGenreSeedsResponse.self, from: data)))
                } catch {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }

        })
    }

    public func getRecommendations(completion: @escaping (Result<GetRrecommendationsResponse, Error>) -> Void) {
        getGenreSeeds(completion: { [weak self] result in
            guard case let .success(genreSeedsResponse) = result else {
                if case let .failure(error) = result {
                    completion(.failure(error))
                }
                return
            }

            let components = URLComponents(string: "\(Constants.baseUrl)/recommendations")
            guard var components else { return }

            components.queryItems = [
                URLQueryItem(name: "seed_genres", value: genreSeedsResponse.genres.shuffled().prefix(5).joined(separator: ","))
            ]

            guard let url = components.url else {
                fatalError("Invalid URL")
            }

            self?.httpRequest(url: url, method: .GET, completion: { result in
                switch result {
                case let .success(data):
                    do {
                        let jsonDecoder = JSONDecoder()
                        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

                        try completion(.success(jsonDecoder.decode(GetRrecommendationsResponse.self, from: data)))
                    } catch {
                        print(error)
                        completion(.failure(error))
                    }
                case let .failure(error):
                    print(error)
                    completion(.failure(error))
                }

            })
        })
    }

    private func httpRequest(url: URL, method: HttpMethod, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let accessToken = AuthManager.shared.accessToken else {
            completion(.failure(APIError.UnAuthenticated))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data, error == nil else {
                completion(.failure(APIError.FailedToGetData))
                return
            }

            completion(.success(data))
        }

        task.resume()
    }
}
