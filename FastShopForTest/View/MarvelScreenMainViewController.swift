//
//  MarvelScreenMainViewController.swift
//  FastShopForTest
//
//  Created by ACT on 02/06/23.
//

import Foundation
import UIKit
import Combine

protocol MarvelScreenMainViewControllerProtocol: AnyObject {
    var presenter: MarvelPresenterProtocol? { get set }
}

class MarvelScreenMainViewController: UIViewController, MarvelScreenMainViewControllerProtocol {
    
    var presenter: MarvelPresenterProtocol?
    
    @Published var searchText: String = ""
    @Published var offsetPageScroll: Int = 0
    
    private var isLoadingFooter = false
    
    private var offsetPage: Int = 0
    
    private var marvelHQs: [MarvelHQComic] = []
    
    var cancelable = Set<AnyCancellable>()
    
    var collectionComicsMarvelHQ: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(MarvelHQCollectionCell.self, forCellWithReuseIdentifier: "cell")
        collection.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "FooterViewIdentifier")
        collection.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        return collection
    }()
    
    let searchController: UISearchController = UISearchController()
    
    let activityIndicadorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private var footerViewContainer: UILabel = {
        let label = UILabel()
        label.text = "Drag me down"
        label.font = UIFont.systemFont(ofSize: 16)
        label.tintColor = UIColor.black
        return label
    }()
    
    private var indicatorActivityFooter: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        indicator.isHidden = true
        return indicator
    }()
    
    private var cellFooter: UICollectionReusableView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        title = "Marvel Comics"
        view.backgroundColor = .systemGreen
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "cart"), style: .done, target: self, action: #selector(actionCart))
        
        self.searchController.searchBar.delegate = self
        self.searchController.searchBar.showsBookmarkButton = true
        
        navigationItem.searchController = self.searchController
        
        self.collectionComicsMarvelHQ.delegate = self
        self.collectionComicsMarvelHQ.dataSource = self
        self.collectionComicsMarvelHQ.frame = view.bounds
        
        view.addSubview(self.collectionComicsMarvelHQ)
        view.addSubview(self.activityIndicadorView)
        
        setupConstraints()
        
        self.activityIndicadorView.isHidden = false
        self.activityIndicadorView.startAnimating()
        
        $searchText
            .receive(on: DispatchQueue.main)
            .removeDuplicates()
            .debounce(for: 0.6, scheduler: RunLoop.main)
            .sink { completion in
                
            } receiveValue: { [weak self] searchTextValue in
                self?.offsetPage = 0
                if searchTextValue.isEmpty {
                    self?.presenter?.requestListMarvelHQ(startTitleComic: nil,offsetPage: self?.offsetPage)
                } else {
                    self?.presenter?.requestListMarvelHQ(startTitleComic: searchTextValue,offsetPage: self?.offsetPage)
                }
                
            }
            .store(in: &cancelable)
        
        presenter?.updateListMarvelHQ()?.receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                
            }, receiveValue: { [weak self] marvelHQModel in
                
                if let loading = self?.isLoadingFooter {
                    if loading {
                        self?.isLoadingFooter = false
                        self?.indicatorActivityFooter.stopAnimating()
                        self?.indicatorActivityFooter.isHidden = true
                    }
                    
                    if let offset = self?.offsetPage, offset == 0{
                        self?.marvelHQs = []
                    }
                }
                
                if !marvelHQModel.data.results.isEmpty {
                    self?.activityIndicadorView.isHidden = true
                    self?.activityIndicadorView.stopAnimating()
                }
                
                self?.marvelHQs.append(contentsOf: marvelHQModel.data.results)
                self?.collectionComicsMarvelHQ.reloadData()
            })
            .store(in: &cancelable)
        

    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            activityIndicadorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicadorView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func setupConfigCollectionView(){
        
    }
    
    @objc func actionCart(_ action: UIAction){}
}

extension MarvelScreenMainViewController: UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.marvelHQs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MarvelHQCollectionCell
        let comic = self.marvelHQs[indexPath.row]
        cell.setTitle(title: comic.title)
        cell.setThund(thumbnail: comic.thumbnail)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.view.frame.width / 2) - 15
        let height = (self.view.frame.height / 3) - 20
        return CGSize(width: width, height: height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let comic = self.marvelHQs[indexPath.row]
        presenter?.showMarvelDetailScreen(comic: comic,navigation: self.navigationController)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            self.cellFooter = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FooterViewIdentifier", for: indexPath)
            
            self.cellFooter?.subviews.forEach{ $0.removeFromSuperview() }
            
            indicatorActivityFooter.center = CGPoint(x: self.cellFooter?.center.x ?? 0, y: 50)
            self.cellFooter?.addSubview(indicatorActivityFooter)
            
            return self.cellFooter ?? UICollectionReusableView()
        }
        return UICollectionReusableView()
    }
    
    private func addLoadingFooterToCollectionView() -> UIView{
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.collectionComicsMarvelHQ.bounds.width, height: 60))
        
        indicatorActivityFooter.hidesWhenStopped = true
        indicatorActivityFooter.center = view.center
        view.addSubview(indicatorActivityFooter)
        indicatorActivityFooter.startAnimating()
        
        return view
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height // get size contentSize Scroll
        let visibleheight = scrollView.bounds.size.height // get size bound size screen

        if offsetY > (contentHeight - visibleheight + 100) && contentHeight > 0 {
            
            guard !isLoadingFooter else { return }
            
            isLoadingFooter = true
            self.indicatorActivityFooter.startAnimating()
            self.indicatorActivityFooter.isHidden = false
            
            self.offsetPage = self.marvelHQs.count
            
            DispatchQueue.main.async {
                
                self.presenter?.requestListMarvelHQ(startTitleComic: self.searchText, offsetPage: self.offsetPage)
                
            }
        }
        
    }
    
}


extension MarvelScreenMainViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        self.resetMarvelHQs()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchText = ""
    }
    
    func resetMarvelHQs(){
        if !self.searchText.isEmpty {
            self.activityIndicadorView.isHidden = false
            self.activityIndicadorView.startAnimating()
            self.marvelHQs = []
            self.collectionComicsMarvelHQ.reloadData()
        }
    }
    
}
