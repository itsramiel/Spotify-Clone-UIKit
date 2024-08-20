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
        case invalidQuery
        case invalidBody
    }
    
    struct SavedAlbum: Codable {
        let addedAt: String
        let album: Album
    }
    
    public func getUserSavedAlbums(completion: @escaping (Result<[Album], Error>) -> Void){
        guard let url = URL(string: "\(Constants.baseUrl)/me/albums") else {
            fatalError("Invalid URL")
        }
        
        httpRequest(httpParams: HttpRequestParams(url: url, method: .GET), completion: { result in
            switch result {
            case let .success(data):
                do {
                    let jsonDecoder = JSONDecoder()
                    jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    try completion(.success(jsonDecoder.decode(PaginatedResponse<SavedAlbum>.self, from: data).items.map({$0.album})))
                } catch {
                    print(error)
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
            
        })
    }
    
    public func addToSavedAlbums(with id: String, completion: @escaping (Bool) -> Void){
        guard let url = URL(string: "\(Constants.baseUrl)/me/albums") else {
            fatalError("Invalid URL")
        }
        
        let body: [String: Codable] = [
            "ids": [id]
        ]
        
        httpRequest(httpParams: HttpRequestParams(url: url, method: .PUT, body: body)) { result in
            switch result {
            case let .success(data):
                let x = try? JSONSerialization.jsonObject(with: data)
                completion(true)
            case .failure:
                completion(false)
            }
        }
    }
    
    public func removeFromSavedAlbums(withId id: String, completion: @escaping (Bool) -> Void){
        guard let url = URL(string: "\(Constants.baseUrl)/me/albums") else {
            fatalError("Invalid URL")
        }
        
        let body: [String: Codable] = [
            "ids": [id]
        ]

        httpRequest(httpParams: HttpRequestParams(url: url, method: .DELETE, body: body)) { result in
            switch result {
            case .success:
                completion(true)
            case .failure:
                completion(false)
            }
        }
    }


    public func getCurrentUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseUrl)/me") else {
            fatalError("Invalid URL")
        }

        httpRequest(httpParams: HttpRequestParams(url: url, method: .GET), completion: { result in
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
    
    struct SearchResponse: Codable {
        let albums: PaginatedResponse<Album>
        let artists: PaginatedResponse<Artist>
        let tracks: PaginatedResponse<Track>
        let playlists: PaginatedResponse<Playlist>
    }
    
    public func search(with query: String, completion: @escaping (Result<SearchResponse, Error>) -> Void) {
        let components = URLComponents(string: Constants.baseUrl + "/search")
        guard var components else { fatalError() }
        
        components.queryItems = [
            URLQueryItem(name: "q", value: query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)),
            URLQueryItem(name: "type", value: ["album", "artist", "playlist", "track"].joined(separator: ","))
        ]
        
        guard let url = components.url else {
            return completion(.failure(APIError.invalidQuery))
        }
        
        httpRequest(httpParams: HttpRequestParams(url: url, method: .GET), completion: { result in
            switch result {
            case let .success(data):
                do {
                    let jsonDecoder = JSONDecoder()
                    jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

                    try completion(.success(jsonDecoder.decode(SearchResponse.self, from: data)))
                } catch {
                    print(error)
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }

        })
    }

    
    struct GetCategoriesResponse: Codable {
        let categories: PaginatedResponse<Category>
    }
    
    public func getCategories(completion: @escaping (Result<GetCategoriesResponse, Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseUrl)/browse/categories") else {
            fatalError("Invalid URL")
        }

        httpRequest(httpParams: HttpRequestParams(url: url, method: .GET), completion: { result in
            switch result {
            case let .success(data):
                do {
                    let jsonDecoder = JSONDecoder()
                    jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

                    try completion(.success(jsonDecoder.decode(GetCategoriesResponse.self, from: data)))
                } catch {
                    print(error)
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }

        })
    }
    
    struct GetPlaylistsForCategoryResponse: Codable {
        let message: String
        let playlists: PaginatedResponse<Playlist>
    }
    
    public func getPlaylistsForCategory(with id: String, completion: @escaping (Result<GetPlaylistsForCategoryResponse, Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseUrl)/browse/categories/\(id)/playlists") else {
            fatalError("Invalid URL")
        }

        httpRequest(httpParams: HttpRequestParams(url: url, method: .GET), completion: { result in
            switch result {
            case let .success(data):
                do {
                    let jsonDecoder = JSONDecoder()
                    jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

                    try completion(.success(jsonDecoder.decode(GetPlaylistsForCategoryResponse.self, from: data)))
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

        httpRequest(httpParams: HttpRequestParams(url: url, method: .GET), completion: { result in
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

        httpRequest(httpParams: HttpRequestParams(url: url, method: .GET), completion: { result in
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
    
    typealias GetCurrentUserPlaylistsResponse = PaginatedResponse<Playlist>
        
    
    public func getCurrentUserPlaylists(completion: @escaping (Result<[Playlist], Error>) -> Void){
            guard let url = URL(string: "\(Constants.baseUrl)/me/playlists") else {
                fatalError("Invalid URL")
            }

            httpRequest(httpParams: HttpRequestParams(url: url, method: .GET), completion: { result in
                switch result {
                case let .success(data):
                    do {
                        let jsonDecoder = JSONDecoder()
                        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

                        try completion(.success(jsonDecoder.decode(GetCurrentUserPlaylistsResponse.self, from: data).items))
                    } catch {
                        print(error)
                        completion(.failure(error))
                    }
                case let .failure(error):
                    completion(.failure(error))
                }

            })
    }
    
    public func createPlaylistWithName(_ name: String, completion: @escaping (Bool) -> Void){
        getCurrentUserProfile { [weak self] result in
            guard case let .success(userProfile) = result else {
                return completion(false)
            }
            guard let url = URL(string: "\(Constants.baseUrl)/users/\(userProfile.id)/playlists") else {
                fatalError("Invalid URL")
            }

            self?.httpRequest(httpParams: HttpRequestParams(url: url, method: .POST, body: ["name": name]), completion: { result in
                switch result {
                case let .success(data):
                    do {
                        let jsonDecoder = JSONDecoder()
                        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

                        let _ = try jsonDecoder.decode(Playlist.self, from: data)
                        completion(true)
                    } catch {
                        print(error)
                        completion(false)
                    }
                case .failure(_):
                    completion(false)
                }

            })
        }

    }
    
    struct AddTrackResponse: Codable {
        let snapshotId: String
    }
    
    public func addTrackWith(
        uri trackUri: String,
        toPlaylistWith playlistId: String,
        completion: @escaping (Bool) -> Void
    ){
        guard let url = URL(string: "\(Constants.baseUrl)/playlists/\(playlistId)/tracks") else {
            fatalError("Invalid URL")
        }
        
        let body: [String: Codable] = [
            "position": 0,
            "uris": [trackUri]
        ]
        
        self.httpRequest(httpParams: HttpRequestParams(url: url, method: .POST, body: body), completion: { result in
            switch result {
            case let .success(data):
                do {
                    let jsonDecoder = JSONDecoder()
                    jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    let _ = try jsonDecoder.decode(AddTrackResponse.self, from: data)
                    completion(true)
                } catch {
                    print(error)
                    completion(false)
                }
            case .failure(_):
                completion(false)
            }
            
        })
    }
    
    struct RemoveTrackResponse: Codable {
        let snapshotId: String
    }
    
    public func RemoveTrackWith(
        uri trackUri: String,
        fromPlaylistWith playlistId: String,
        completion: @escaping (Bool) -> Void
    ){
        guard let url = URL(string: "\(Constants.baseUrl)/playlists/\(playlistId)/tracks") else {
            fatalError("Invalid URL")
        }
        
        let body: [String: Codable] = [
            "tracks": [
                ["uri": trackUri]
            ]
        ]
        
        self.httpRequest(httpParams: HttpRequestParams(url: url, method: .DELETE, body: body), completion: { result in
            switch result {
            case let .success(data):
                do {
                    let jsonDecoder = JSONDecoder()
                    jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    let _ = try jsonDecoder.decode(RemoveTrackResponse.self, from: data)
                    completion(true)
                } catch {
                    print(error)
                    completion(false)
                }
            case .failure(_):
                completion(false)
            }
            
        })
    }


    public func getNewReleases(completion: @escaping (Result<NewReleasesResponse, Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseUrl)/browse/new-releases") else {
            fatalError("Invalid URL")
        }

        httpRequest(httpParams: HttpRequestParams(url: url, method: .GET), completion: { result in
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

        httpRequest(httpParams: HttpRequestParams(url: url, method: .GET), completion: { result in
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

        httpRequest(httpParams: HttpRequestParams(url: url, method: .GET), completion: { result in
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

            self?.httpRequest(httpParams: HttpRequestParams(url: url, method: .GET), completion: { result in
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
    
    struct HttpRequestParams {
        let url: URL
        let method: HttpMethod
        let body: [String: Codable]?
        
        init(url: URL, method: HttpMethod, body: [String : Codable]? = nil) {
            self.url = url
            self.method = method
            self.body = body
        }
    }
    
    private func httpRequest(httpParams: HttpRequestParams, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let accessToken = AuthManager.shared.accessToken else {
            completion(.failure(APIError.UnAuthenticated))
            return
        }
        
        var request = URLRequest(url: httpParams.url)
        request.httpMethod = httpParams.method.rawValue
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        if let body = httpParams.body {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body)
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                completion(.failure(APIError.invalidBody))
            }
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(APIError.FailedToGetData))
                return
            }
            
            if(response.statusCode >= 400) {
                return completion(.failure(APIError.FailedToGetData))
            }
            guard let data, error == nil else {
                completion(.failure(APIError.FailedToGetData))
                return
            }

            completion(.success(data))
        }

        task.resume()
    }
}
