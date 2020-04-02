//
//  NewsViewController.swift
//  CoranaSeeker
//
//  Created by Ashli Rankin on 4/1/20.
//  Copyright © 2020 Ashli Rankin. All rights reserved.
//

import UIKit

/// `UIViewController ` which displays news articles.
final class NewsViewController: UIViewController {
    
    @IBOutlet private weak var newsCollectionView: UICollectionView!
    
    private var articles: [Article] {
        didSet {
            newsCollectionView.reloadData()
        }
    }
    
    /// Creates a new instance of `NewsViewController`.
    /// - Parameter articles: The articles that will be displayed.
    init(articles: [Article]) {
        self.articles = articles
        super.init(nibName: "NewsViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        newsCollectionView.register(UINib(nibName: "NewsCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "NewsCell")
        newsCollectionView.dataSource = self
    }
}

extension NewsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsCell", for: indexPath) as? NewsCollectionViewCell else {
            return UICollectionViewCell()
        }
        return cell
    }
    
    
}
