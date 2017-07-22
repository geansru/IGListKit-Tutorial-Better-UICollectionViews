//
//  JournalSectionController.swift
//  Marslink
//
//  Created by Dmitriy Roytman on 22.07.17.
//  Copyright © 2017 Ray Wenderlich. All rights reserved.
//

import IGListKit

final class JournalSectionController: IGListSectionController {
    var entry: JournalEntry!
    var solFormatter = SolFormatter()
    override init() {
        super.init()
        inset = UIEdgeInsetsMake(0, 0, 15, 0)
    }
}

extension JournalSectionController: IGListSectionType {
    func numberOfItems() -> Int {
        return 2
    }
    
    func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext, let entry = entry else { return .zero }
        let width = context.containerSize.width
        return index == 0 ? CGSize(width: width, height: 30) :
         JournalEntryCell.cellSize(width: width, text: entry.text)
    }
    
    func cellForItem(at index: Int) -> UICollectionViewCell {
        // TODO: Try to remove AnyClass
        let cellClass: AnyClass = index == 0 ? JournalEntryDateCell.self : JournalEntryCell.self
        let cell = collectionContext!.dequeueReusableCell(of: cellClass, for: self, at: index)
        if let cell = cell as? JournalEntryDateCell {
            cell.label.text = "SOL \(solFormatter.sols(fromDate: entry.date))"
        }
        if let cell = cell as? JournalEntryCell {
            cell.label.text = entry.text
        }
        return cell
    }
    
    func didUpdate(to object: Any) {
        entry = object as? JournalEntry
    }
    
    func didSelectItem(at index: Int) {
        // TODO: implement method didSelectItem
    }
}
