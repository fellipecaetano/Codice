import PromiseKit

public protocol Archiving {
    associatedtype Object
    @discardableResult func archive(_ rootObject: Object) -> Bool
}

public extension Archiving where Self: Asynchronous {
    @discardableResult
    func archive(_ rootObject: Object) -> Promise<Object> {
        return Promise { fulfill, reject in
            dispatch {
                do {
                    try self.tryToArchive(rootObject)
                    fulfill(rootObject)
                } catch let error {
                    reject(error)
                }
            }
        }
    }
}

private extension Archiving {
    func tryToArchive(_ rootObject: Object) throws {
        if !archive(rootObject) {
            throw ArchivingError.failedWriting
        }
    }
}

public enum ArchivingError: Error {
    case failedWriting
    case unknown
}
