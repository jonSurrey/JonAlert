import UIKit

@MainActor
final class AlertPresenter {
    static let shared = AlertPresenter()

    private struct Turn: Identifiable {
        let id: UUID
        let continuation: CheckedContinuation<Bool, Never>
    }

    private var queue = AlertQueue<Turn>()

    func show(_ alert: FeedbackAlert, in view: UIView) async {
        guard await waitForTurn() else { return }
        defer { passTurn() }
        guard !Task.isCancelled, let window = view.window else { return }

        let alertView = AlertView(alert: alert)
        await alertView.appear(in: window)
        // Cancellation ends the sleep early, which dismisses the alert.
        try? await Task.sleep(for: alert.duration)
        await alertView.disappear()
    }

    private func waitForTurn() async -> Bool {
        let id = UUID()
        return await withTaskCancellationHandler {
            await withCheckedContinuation { continuation in
                if queue.enqueue(Turn(id: id, continuation: continuation)) {
                    continuation.resume(returning: true)
                }
            }
        } onCancel: {
            Task { @MainActor in self.stopWaiting(id) }
        }
    }

    private func stopWaiting(_ id: UUID) {
        queue.removeWaiting(id: id)?.continuation.resume(returning: false)
    }

    private func passTurn() {
        queue.finishShowing()?.continuation.resume(returning: true)
    }
}
