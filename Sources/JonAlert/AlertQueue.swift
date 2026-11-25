/// Lets one alert show at a time. The others wait in the order they arrived.
struct AlertQueue<Item: Identifiable> {
    private(set) var isShowing = false
    private(set) var waiting: [Item] = []

    /// Returns `true` when the item can show right away. Otherwise it waits for its turn.
    mutating func enqueue(_ item: Item) -> Bool {
        if isShowing {
            waiting.append(item)
            return false
        }
        isShowing = true
        return true
    }

    /// Ends the visible alert and returns the item whose turn it is now, if any.
    mutating func finishShowing() -> Item? {
        guard !waiting.isEmpty else {
            isShowing = false
            return nil
        }
        return waiting.removeFirst()
    }

    mutating func removeWaiting(id: Item.ID) -> Item? {
        guard let index = waiting.firstIndex(where: { $0.id == id }) else { return nil }
        return waiting.remove(at: index)
    }
}

extension AlertQueue: Sendable where Item: Sendable {}
