import JonAlert
import SwiftUI
import UIKit

struct UIKitExampleView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UINavigationController {
        UINavigationController(rootViewController: UIKitExampleViewController())
    }

    func updateUIViewController(_ controller: UINavigationController, context: Context) {}
}

final class UIKitExampleViewController: UITableViewController {
    private static let reuseIdentifier = "SampleCell"
    private let samples = SampleAlert.allCases

    init() {
        super.init(style: .insetGrouped)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "UIKit"
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Self.reuseIdentifier)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        samples.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.reuseIdentifier, for: indexPath)
        let sample = samples[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = sample.title
        content.image = UIImage(systemName: sample.symbolName)
        cell.contentConfiguration = content
        return cell
    }

    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        SampleAlert.footer
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let alert = samples[indexPath.row].makeAlert()
        Task {
            await alert.show(in: view)
        }
    }
}
