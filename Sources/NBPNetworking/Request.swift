import Foundation

public struct Request {
    private let url: URL
    private let method: Method
    
    public init(url: URL, method: Method) {
        self.url = url
        self.method = method
    }
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
