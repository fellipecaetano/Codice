import XCTest
import Foundation
import Codice
import Nimble

class ArchivingTests: XCTestCase {
    func testSuccessfulArchiving() {
        testSuccessfulArchiving(token: "main_queue")
    }

    func testSuccessfulArchivingInAnotherQueue() {
        testSuccessfulArchiving(token: "background_queue",
                                queue: DispatchQueue.global(qos: DispatchQoS.QoSClass.background))
    }

    fileprivate func testSuccessfulArchiving(token: String, queue: DispatchQueue = DispatchQueue.main) {
        let archiving = MockArchiving<TestFile>(queue: queue)
        let persistable = TestFile(token: token)

        waitUntil { done in
            _ = archiving.archive(persistable).then { _ -> Void in
                let archived = archiving.archivedObjects[TestFile.URL.absoluteString]
                expect(archived?.token) == persistable.token
                done()
            }
        }
    }

    func testErrorHandlingWhenArchivingFails() {
        let archiving = FailableArchiving<TestFile>(queue: DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated))

        waitUntil { done in
            archiving.archive(TestFile(token: "")).catch { error in
                let actual = error as? ArchivingError
                expect(actual) == ArchivingError.failedWriting
                done()
            }
        }
    }

    func testSuccessfulUnarchiving() {
        waitUntil { done in
            done()
        }
    }
}

private class MockArchiving<T: URLConvertible>: Archiving, Asynchronous {
    var archivedObjects: [String: T] = [:]
    let queue: DispatchQueue

    init (queue: DispatchQueue = DispatchQueue.main) {
        self.queue = queue
    }

    func archive(_ rootObject: T) -> Bool {
        archivedObjects[T.URL.absoluteString] = rootObject
        return true
    }
}

private struct FailableArchiving<T>: Archiving, Asynchronous {
    let queue: DispatchQueue

    fileprivate func archive(_ rootObject: T) -> Bool {
        return false
    }
}

private struct TestFile: URLConvertible {
    let token: String

    fileprivate static var baseURL: URL {
        return NSURL(string: "file:///")! as URL
    }

    fileprivate static var path: String {
        return "test"
    }
}
