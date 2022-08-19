//
//  FeedbackGenerator.swift
//  PartyHub
//
//  Created by Dinar Garaev on 18.08.2022.
//

import UIKit

protocol FeedbackGeneratorDescription {
    func errorFeedbackGenerator()
    func customFeedbackGeneration(_ style: UIImpactFeedbackGenerator.FeedbackStyle)
}

final class FeedbackGenerator {

    static let shared = FeedbackGenerator()

    private init() {}

    func errorFeedbackGenerator() {
        UINotificationFeedbackGenerator().notificationOccurred(.error)
    }

    func customFeedbackGeneration(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred(intensity: 0.6)
    }
}
