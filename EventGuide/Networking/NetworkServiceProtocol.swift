//
//  NetworkManagerProtocol.swift
//  EventGuide
//
//  Created by Anup Deshpande on 1/25/21.
//

import Foundation

protocol NetworkServiceProtocol {
    static func request<T: Codable>(endpoint: Endpoint, completion: @escaping (Result<T, Error>) -> ())
}
