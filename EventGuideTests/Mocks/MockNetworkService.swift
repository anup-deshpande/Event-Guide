//
//  MockNetworkService.swift
//  EventGuideTests
//
//  Created by Anup Deshpande on 1/25/21.
//

import Foundation
@testable import EventGuide

class MockNetworkService: NetworkServiceProtocol{
    static func request<T: Codable>(endpoint: Endpoint, completion: @escaping (Result<T, Error>) -> ()){

        // Instead of calling the network endpoint get the response from static file
        guard let url = Bundle(for: MockNetworkService.self).url(forResource: "EventListSuccessResponse", withExtension: "json") else { return  }

        guard let data = try? Data(contentsOf: url) else { return }

//        1. Configure JSON decoder
//        2. convert snake case keys retrieved from seatGeek API to camel case
//        3. Convert from ISO-8601 to Date instance
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

        decoder.dateDecodingStrategy = .formatted(dateFormatter)

        do{
            let repsponseObject = try decoder.decode(T.self, from: data)
            completion(.success(repsponseObject))

        }catch(let error){
            print("Error in parsing data fetched from request: \(error.localizedDescription)")
            completion(.failure(error))
        }
    }
}
