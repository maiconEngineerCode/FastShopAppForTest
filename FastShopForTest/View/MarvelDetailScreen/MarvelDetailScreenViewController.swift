//
//  MarvelDetailScreen.swift
//  FastShopForTest
//
//  Created by ACT on 05/06/23.
//

import Foundation
import UIKit

protocol MarvelDetailScreenViewControllerProtocol {
    var marvelHQComic: MarvelHQComic? { get set }
}

class MarvelDetailScreenViewController: UIViewController, MarvelDetailScreenViewControllerProtocol {
    
    var marvelHQComic: MarvelHQComic? {
        didSet {
            labelTitle.text = marvelHQComic?.title
            labelID.text = "# \(marvelHQComic?.id ?? 0)"
            labelDescription.text = marvelHQComic?.description ?? ""
            setThund(thumbnail: marvelHQComic?.thumbnail)
        }
    }
    
    let imageViewThumbnail: UIImageView = {
        let image = UIImageView(image: UIImage(named: "marvel"))
        image.contentMode = UIView.ContentMode.scaleAspectFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let stackContainer: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 15
        stack.distribution = UIStackView.Distribution.fillProportionally
        stack.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        stack.isLayoutMarginsRelativeArrangement = true
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let labelTitle: UILabel = {
        let label = UILabel()
        label.text = "HQ Comic"
        label.font = UIFont.systemFont(ofSize: 14,weight: UIFont.Weight.bold)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let labelID: UILabel = {
        let label = UILabel()
        label.text = "# 0"
        label.font = UIFont.systemFont(ofSize: 20,weight: UIFont.Weight.bold)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let labelDescription: UILabel = {
        let label = UILabel()
        label.text = "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged"
        label.numberOfLines = 4
        label.font = UIFont.systemFont(ofSize: 12,weight: UIFont.Weight.semibold)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let labelPrice: UILabel = {
        let label = UILabel()
        label.text = "Price: 100$"
        label.font = UIFont.systemFont(ofSize: 10,weight: UIFont.Weight.bold)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let labelPriceDigital: UILabel = {
        let label = UILabel()
        label.text = "Digital Price: 100$"
        label.font = UIFont.systemFont(ofSize: 10,weight: UIFont.Weight.bold)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let stackDetails: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 5
        stack.distribution = UIStackView.Distribution.fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let buttonBuy: UIButton = {
        let button = UIButton(frame: .zero, primaryAction: UIAction(title: "") { action in
            print("sim")
        })
        button.setTitle("COMPRAR", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14,weight: UIFont.Weight.bold)
        button.backgroundColor = UIColor.systemPink
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Book Details"
        
        stackContainer.addArrangedSubview(imageViewThumbnail)
        
        stackDetails.addArrangedSubview(labelTitle)
        stackDetails.addArrangedSubview(labelID)
        stackDetails.addArrangedSubview(labelDescription)
        stackDetails.addArrangedSubview(labelPrice)
        stackDetails.addArrangedSubview(labelPriceDigital)
        stackDetails.addArrangedSubview(buttonBuy)
        
        stackContainer.addArrangedSubview(stackDetails)
        
        view.addSubview(stackContainer)
        
        setupConstrainsts()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func setupConstrainsts(){
        NSLayoutConstraint.activate([
            stackContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            imageViewThumbnail.widthAnchor.constraint(equalToConstant: 140),
            imageViewThumbnail.heightAnchor.constraint(equalToConstant: 220),
            
            buttonBuy.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
   
}


extension MarvelDetailScreenViewController {
    
    func setThund(thumbnail: [String:String]?){
        
        guard let thumb = thumbnail, let urlPath = thumb["path"], let ext = thumb["extension"], let url = URL(string: "\(urlPath).\(ext)") else {
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            if let data = try? Data(contentsOf: url){
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    self.imageViewThumbnail.image = image
                }
            }
        }
        
    }
}
