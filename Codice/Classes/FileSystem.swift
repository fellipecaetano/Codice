public protocol URLConvertible {
    static var baseURL: Foundation.URL { get }
    static var path: String { get }
}

public extension URLConvertible {
    static var URL: Foundation.URL {
        return baseURL.appendingPathComponent(path)
    }
}

public protocol Cacheable {}

public extension Cacheable where Self: URLConvertible {
    static var baseURL: Foundation.URL {
        return FileManager.default.urls(for: .cachesDirectory,
                                                               in: .userDomainMask)[0]
    }
}

public protocol Persistable {}

public extension Persistable where Self: URLConvertible {
    static var baseURL: Foundation.URL {
        return FileManager.default.urls(for: .documentDirectory,
                                                               in: .userDomainMask)[0]
    }
}
