//
//  NetworkServiceTests.swift
//  EventGuideTests
//
//  Created by Anup Deshpande on 1/25/21.
//

import XCTest

class NetworkServiceTests: XCTestCase {

    func testEventListExpectedCount(){
        MockNetworkService.request(endpoint: .getEvents) { (result: Result< EventList, Error>) in
            switch result{
            case .success(let eventList):
                XCTAssert(eventList.events.count == 10)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

}
