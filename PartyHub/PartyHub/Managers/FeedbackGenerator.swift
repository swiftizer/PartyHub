//
//  FeedbackGenerator.swift
//  PartyHub
//
//  Created by Dinar Garaev on 18.08.2022.
//

import UIKit

final class FeedbackGenerator {

    static let shared = FeedbackGenerator()

    private init() {}

    func feedbackGeneration(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred(intensity: 0.6)
    }
}
