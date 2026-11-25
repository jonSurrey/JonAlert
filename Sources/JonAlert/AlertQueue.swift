struct AlertQueue<Item: Identifiable> {
    private(set) var isShowing = false
    private(set) var waiting: [Item] = []

    mutating func enqueue(_ item: Item) -> Bool {
        if isShowing {
            waiting.append(item)
            return false
        }
        isShowing = true
        return true
    }

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
