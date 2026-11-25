import UIKit

final class AlertView: UIView {
    private static let cornerRadius: CGFloat = 12
    private static let padding: CGFloat = 20
    private static let spacing: CGFloat = 10
    private static let iconSide: CGFloat = 36
    private static let minimumWidth: CGFloat = 150
    private static let maximumWidth: CGFloat = 260
    private static let screenMargin: CGFloat = 32
    private static let backgroundOpacity: CGFloat = 0.9
    private static let fadeDuration: TimeInterval = 0.2
    private static let slideDistance: CGFloat = 24
    private static let textMetrics = UIFontMetrics(forTextStyle: .headline)

    private let message: String

    init(alert: FeedbackAlert) {
        message = alert.message
        super.init(frame: .zero)

        isUserInteractionEnabled = false
        accessibilityElementsHidden = true
        backgroundColor = .label.withAlphaComponent(Self.backgroundOpacity)
        layer.cornerRadius = Self.cornerRadius
        layer.cornerCurve = .continuous

        let stack = UIStackView(arrangedSubviews: [Self.label(for: alert.message)])
        if let image = Self.image(for: alert.icon) {
            stack.insertArrangedSubview(Self.imageView(for: image), at: 0)
        }
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = Self.spacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor, constant: Self.padding),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Self.padding),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Self.padding),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Self.padding)
        ])
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }

    func appear(in window: UIWindow) async {
        alpha = 0
        translatesAutoresizingMaskIntoConstraints = false
        window.addSubview(self)

        let safeArea = window.safeAreaLayoutGuide
        let minimumWidth = widthAnchor.constraint(greaterThanOrEqualToConstant: Self.minimumWidth)
        minimumWidth.priority = .defaultHigh
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            minimumWidth,
            widthAnchor.constraint(lessThanOrEqualToConstant: Self.textMetrics.scaledValue(for: Self.maximumWidth)),
            widthAnchor.constraint(lessThanOrEqualTo: safeArea.widthAnchor, constant: -2 * Self.screenMargin),
            heightAnchor.constraint(lessThanOrEqualTo: safeArea.heightAnchor, constant: -2 * Self.screenMargin)
        ])

        UIAccessibility.post(notification: .announcement, argument: message)
        await Self.animate(options: .curveEaseOut) {
            self.alpha = 1
        }
    }

    func disappear() async {
        let slides = !UIAccessibility.isReduceMotionEnabled
        await Self.animate(options: .curveEaseIn) {
            self.alpha = 0
            if slides {
                self.transform = CGAffineTransform(translationX: 0, y: Self.slideDistance)
            }
        }
        removeFromSuperview()
    }

    private static func animate(options: UIView.AnimationOptions, _ changes: @escaping () -> Void) async {
        await withCheckedContinuation { continuation in
            UIView.animate(withDuration: fadeDuration, delay: 0, options: options, animations: changes) { _ in
                continuation.resume()
            }
        }
    }

    private static func label(for message: String) -> UILabel {
        let label = UILabel()
        label.text = message
        label.font = .preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .systemBackground
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }

    private static func imageView(for image: UIImage) -> UIImageView {
        let imageView = UIImageView(image: image)
        imageView.tintColor = .systemBackground
        imageView.contentMode = .scaleAspectFit
        imageView.preferredSymbolConfiguration = UIImage.SymbolConfiguration(weight: .semibold)

        let side = textMetrics.scaledValue(for: iconSide)
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: side),
            imageView.heightAnchor.constraint(equalToConstant: side)
        ])
        return imageView
    }

    private static func image(for icon: FeedbackAlert.Icon?) -> UIImage? {
        switch icon {
        case .success: UIImage(systemName: "checkmark")
        case .error: UIImage(systemName: "xmark")
        case .custom(let image): image
        case nil: nil
        }
    }
}
