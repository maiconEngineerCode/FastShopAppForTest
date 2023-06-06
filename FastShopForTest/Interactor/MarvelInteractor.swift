//
//  MarvelInteractor.swift
//  FastShopForTest
//
//  Created by ACT on 02/06/23.
//

import Foundation
import Combine

protocol MarvelInteractorProtocol {
    var presenter: MarvelPresenterProtocol? { get set  }
    func getComicsMarvelHQ(startTitle: String?, offsetPage: Int?)
}

class MarvelInteractor: MarvelInteractorProtocol {
    
    var presenter: MarvelPresenterProtocol?
    var cancelable: AnyCancellable?
    var currentMarvelModel = CurrentValueSubject<MarvelHQModel,URLError>(MarvelHQModel(data: MarvelHQComicDataContainer(offset: 0, count: 0,results: [ ])))
    
    func getComicsMarvelHQ(startTitle: String?, offsetPage: Int?) {
        let networking = MarvelNetworking()
        networking.requestListMarvelHQ(startTitle: startTitle,offsetPage: offsetPage){ result in
            switch result {
            case .success(let marvelHQModel):
                self.currentMarvelModel.send(marvelHQModel)
            case .failure(let failure):
                self.currentMarvelModel.send(completion: Subscribers.Completion<URLError>.failure(URLError(URLError.Code.dataNotAllowed)))
            }
        }

    }
    
}
