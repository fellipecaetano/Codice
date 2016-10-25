import PromiseKit

public protocol Unarchiving {
    associatedtype Object
    func unarchive() throws -> Object
}

public extension Unarchiving where Self: Asynchronous {
    func unarchive() -> Promise<Object> {
        return Promise { fulfill, reject in
            dispatch {
                do {
                    let object = try self.unarchive()
                    fulfill(object)
                } catch let error {
                    reject(error)
                }
            }
        }
    }
}

public enum UnarchivingError: Error {
    case failedReading
    case wrongType
    case unknown
}
