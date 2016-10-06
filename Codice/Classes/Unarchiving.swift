import BrightFutures

public protocol Unarchiving {
    associatedtype Object
    func unarchive() throws -> Object
}

public extension Unarchiving where Self: Asynchronous {
    func unarchive() -> Future<Object, UnarchivingError> {
        let promise = Promise<Object, UnarchivingError>()

        dispatch {
            do {
                let object = try self.unarchive()
                promise.success(object)
            } catch let error as UnarchivingError {
                promise.failure(error)
            } catch {
                promise.failure(.unknown)
            }
        }

        return promise.future
    }
}

public enum UnarchivingError: Error {
    case failedReading
    case wrongType
    case unknown
}
