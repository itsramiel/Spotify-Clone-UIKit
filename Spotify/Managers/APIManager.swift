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
    
    struct Constants {
        static let baseUrl = "https://api.spotify.com/v1"
    }
    
    enum APIError: Error {
        case UnAuthenticated
        case FailedToGetData
    }
    
    
    public func getCurrentUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void) {
        guard let accessToken = AuthManager.shared.accessToken else {
            completion(.failure(APIError.UnAuthenticated))
            return
        }
        
        var request = URLRequest(url: URL(string: "\(Constants.baseUrl)/me")!)
        request.httpMethod = HttpMethod.GET.rawValue
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data, error == nil else {
                completion(.failure(APIError.FailedToGetData))
                return
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                
                completion(.success(try jsonDecoder.decode(UserProfile.self, from: data)))
            } catch {
                print(error)
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
