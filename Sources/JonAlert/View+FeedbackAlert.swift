import SwiftUI

extension View {
    /// Shows `alert` in this view's window whenever it is set, then sets it back to `nil`.
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
