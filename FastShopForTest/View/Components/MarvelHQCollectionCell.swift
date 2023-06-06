//
//  MarvelHQCollectionCell.swift
//  FastShopForTest
//
//  Created by ACT on 05/06/23.
//

import Foundation
import UIKit

class MarvelHQCollectionCell: UICollectionViewCell {
    
    lazy var imageView: UIImageView =  {
        let image = UIImageView(image: UIImage(named: "marvel"))
        image.contentMode = UIView.ContentMode.scaleAspectFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    
    let labelName: UILabel = {
        let label = UILabel()
        label.text = "Marvel Comics - HQ Welcome."
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = UIColor.black
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .equalCentering
        stack.axis = .vertical
        stack.spacing = 5
        stack.clipsToBounds = true
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        stack.addArrangedSubview(imageView)
        stack.addArrangedSubview(labelName)
        
        addSubview(stack)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
      
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: self.topAnchor),
            stack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            imageView.widthAnchor.constraint(equalTo: self.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: self.heightAnchor,multiplier: 0.9)
        ])
    }

}


// Motified
extension MarvelHQCollectionCell {
    
    func setTitle(title: String?){
        guard let title else { return }
        labelName.text = title
    }
    
    func setThund(thumbnail: [String:String]){
        
        guard let urlPath = thumbnail["path"], let ext = thumbnail["extension"], let url = URL(string: "\(urlPath).\(ext)") else {
            return 
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            if let data = try? Data(contentsOf: url){
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
        }
        
    }
    
}
