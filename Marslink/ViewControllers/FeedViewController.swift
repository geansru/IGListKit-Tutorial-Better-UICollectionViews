//
//  FeedViewController.swift
//  Marslink
//
//  Created by Dmitriy Roytman on 22.07.17.
//  Copyright © 2017 Ray Wenderlich. All rights reserved.
//

import IGListKit
import UIKit

final class FeedViewController: UIViewController {
    let loader = JournalEntryLoader()
    let pathfinder = Pathfinder()
    let wxScanner = WxScanner()
    
    let collectionView: IGListCollectionView = {
        let collectionView = IGListCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .black
        return collectionView
    }()
    lazy var adapter: IGListAdapter = {
       return IGListAdapter(updater: IGListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loader.loadLatest()
        view.addSubview(collectionView)
        adapter.collectionView = collectionView
        adapter.dataSource = self
        pathfinder.delegate = self
        pathfinder.connect()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
}

extension FeedViewController: IGListAdapterDataSource {
    func objects(for listAdapter: IGListAdapter) -> [IGListDiffable] {
        var entries: [IGListDiffable] = [wxScanner.currentWeather]
        entries += pathfinder.messages as [IGListDiffable]
        entries += loader.entries as [IGListDiffable]
        return entries.sorted { (lhs: Any, rhs: Any) -> Bool in
            guard let lhs = lhs as? DateSortable, let rhs = rhs as? DateSortable else { return false }
            return lhs.date > rhs.date
        }
    }
    
    func listAdapter(_ listAdapter: IGListAdapter, sectionControllerFor object: Any) -> IGListSectionController {
        if object is Message {
            return MessageSectionController()
        } else if object is Weather {
            return WeatherSectionController()
        } else {
            return JournalSectionController()
        }
    }
    
    func emptyView(for listAdapter: IGListAdapter) -> UIView? {
        return nil
    }
}

extension FeedViewController: PathfinderDelegate {
    func pathfinderDidUpdateMessages(pathfinder: Pathfinder) {
        adapter.performUpdates(animated: true)
    }
}
