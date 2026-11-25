import UIKit

/// A short message, with an optional icon, that appears in the middle of the screen and fades away.
///
/// ```swift
/// await FeedbackAlert("Saved", icon: .success).show(in: view)
/// ```
public struct FeedbackAlert: Identifiable {
    public enum Icon {
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

    /// Shows the alert in the window of `view` and returns once it has disappeared.
    ///
    /// Alerts show one at a time, in the order they were requested. Cancelling the task
    /// removes a waiting alert or dismisses the visible one. Nothing is shown if `view`
    /// isn't in a window when the alert's turn comes.
    @MainActor
    public func show(in view: UIView) async {
        await AlertPresenter.shared.show(self, in: view)
    }
}
