import Foundation

public protocol URLConvertible {
    static var baseURL: URL { get }
    static var path: String { get }
}

public extension URLConvertible {
    static var URL: URL {
        return baseURL.appendingPathComponent(path)
    }
}

public protocol Cacheable {}

public extension Cacheable where Self: URLConvertible {
    static var baseURL: URL {
        return FileManager.default.urls(for: .cachesDirectory,
                                        in: .userDomainMask)[0]
    }
}

public protocol Persistable {}

public extension Persistable where Self: URLConvertible {
    static var baseURL: URL {
        return FileManager.default.urls(for: .documentDirectory,
                                        in: .userDomainMask)[0]
    }
}
