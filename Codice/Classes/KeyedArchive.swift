import Foundation

public struct KeyedArchive<T: NSDictionaryConvertible & URLConvertible>: Archiving, Unarchiving, Asynchronous {
    public typealias Object = T
    public let queue: DispatchQueue

    public init (queue: DispatchQueue) {
        self.queue = queue
    }

    public func archive(_ rootObject: T) -> Bool {
        return NSKeyedArchiver.archiveRootObject(rootObject.asDictionary(),
                                                 toFile: T.URL.path)
    }

    public func unarchive() throws -> T {
        guard let unarchived = NSKeyedUnarchiver.unarchiveObject(withFile: T.URL.path) else {
            throw UnarchivingError.failedReading
        }
        guard let dictionary = unarchived as? NSDictionary, let object = T(dictionary: dictionary) else {
            throw UnarchivingError.wrongType
        }
        return object
    }
}

public protocol NSDictionaryConvertible {
    init?(dictionary: NSDictionary)
    func asDictionary() -> NSDictionary
}
