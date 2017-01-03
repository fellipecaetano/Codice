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

public protocol Cacheable: URLConvertible {}

public extension Cacheable {
    static var baseURL: URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    }
}

public protocol Persistable: URLConvertible {}

public extension Persistable {
    static var baseURL: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}

public protocol Encodable {
    associatedtype Encoded: NSCoding
    var encoded: Encoded { get }
}

public protocol Decodable {
    associatedtype Value
    var decoded: Value { get }
}

public class KeyedArchive<T: Encodable & URLConvertible> where T.Encoded: Decodable, T.Encoded.Value == T {
    public static func archive(_ rootObject: T) -> Bool {
        return NSKeyedArchiver.archiveRootObject(rootObject.encoded, toFile: T.URL.path)
    }

    public static func unarchive() -> T? {
        let unarchived = NSKeyedUnarchiver.unarchiveObject(withFile: T.URL.path) as? T.Encoded
        return unarchived?.decoded
    }
}
