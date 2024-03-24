// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public protocol NetworkAccessing {
    func fetchData(for request: Request, then completion: @escaping NetworkCompletion)
    func fetchData(for request: Request) async throws -> Data
}

public enum NetworkError: Error {
    case networkError(text: String?)
    case responseError
    case invalidData
}

public typealias NetworkCompletion = (Result<Data, NetworkError>) -> Void

public class URLSessionNetworkAccess: NetworkAccessing {
    
    private let session: URLSession
    
    public init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    public func fetchData(for request: Request) async throws -> Data {
        do {
            let (data, response) = try await session.data(for: request.build())
            guard let
                networkResponse = response as? HTTPURLResponse,
                networkResponse.statusCode == 200
            else {
                throw NetworkError.responseError
            }
            return data
            
        } catch {
            throw NetworkError.networkError(text: error.localizedDescription)
        }
    }
    
    public func fetchData(for request: Request, then completion: @escaping NetworkCompletion) {
        let dataTask = session.dataTask(with: request.build()) { data, response, error in
            guard error == nil else {
                completion(.failure(.networkError(text: error?.localizedDescription)))
                return
            }
            guard let
                networkResponse = response as? HTTPURLResponse,
                networkResponse.statusCode == 200
            else {
                completion(.failure(.responseError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            completion(.success(data))
        }
        
        dataTask.resume()
    }
}

public struct Request {
    let url: URL
    let method: Method
}

extension Request {
    func build() -> URLRequest {
        var request = URLRequest(
            url: self.url,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 10.0
        )
        
        request.httpMethod = self.method.httpMethod
        return request
    }
}

enum Method {
    case get
}

extension Method {
    var httpMethod: String {
        switch self {
        case .get: return "GET"
        }
    }
}
