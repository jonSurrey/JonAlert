import Testing
@testable import JonAlert

struct AlertQueueTests {
    private struct Alert: Identifiable, Equatable {
        let id: Int
    }

    private func makeQueue(enqueuing ids: ClosedRange<Int>) -> AlertQueue<Alert> {
        var queue = AlertQueue<Alert>()
        for id in ids {
            _ = queue.enqueue(Alert(id: id))
        }
        return queue
    }

    @Test("The first alert shows right away")
    func firstAlertShowsRightAway() {
        var queue = AlertQueue<Alert>()
        let showsNow = queue.enqueue(Alert(id: 1))
        #expect(showsNow)
        #expect(queue.isShowing)
        #expect(queue.waiting.isEmpty)
    }

    @Test("An alert queued while another is showing waits its turn")
    func alertWaitsWhileAnotherShows() {
        var queue = makeQueue(enqueuing: 1...1)
        let showsNow = queue.enqueue(Alert(id: 2))
        #expect(!showsNow)
        #expect(queue.waiting == [Alert(id: 2)])
    }

    @Test("Waiting alerts get their turn in the order they were queued")
    func waitingAlertsShowInOrder() {
        var queue = makeQueue(enqueuing: 1...3)
        let second = queue.finishShowing()
        let third = queue.finishShowing()
        #expect(second == Alert(id: 2))
        #expect(third == Alert(id: 3))
    }

    @Test("Finishing the last alert leaves nothing showing")
    func finishingLastAlertEmptiesQueue() {
        var queue = makeQueue(enqueuing: 1...1)
        let next = queue.finishShowing()
        #expect(next == nil)
        #expect(!queue.isShowing)
    }

    @Test("Once nothing is showing, the next alert shows right away")
    func alertShowsRightAwayAfterQueueEmpties() {
        var queue = makeQueue(enqueuing: 1...1)
        _ = queue.finishShowing()
        let showsNow = queue.enqueue(Alert(id: 2))
        #expect(showsNow)
    }

    @Test("A removed waiting alert never gets a turn")
    func removedAlertNeverShows() {
        var queue = makeQueue(enqueuing: 1...3)
        let removed = queue.removeWaiting(id: 2)
        let next = queue.finishShowing()
        #expect(removed == Alert(id: 2))
        #expect(next == Alert(id: 3))
    }

    @Test("Removing an alert that isn't waiting changes nothing")
    func removingAlertNotWaitingChangesNothing() {
        var queue = makeQueue(enqueuing: 1...2)
        let removedShowing = queue.removeWaiting(id: 1)
        let removedUnknown = queue.removeWaiting(id: 9)
        #expect(removedShowing == nil)
        #expect(removedUnknown == nil)
        #expect(queue.isShowing)
        #expect(queue.waiting == [Alert(id: 2)])
    }
}
