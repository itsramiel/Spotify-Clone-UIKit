//
//  AuthManager.swift
//  Spotify
//
//  Created by Rami Elwan on 23.07.24.
//

import Foundation

final class AuthManager {
    static let shared = AuthManager()

    enum Constanst {
        static let clientID = "a84826680414484caf1f5c00a7ee03da"
        static let clientSecret = "d945d21e273445769dba76e046713f9d"
        static let baseUrl = "https://accounts.spotify.com/"
        static let redirectUri = "https://google.com"

        enum UserDefaults: String {
            case refreshToken
            case accessToken
            case expirationDate
        }
    }

    private init() {}

    public var signInURL: URL? {
        let components = URLComponents(string: Constanst.baseUrl)
        guard var components else { return nil }

        components.path = "/authorize"
        components.queryItems = [
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "client_id", value: Constanst.clientID),
            URLQueryItem(name: "scope", value: [
                "user-read-private",
                "user-read-private",
                "playlist-read-private",
                "playlist-read-collaborative",
                "playlist-modify-public",
                "playlist-modify-private",
                "user-library-read",
                "user-library-modify",
            ].joined(separator: " ").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)),
            URLQueryItem(name: "redirect_uri", value: Constanst.redirectUri),
            URLQueryItem(name: "show_dialog", value: "true")
        ]

        return components.url
    }

    var isSignedIn: Bool {
        guard let tokenExpirationDate else {
            return false
        }
        return tokenExpirationDate > Date()
    }

    var accessToken: String? {
        return UserDefaults.standard.string(forKey: Constanst.UserDefaults.accessToken.rawValue)
    }

    private var refreshToken: String? {
        return UserDefaults.standard.string(forKey: Constanst.UserDefaults.refreshToken.rawValue)
    }

    private var tokenExpirationDate: Date? {
        return UserDefaults.standard.object(forKey: Constanst.UserDefaults.expirationDate.rawValue) as? Date
    }

    private var shouldRefreshToken: Bool {
        guard let tokenExpirationDate else {
            return true
        }

        return Date() >= tokenExpirationDate
    }

    public func exchangeCodeForToken(code: String, completion: @escaping ((Bool) -> Void)) {
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: Constanst.redirectUri)
        ]

        guard let body = components.query?.data(using: .utf8) else {
            completion(false)
            return
        }

        getToken(completion: completion, body: body)
    }

    public func refreshAccessToken(completion: @escaping (Bool) -> Void) {
        guard let refreshToken else {
            completion(false)
            return
        }

        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "refresh_token", value: refreshToken)
        ]

        guard let body = components.query?.data(using: .utf8) else {
            completion(false)
            return
        }
        getToken(completion: completion, body: body)
    }

    private func getToken(completion: @escaping (Bool) -> Void, body: Data) {
        guard let url = URL(string: "\(Constanst.baseUrl)api/token") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = HttpMethod.POST.rawValue

        request.httpBody = body
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        guard let base64Token = "\(Constanst.clientID):\(Constanst.clientSecret)".data(using: .utf8)?.base64EncodedString() else {
            completion(false)
            return
        }

        request.setValue("Basic \(base64Token)", forHTTPHeaderField: "Authorization")

        let startDate = Date()
        let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] data, _, err in
            guard let data, err == nil else {
                completion(false)
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let result = try decoder.decode(AuthResponse.self, from: data)
                self?.cacheToken(result: result, expiration: startDate.addingTimeInterval(TimeInterval(result.expiresIn)))
                completion(true)

            } catch {
                print("error", error)
                completion(false)
            }
        })

        task.resume()
    }

    private func cacheToken(result: AuthResponse, expiration: Date) {
        UserDefaults.standard.setValue(result.accessToken, forKey: Constanst.UserDefaults.accessToken.rawValue)
        UserDefaults.standard.setValue(expiration, forKey: Constanst.UserDefaults.expirationDate.rawValue)
        if let refreshToken = result.refreshToken {
            UserDefaults.standard.setValue(refreshToken, forKey: Constanst.UserDefaults.refreshToken.rawValue)
        }
    }
}
