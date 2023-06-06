//
//  MarvelRouter.swift
//  FastShopForTest
//
//  Created by ACT on 02/06/23.
//

import Foundation
import UIKit

protocol MarvelRouterProtocol {
    static var instanceBundle: Bundle { get set }
    func instanceMarvelScreen() -> MarvelScreenMainViewController
    func instanceMarvelDetailScreen() -> MarvelDetailScreenViewController
    func pushMarvelDetailScreen(comic: MarvelHQComic,navigation: UINavigationController?)
}

class MarvelRouter: MarvelRouterProtocol {
   
    
    static var instanceBundle: Bundle = Bundle.main
    
    
    func instanceMarvelScreen() -> MarvelScreenMainViewController {
        let view = MarvelScreenMainViewController()
        let presenter = MarvelPresenter()
        let interactor = MarvelInteractor()
        
        view.presenter = presenter
        interactor.presenter = presenter
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = self as MarvelRouterProtocol
        
        return view
    }
    
    func instanceMarvelDetailScreen() -> MarvelDetailScreenViewController {
        let view = MarvelDetailScreenViewController()
        return view
    }
    
    func pushMarvelDetailScreen(comic: MarvelHQComic, navigation: UINavigationController?) {
        guard let nav = navigation else { return }
        let screen = self.instanceMarvelDetailScreen()
        screen.marvelHQComic = comic
        nav.pushViewController(screen, animated: true)
    }
}
