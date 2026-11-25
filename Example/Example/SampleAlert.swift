import JonAlert
import UIKit

enum SampleAlert: CaseIterable {
    case message
    case success
    case error
    case customIcon
    case longMessage

    static let footer = "Tap several rows quickly: the alerts wait their turn."

    var title: String {
        switch self {
        case .message: "Message only"
        case .success: "Success"
        case .error: "Error"
        case .customIcon: "Custom icon"
        case .longMessage: "Long message"
        }
    }

    var symbolName: String {
        switch self {
        case .message: "text.bubble"
        case .success: "checkmark.circle"
        case .error: "xmark.circle"
        case .customIcon: "heart"
        case .longMessage: "text.alignleft"
        }
    }

    func makeAlert() -> FeedbackAlert {
        switch self {
        case .message:
            FeedbackAlert("Link copied")
        case .success:
            FeedbackAlert("Added to your library", icon: .success)
        case .error:
            FeedbackAlert("Couldn't connect", icon: .error)
        case .customIcon:
            FeedbackAlert("Added to favorites", icon: Self.heart.map(FeedbackAlert.Icon.custom))
        case .longMessage:
            FeedbackAlert(
                "Your playlist was saved and will be available offline once the download finishes.",
                icon: .success,
                duration: .seconds(2)
            )
        }
    }

    private static let heart = UIImage(systemName: "heart.fill")?
        .withTintColor(.systemPink, renderingMode: .alwaysOriginal)
}
