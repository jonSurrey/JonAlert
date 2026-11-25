import SwiftUI

extension View {
    /// Shows `alert` whenever it is set, in this view's window. Sets it back to `nil` once
    /// that alert has disappeared.
    ///
    /// ```swift
    /// @State private var alert: FeedbackAlert?
    ///
    /// Button("Save") { alert = FeedbackAlert("Saved", icon: .success) }
    ///     .feedbackAlert(item: $alert)
    /// ```
    public func feedbackAlert(item alert: Binding<FeedbackAlert?>) -> some View {
        background(FeedbackAlertHost(alert: alert))
    }
}

private struct FeedbackAlertHost: UIViewRepresentable {
    @Binding var alert: FeedbackAlert?

    final class Coordinator {
        var shownAlertID: FeedbackAlert.ID?
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.isUserInteractionEnabled = false
        return view
    }

    func updateUIView(_ view: UIView, context: Context) {
        guard let alert else {
            context.coordinator.shownAlertID = nil
            return
        }
        guard alert.id != context.coordinator.shownAlertID else { return }
        context.coordinator.shownAlertID = alert.id

        Task {
            await alert.show(in: view)
            if self.alert?.id == alert.id {
                self.alert = nil
            }
        }
    }
}
