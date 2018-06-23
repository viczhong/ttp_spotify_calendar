//
//  CalendarFrontEndTests.swift
//  CalendarFrontEndTests
//
//  Created by Victor Zhong on 6/15/18.
//  Copyright © 2018 Victor Zhong. All rights reserved.
//

import XCTest
@testable import CalendarFrontEnd

class CalendarFrontEndTests: XCTestCase {
    var dateManagerUnderTest: DateManager!
    var apiClientUnderTest: APIRequestManager!

    override func setUp() {
        super.setUp()
        apiClientUnderTest = APIRequestManager()
        dateManagerUnderTest = DateManager(apiClientUnderTest)
        dateManagerUnderTest.dateFormatter.timeZone = TimeZone(abbreviation: "EDT")

        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.path(forResource: "events", ofType: "json")
        let data = try? Data(contentsOf: URL(fileURLWithPath: path!), options: .alwaysMapped)

        let urlResponse = HTTPURLResponse(url: URL(string: "https://warm-shore-97050.herokuapp.com/api/events/")!, statusCode: 200, httpVersion: nil, headerFields: nil)

        let sessionMock = URLSessionMock(data: data, response: urlResponse, error: nil)
        apiClientUnderTest.defaultSession = sessionMock

        setUpMockSession()
    }
    
    override func tearDown() {
        dateManagerUnderTest = nil
        apiClientUnderTest = nil

        super.tearDown()
    }

    func setUpMockSession() {
        // given
        let promise = expectation(description: "Status code: 200")

        // when
        XCTAssertEqual(dateManagerUnderTest.eventsArray.count, 0, "searchResults should be empty before the data task runs")

        dateManagerUnderTest.getEvents() { (_, _) in
            promise.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }

    func test_setUpMonth() {
        dateManagerUnderTest.setUpMonth(6, 2018) { (_) in
            self.dateManagerUnderTest.getEvents { (_, _) in
            }
        }

        XCTAssert(dateManagerUnderTest.currentMonth == 6)
        XCTAssert(dateManagerUnderTest.currentYear == 2018)
        XCTAssert(dateManagerUnderTest.placeholderDays == 5)
        XCTAssert(dateManagerUnderTest.numberOfDays == 30)
    }

    func test_populateDateEntries() {
        dateManagerUnderTest.setUpMonth(6, 2018) { _ in
        }

        let dates = dateManagerUnderTest.populateDateEntries(.landscape)

        XCTAssert(dates[0].dateStringLong == "Sunday")
        XCTAssert(dates[0].placeholder == true)
        XCTAssert(dates[0].placeholder == true)
        XCTAssert(dates[5].dateStringLong == "Friday - 1")
        XCTAssert(dates[5].placeholder == false)
    }

    func test_populateNumberOfDaysInCalendar() {
        dateManagerUnderTest.placeholderDays = 5
        dateManagerUnderTest.numberOfDays = 31

        dateManagerUnderTest.populateNumberOfDaysInCalendar()

        XCTAssert(dateManagerUnderTest.daysArray.count == 36)
    }

    func test_dateToTimeStrings() {
        let date = Date(timeIntervalSinceReferenceDate: TimeInterval(551080020.0))

        let dateString = dateManagerUnderTest.dateToTimeStrings(date)

        XCTAssert(dateString.0 == "June 19, 2018")
        XCTAssert(dateString.1 == "1:47 AM")
    }

    func test_dateStringToTimeStrings() {
        let dateString = "2018-06-19 03:23:37+0000"
        let timeString = dateManagerUnderTest.dateStringToTimeStrings(dateString)

        XCTAssert(timeString?.0 == "June 18, 2018")
        XCTAssert(timeString?.1 == "11:23 PM")
    }

    func test_eventTimeStringToDate() {
       let date = Date(timeIntervalSinceReferenceDate: TimeInterval(551080020.0))
        let testDate = dateManagerUnderTest.eventTimeStringToDate("June 19, 2018", "1:47 AM")

        XCTAssert(date == testDate)
    }

    func test_calcuateMonthAndYear() {
        dateManagerUnderTest.calcuateMonthAndYear(6, 2018)

        XCTAssert(dateManagerUnderTest.monthYearString == "June, 2018")
    }

    func test_getHeaderString() {
        dateManagerUnderTest.calcuateMonthAndYear(6, 2018)
        XCTAssert(dateManagerUnderTest.getHeaderString() == "June, 2018")
    }

    func test_getEvents() {
        dateManagerUnderTest.getEvents { (_, events) in
            DispatchQueue.main.async {
                guard let events = events else { return }
                XCTAssert(events.count > 0)
                XCTAssert(events[0].title == "Work on TTP App")
            }
        }
    }

    func test_getEventsAndFilterIntoDate() {
        dateManagerUnderTest.getEventsAndFilterIntoDate(5, 18, 2018) { (events) in
            DispatchQueue.main.async {
                XCTAssert(events.count == 1)
                XCTAssert(events[0].title == "Test some code")
            }
        }
    }

    func test_rotated() {
        dateManagerUnderTest.rotated(.landscape) { [weak self] in
            XCTAssert(self?.dateManagerUnderTest.screenRotation != .portrait)
        }
    }

}
