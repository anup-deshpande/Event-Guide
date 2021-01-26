//
//  ServiceLayer.swift
//  EventGuide
//
//  Created by Anup Deshpande on 1/24/21.
//

import Foundation

class NetworkService: NetworkServiceProtocol{
    static func request<T: Codable>(endpoint: Endpoint, completion: @escaping (Result<T, Error>) -> ()){
            
        // Construct URL from the components formed in the router
        var components = URLComponents()
        components.scheme = endpoint.scheme
        components.host = endpoint.host
        components.path = endpoint.path
        components.queryItems = endpoint.parameters
        
        guard let url = components.url else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.method
        
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error{
                print("Error in urlSession request : \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            
            // 1. Configure JSON decoder
            // 2. convert snake case keys retrieved from seatGeek API to camel case
            // 3. Convert from ISO-8601 to Date instance
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
            
            do{
                let repsponseObject = try decoder.decode(T.self, from: data)
                
                DispatchQueue.main.async {
                    completion(.success(repsponseObject))
                }
                
            }catch{
                print("Error in parsing data fetched from request: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        
        dataTask.resume()
    }
}
