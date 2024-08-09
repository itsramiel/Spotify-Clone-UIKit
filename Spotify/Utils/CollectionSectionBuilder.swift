//
//  CollectionSectionBuilder.swift
//  Spotify
//
//  Created by Rami Elwan on 08.08.24.
//

import UIKit

struct CollectionSectionBuilder {
    static func getTracksSection() -> NSCollectionLayoutSection {
        let size = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1), heightDimension: .estimated(64)
        )

        let item = NSCollectionLayoutItem(layoutSize: size)

        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: size,
            subitems: Array(repeating: item, count: 1)
        )

        return NSCollectionLayoutSection(group: group)
    }
    
    static func getCoverHeaderSupplementaryItem() -> NSCollectionLayoutBoundarySupplementaryItem {
        return NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1)
            ),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )

    }
}
