import UIKit

/// A short message, with an optional icon, that appears in the middle of the screen and fades away.
public struct FeedbackAlert: Identifiable, Sendable {
    public enum Icon: Sendable {
        case success
        case error
        /// Shown in its own colors unless its rendering mode is `.alwaysTemplate`.
        case custom(UIImage)
    }

    public let id = UUID()
    public let message: String
    public let icon: Icon?
    /// How long the alert stays fully visible, not counting its fade in and out.
    public let duration: Duration

    public init(_ message: String, icon: Icon? = nil, duration: Duration = .seconds(1)) {
        self.message = message
        self.icon = icon
        self.duration = duration
    }

    /// Waits its turn, shows in the window of `view`, and returns once gone; cancelling removes or dismisses it.
    @MainActor
    public func show(in view: UIView) async {
        await AlertPresenter.shared.show(self, in: view)
    }
}
