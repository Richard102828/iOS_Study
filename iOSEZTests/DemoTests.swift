//
//  DemoTests.swift
//  iOSEZTests
//
//  Created by ezrealzhang on 2023/5/15.
//

import XCTest
import Foundation
import ComposableArchitecture

final class DemoTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    // @ezrealzhang 测试存在问题，后面单独写吧
    func testCounterIncrement() {
        // @ezrealzhang 不知道为啥，第一行触发断言了 - Attempting to move out of a copy-on-write existential
        let store = TestStore(initialState: CounterFeature.State(count: Int.random(in: -100...100)), reducer: CounterFeature()) { dependcy in
            dependcy.counterFactor.randomNum = 5
        }
        store.send(.increment) { state in
            state.count += 1
        }
        store.send(.decrement) { state in
            state.count -= 1
        }
        store.send(.playNext) { state in
            state.count = 0
        }
        // @ezrealzhang todo 这种测试不是很好做，尝试用下官方的方法
        store.send(.setCount("10")) { state in
            state.count = 10
        }
        store.send(.changeCount(10)) { state in
            state.count = 10
        }
    }
    
}
