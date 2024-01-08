//
//  TransactionsServiceTests.swift
//  WorldOfPAYBACKTests
//
//  Created by Oleg Kasarin on 08/01/2024.
//

@testable import WorldOfPAYBACK
import XCTest

final class TransactionsServiceTests: XCTestCase {
    private var sut: TransactionsServiceProtocol!
    
    private var requestExecutorSpy: RequestExecutorSpy!
    
    override func setUpWithError() throws {
        requestExecutorSpy = RequestExecutorSpy()
        sut = TransactionsService(executor: requestExecutorSpy)
    }

    override func tearDownWithError() throws {
        sut = nil
        requestExecutorSpy = nil
    }

    func testFetchSuccess() async throws {
        requestExecutorSpy.stubbedExecuteRequestTResult = TransactionsResponse.mockedResponse()
        let transactions = try await sut.fetch()
        
        XCTAssertFalse(transactions.isEmpty, "Expected non empty array of transactions")
        
        XCTAssertTrue(requestExecutorSpy.invokedExecuteRequestT)
        XCTAssertEqual(requestExecutorSpy.invokedExecuteRequestTCount, 1)
    }
    
    func testFetchFailure() async throws {
        requestExecutorSpy.stubbedExecuteRequestTError = "error"
        
        do {
            let _ = try await sut.fetch()
        } catch {
            XCTAssertNotNil(error)
        }
        
        XCTAssertTrue(requestExecutorSpy.invokedExecuteRequestT)
        XCTAssertEqual(requestExecutorSpy.invokedExecuteRequestTCount, 1)
    }
}
