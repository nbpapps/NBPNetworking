import Foundation

public enum Method {
    case get
}

extension Method {
    var httpMethod: String {
        switch self {
        case .get: return "GET"
        }
    }
}
