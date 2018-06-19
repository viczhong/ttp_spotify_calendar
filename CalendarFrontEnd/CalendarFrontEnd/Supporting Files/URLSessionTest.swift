//
//  URLSessionTest.swift
//  CalendarFrontEnd
//
//  Created by Victor Zhong on 6/19/18.
//  Copyright © 2018 Victor Zhong. All rights reserved.
//

import Foundation

public protocol MockableURLSession {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: MockableURLSession {}

public final class URLSessionMock : MockableURLSession {
    var url: URL?
    var request: URLRequest?
    private let dataTaskMock: URLSessionDataTaskMock

    public init(data: Data? = nil, response: URLResponse? = nil, error: Error? = nil) {
        dataTaskMock = URLSessionDataTaskMock()
        dataTaskMock.taskResponse = (data, response, error)
    }

    public func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        self.url = url
        self.dataTaskMock.completionHandler = completionHandler
        return self.dataTaskMock
    }

    public func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        self.request = request
        self.dataTaskMock.completionHandler = completionHandler
        return self.dataTaskMock
    }

    final private class URLSessionDataTaskMock  : URLSessionDataTask {
        typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
        var completionHandler: CompletionHandler?
        var taskResponse: (Data?, URLResponse?, Error?)?

        override func resume() {
            DispatchQueue.main.async {
                self.completionHandler?(self.taskResponse?.0, self.taskResponse?.1, self.taskResponse?.2)
            }
        }
    }
}
