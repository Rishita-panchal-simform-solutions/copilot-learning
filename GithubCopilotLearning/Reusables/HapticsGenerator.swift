//
//  HapticsGenerator.swift
//  GithubCopilotLearning
//
//  Created by Rishita Panchal on 26/03/2026.
//  Copyright © 2026 Simform Solutions. All rights reserved.
//
import SwiftUI
import Combine
import CoreHaptics
final class HapticsGenerator {
    private let hapticEngine: CHHapticEngine?
    private var needsToRestart = false
    private let feedbackGenerator = UISelectionFeedbackGenerator()
    private var impactGenerator: UIImpactFeedbackGenerator?
    // MARK: - shared
    static let shared = HapticsGenerator()
    // MARK: - Init
    private init(
        supportsAudio: Bool = false
    ) {
        hapticEngine = try? CHHapticEngine()
        hapticEngine?.resetHandler = resetHandler
        hapticEngine?.stoppedHandler = restartHandler
        hapticEngine?.playsHapticsOnly = !supportsAudio
        try? start()
    }
}
// MARK: - Lifecycle Methods
extension HapticsGenerator {
    /// Stops the internal CHHapticEngine.
    ///
    /// Call this when the app enters the background.
    public func stop(completionHandler: CHHapticEngine.CompletionHandler? = nil) {
        hapticEngine?.stop(completionHandler: completionHandler)
    }
    /// Starts the internal CHHapticEngine.
    ///
    /// Call this when the app enters the foreground.
    func start() throws {
        try hapticEngine?.start()
        needsToRestart = false
    }
}
// MARK: - Player Methods
extension HapticsGenerator {
    func playTransientEvent(
        withIntensity intensity: Float = 1.0,
        sharpness: Float = 0.75
    ) throws {
        let event = CHHapticEvent(
            eventType: .hapticTransient,
            parameters: [
                CHHapticEventParameter(parameterID: .hapticIntensity, value: intensity),
                CHHapticEventParameter(parameterID: .hapticSharpness, value: sharpness)
            ],
            relativeTime: 0
        )
        let pattern = try CHHapticPattern(events: [event], parameters: [])
        let player = try hapticEngine?.makePlayer(with: pattern)
        if needsToRestart {
            try? start()
        }
        try player?.start(atTime: CHHapticTimeImmediate)
    }
    func selectionHaptic() {
        feedbackGenerator.selectionChanged()
    }
    func softHaptic() {
        playHapticThreadSafety(style: .light)
    }
    func softHaptic(with intensity: CGFloat) {
        playHapticThreadSafety(style: .soft, intensity: intensity)
    }
    func mediumHaptic(intensity: CGFloat = 1.0) {
        playHapticThreadSafety(style: .medium, intensity: intensity)
    }
    func heavyHaptic() {
        playHapticThreadSafety(style: .heavy, intensity: 1.0)
    }
    private func playHapticThreadSafety(
        style: UIImpactFeedbackGenerator.FeedbackStyle,
        intensity: CGFloat? = nil) {
        if Thread.isMainThread {
            playHaptic(style: style, intensity: intensity)
            return
        }
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.playHaptic(style: style, intensity: intensity)
        }
    }
    private func playHaptic(
        style: UIImpactFeedbackGenerator.FeedbackStyle,
        intensity: CGFloat?) {
        impactGenerator = UIImpactFeedbackGenerator(style: style)
        if let intensity {
            impactGenerator?.impactOccurred(intensity: intensity)
        } else {
            impactGenerator?.impactOccurred()
        }
    }
}
// MARK: - Private Helpers
private extension HapticsGenerator {
    /// Attempts to restart the engine.
    ///
    /// This will be called asynchronously if the Core Haptics engine has to reset
    /// itself after a server failure.
    ///
    ///  The system preserves `CHHapticPattern` objects and `CHHapticEngine`
    ///  properties across restarts.
    private func resetHandler() {
        do {
            try start()
        } catch {
            needsToRestart = true
        }
    }
    /// Attempts to restart the engine.
    ///
    /// This will be called asynchronously if the Core Haptics engine
    /// stops due to external causes such as  audio session interruption,
    /// application suspension, or system error.
    ///
    ///  The system preserves `CHHapticPattern` objects and `CHHapticEngine`
    ///  properties across restarts.
    private func restartHandler(_ reasonForStopping: CHHapticEngine.StoppedReason? = nil) {
        resetHandler()
    }
}