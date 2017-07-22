//
//  MessageSectionController.swift
//  Marslink
//
//  Created by Dmitriy Roytman on 22.07.17.
//  Copyright © 2017 Ray Wenderlich. All rights reserved.
//

import IGListKit

final class MessageSectionController: IGListSectionController {
    var entry: Message!
    override init() {
        super.init()
        inset = UIEdgeInsetsMake(10, 10, 15, 10)
    }
}

extension MessageSectionController: IGListSectionType {
    func numberOfItems() -> Int {
        return 1
    }
    
    func sizeForItem(at index: Int) -> CGSize {
        guard let text = entry?.text, let width = collectionContext?.containerSize.width else { return .zero }
        return MessageCell.cellSize(width: width, text: text)
    }
    
    func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeueReusableCell(of: MessageCell.self, for: self, at: index) as! MessageCell
        cell.messageLabel.text = entry.text
        cell.titleLabel.text = entry.user.name.uppercased()
        return cell
    }
    
    func didUpdate(to object: Any) {
        guard let message = object as? Message  else { return }
        entry = message
    }
    
    func didSelectItem(at index: Int) {
        
    }
}
