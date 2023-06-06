//
//  MarvelNetwoking.swift
//  FastShopForTest
//
//  Created by ACT on 04/06/23.
//

import Foundation
import UIKit
import Combine
import CryptoKit

class MarvelNetworking {
    
    func requestListMarvelHQ(startTitle: String?,offsetPage: Int?, completion: @escaping (Result<MarvelHQModel,Error>) -> Void){
        
        let public_key = "7abea6bac5786ed777d3afbfe3a5cb89"
        let private_key = "c34a2793aaf33038b721f6444345b94163de3fae"
        
        let ts = String(Date().timeIntervalSince1970)
        let data = "\(ts)\(private_key)\(public_key)".data(using: .utf8) ?? Data()
        let hash = Insecure.MD5.hash(data: data)
        
        let valueMapHash = hash.map { byte in
            String(format: "%02hhx",byte)
        }.joined()
        
        var urlRequest = "https://gateway.marvel.com:443/v1/public/comics?offset=\(offsetPage ?? 0)&ts=\(ts)&apikey=\(public_key)&hash=\(valueMapHash)"
        
        if let title = startTitle, !title.isEmpty {
            urlRequest += "&titleStartsWith=\(title.replacingOccurrences(of: " ", with: "%20"))"
        }
        
        print(urlRequest)
        
        guard let url = URL(string: urlRequest) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, err) in
            
            if let error = err {
                print(error.localizedDescription)
                return
            }
            
            guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
                print(err?.localizedDescription ?? "")
                print(response ?? URLResponse())
                return
            }
            
            if let data = data {
                do {
                    let marvelHQMarvel = try JSONDecoder().decode(MarvelHQModel.self, from: data)
                    completion(.success(marvelHQMarvel))
                } catch {
                    print(error.localizedDescription)
                }
                
            }
            
        })
        
        task.resume()
    }
}
