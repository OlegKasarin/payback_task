//
//  TransactionsListViewModelTests.swift
//  WorldOfPAYBACKTests
//
//  Created by Oleg Kasarin on 08/01/2024.
//

@testable import WorldOfPAYBACK
import XCTest

final class TransactionsListViewModelTests: XCTestCase {
    private var sut: TransactionsListViewModel!
    
    private var transactionsServiceSpy: TransactionsServiceSpy!
    
    override func setUpWithError() throws {
        transactionsServiceSpy = TransactionsServiceSpy()
        sut = TransactionsListViewModel(transactionsService: transactionsServiceSpy)
    }

    override func tearDownWithError() throws {
        transactionsServiceSpy = nil
        sut = nil
    }

    func testFetch() async throws {
        let mocked = [PBTransaction.mocked]
        transactionsServiceSpy.stubbedFetchResult = mocked
        let _ = try await sut.fetch()
        
        XCTAssertEqual(sut.transactions, mocked)
    }
    
    func testUpdateCategory() throws {
        sut.transactions = [transactionWithCategory1, transactionWithCategory2]
        XCTAssertEqual(sut.selectedCategory, .all, "Check selected category by default")
        
        sut.updateSelectedCategory(.second)
        XCTAssertEqual(sut.selectedCategory, .second)
        
        
        XCTAssertEqual(sut.transactionsSections.first?.transactions.count ?? 0, 1)
        
        let section = sut.transactionsSections.first!
        let transaction = section.transactions.first!
        XCTAssertEqual(
            transaction.id,
            transactionWithCategory2.id
        )
    }
    
    func testSum_all() throws {
        sut.transactions = [transactionWithCategory1, transactionWithCategory2]
        sut.updateSelectedCategory(.all)
        
        XCTAssertEqual(sut.sumToDisplay, "Sum: 333 QWE")
    }
    
    func testSum_first() throws {
        sut.transactions = [transactionWithCategory1, transactionWithCategory2]
        sut.updateSelectedCategory(.first)
        
        XCTAssertEqual(sut.sumToDisplay, "Sum: 111 QWE")
    }
}

private let transactionWithCategory1 = PBTransaction(
        id: 1,
        partnerDisplayName: "PARTNER 1",
        category: 1,
        description: "DESCRIPTION 1",
        bookingDate: .now,
        amount: 111,
        currency: "QWE"
)

private let transactionWithCategory2 = PBTransaction(
        id: 2,
        partnerDisplayName: "PARTNER 2",
        category: 2,
        description: "DESCRIPTION 2",
        bookingDate: .now,
        amount: 222,
        currency: "QWE"
)
