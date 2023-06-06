//
//  PresenterMarvel.swift
//  FastShopForTest
//
//  Created by ACT on 02/06/23.
//

import Foundation
import UIKit
import Combine


protocol MarvelPresenterToView{
    func requestListMarvelHQ(startTitleComic: String?, offsetPage: Int?)
    func updateListMarvelHQ() -> AnyPublisher<MarvelHQModel,URLError>?
    func showMarvelDetailScreen(comic: MarvelHQComic,navigation: UINavigationController?)
}

protocol MarvelPresenterProtocol: MarvelPresenterToView{
    var view: MarvelScreenMainViewControllerProtocol? { get set }
    var router: MarvelRouterProtocol? { get set }
    var interactor: MarvelInteractor? { get set }
    
}

class MarvelPresenter: MarvelPresenterProtocol {
    
    var view: MarvelScreenMainViewControllerProtocol?

    var router: MarvelRouterProtocol?
    
    var interactor: MarvelInteractor?
    
    var cancelable = Set<AnyCancellable>()
    
    func requestListMarvelHQ(startTitleComic: String?, offsetPage: Int?){
        interactor?.getComicsMarvelHQ(startTitle: startTitleComic,offsetPage: offsetPage)
    }
    
    func updateListMarvelHQ() -> AnyPublisher<MarvelHQModel,URLError>?{
        return interactor?.currentMarvelModel.eraseToAnyPublisher()
    }
    
    func showMarvelDetailScreen(comic: MarvelHQComic, navigation: UINavigationController?) {
        router?.pushMarvelDetailScreen(comic: comic, navigation: navigation)
    }

}
