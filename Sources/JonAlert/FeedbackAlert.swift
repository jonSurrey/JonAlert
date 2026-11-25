import UIKit

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
    public let duration: Duration

    public init(_ message: String, icon: Icon? = nil, duration: Duration = .seconds(1)) {
        self.message = message
        self.icon = icon
        self.duration = duration
    }

    /// Returns once the alert has gone. Cancelling the task removes or dismisses it.
    @MainActor
    public func show(in view: UIView) async {
        await AlertPresenter.shared.show(self, in: view)
    }
}
