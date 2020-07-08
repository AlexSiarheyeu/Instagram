//
//  SearchController.swift
//  Instagram
//
//  Created by Alexey Sergeev on 7/8/20.
//  Copyright © 2020 Alexey Sergeev. All rights reserved.
//

import UIKit

class SearchController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    
    let searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = "Enter search text"
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        
        guard let navBar = navigationController?.navigationBar else { return }
        
        navigationController?.navigationBar.addSubview(searchBar)
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: navBar.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: navBar.trailingAnchor, constant: -8),
            searchBar.topAnchor.constraint(equalTo: navBar.topAnchor, constant: 8),
            searchBar.bottomAnchor.constraint(equalTo: navBar.bottomAnchor, constant: -8),
            ])
            
            collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cellId")
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath)
        cell.backgroundColor = .red
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        return CGSize(width: width, height: 50)
    }
}
