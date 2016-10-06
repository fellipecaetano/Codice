public protocol Asynchronous {
    var queue: DispatchQueue { get }
}

public extension Asynchronous {
    func dispatch(_ block: @escaping (Void) -> Void) {
        queue.async(execute: block)
    }
}
