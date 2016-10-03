import Foundation

public struct KeyedArchive<T: protocol<NSDictionaryConvertible, URLConvertible>>: Archiving, Unarchiving, Asynchronous {
    public typealias Object = T
    public let queue: dispatch_queue_t

    public init (queue: dispatch_queue_t) {
        self.queue = queue
    }

    public func archive(rootObject: T) -> Bool {
        if let path = T.URL.path {
            return NSKeyedArchiver.archiveRootObject(rootObject.asDictionary(),
                                                     toFile: path)
        } else {
            return false
        }
    }

    public func unarchive() throws -> T {
        guard let unarchived = T.URL.path.flatMap(NSKeyedUnarchiver.unarchiveObjectWithFile) else {
            throw UnarchivingError.FailedReading
        }
        guard let dictionary = unarchived as? NSDictionary, object = T(dictionary: dictionary) else {
            throw UnarchivingError.WrongType
        }
        return object
    }
}

public protocol NSDictionaryConvertible {
    init?(dictionary: NSDictionary)
    func asDictionary() -> NSDictionary
}
