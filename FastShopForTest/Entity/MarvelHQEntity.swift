//
//  MarvelHQEntity.swift
//  FastShopForTest
//
//  Created by ACT on 02/06/23.
//

import Foundation

protocol MarvelHQEntity: Decodable {
    var data: MarvelHQComicDataContainer { get set }
}

protocol MarvelHQComicDataContainerEntity: Decodable {
    var offset: Int { get set }
    var count: Int { get set }
}

protocol MarvelHQComicEntity: Identifiable, Decodable {
    var title: String { get set }
    var thumbnail: [String : String] { get set }
    var description: String? { get set }
}
        

struct MarvelHQModel: MarvelHQEntity {
    var data: MarvelHQComicDataContainer
}

struct MarvelHQComicDataContainer: MarvelHQComicDataContainerEntity{
    var offset: Int
    var count: Int
    var results: [MarvelHQComic]
}

struct MarvelHQComic: MarvelHQComicEntity {
    var id: Int
    var title: String
    var thumbnail: [String : String]
    var description: String?
}
