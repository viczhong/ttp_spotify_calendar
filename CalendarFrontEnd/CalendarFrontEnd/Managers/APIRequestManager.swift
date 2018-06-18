//
//  APIRequestManager.swift
//  CalendarFrontEnd
//
//  Created by Victor Zhong on 6/18/18.
//  Copyright © 2018 Victor Zhong. All rights reserved.
//

import Foundation

class APIRequestManager {

    func performDataTask(_ type: RequestType, events: [Event]?, completionHandler: @escaping (Data?) -> Void) {

        guard let url = URL(string: "https://peaceful-waters-80172.herokuapp.com/api/events") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = type.rawValue

        if type == .post {
            //TODO: - ADD STUFF HERE
        }

        URLSession(configuration: .default).dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            }

            if let data = data {
                completionHandler(data)
            }
        }.resume()
    }


}
