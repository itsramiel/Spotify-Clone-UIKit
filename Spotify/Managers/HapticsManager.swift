//
//  HapticsManager.swift
//  Spotify
//
//  Created by Rami Elwan on 23.07.24.
//

import Foundation
import UIKit

final class HapticsManager {
    static let shared = HapticsManager()
    
    private let selectionGenerator = {
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        
        return generator
    }()
    
    private let feedbackGenerator = {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        
        return generator
    }()

    
    private init() { }
    
    public func select() {
        DispatchQueue.main.async {
            self.selectionGenerator.selectionChanged()
        }
    }
    
    public func feedback(type: UINotificationFeedbackGenerator.FeedbackType) {
        DispatchQueue.main.async {
            self.feedbackGenerator.notificationOccurred(type)
        }
    }
}
