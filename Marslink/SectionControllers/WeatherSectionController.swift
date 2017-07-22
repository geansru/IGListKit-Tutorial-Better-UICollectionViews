//
//  WeatherSectionController.swift
//  Marslink
//
//  Created by Dmitriy Roytman on 22.07.17.
//  Copyright © 2017 Ray Wenderlich. All rights reserved.
//

import IGListKit

final class WeatherSectionController: IGListSectionController {
    var weather: Weather!
    var expanded = false
    override init() {
        super.init()
        inset = UIEdgeInsetsMake(10, 10, 15, 10)
    }
}


extension WeatherSectionController: IGListSectionType {
    func numberOfItems() -> Int {
        return expanded ? 5 : 1
    }
    
    func sizeForItem(at index: Int) -> CGSize {
        guard let width = collectionContext?.containerSize.width else { return .zero }
        return CGSize(width: width, height: index == 0 ? 70 : 40 )
    }
    
    func cellForItem(at index: Int) -> UICollectionViewCell {
        let cellClass: AnyClass = index == 0 ? WeatherSummaryCell.self : WeatherDetailCell.self
        let cell = collectionContext!.dequeueReusableCell(of: cellClass, for: self, at: index)
        if let cell = cell as? WeatherSummaryCell {
            cell.setExpanded(expanded)
        }
        if let cell = cell as? WeatherDetailCell {
            let title: String, detail: String
            switch index {
            case 1: title = "SUNRISE" ; detail = weather.sunrise
            case 2: title = "SUNSET" ; detail = weather.sunset
            case 3: title = "HIGH" ; detail = "\(weather.high) C"
            case 4: title = "LOW" ; detail = "\(weather.low) C"
            default: title = "n/a"; detail = "n/a"
            }
            cell.titleLabel.text = title
            cell.detailLabel.text = detail
        }
        return cell
    }
    
    func didUpdate(to object: Any) {
        weather = object as? Weather
    }
    
    func didSelectItem(at index: Int) {
        expanded = !expanded
        collectionContext?.reload(self)
    }
    
    
}
