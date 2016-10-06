import XCTest
import Codice
import Nimble

class UnarchivingTests: XCTestCase {
    func testSuccessfulAsyncUnarchiving() {
        let unarchiving = SuccessfulUnarchiving(queue: DispatchQueue.global(qos: DispatchQoS.QoSClass.background))

        waitUntil { done in
            unarchiving.unarchive().onSuccess { unarchived in
                expect(unarchived) == true
                done()
            }
        }
    }

    func testFailedUnarchiving() {
        let unarchiving = FailableUnarchiving(queue: DispatchQueue.main, error: .wrongType)

        waitUntil { done in
            unarchiving.unarchive().onFailure { error in
                expect(error) == UnarchivingError.wrongType
                done()
            }
        }
    }
}

struct SuccessfulUnarchiving: Unarchiving, Asynchronous {
    typealias Object = Bool
    let queue: DispatchQueue

    func unarchive() throws -> Bool {
        return true
    }
}

struct FailableUnarchiving: Unarchiving, Asynchronous {
    typealias Object = Bool
    let queue: DispatchQueue
    let error: UnarchivingError

    func unarchive() throws -> Bool {
        throw error
    }
}
