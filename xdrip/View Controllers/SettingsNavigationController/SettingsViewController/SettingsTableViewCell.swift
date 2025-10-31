import UIKit

final class SettingsTableViewCell: UITableViewCell {

    /// Reuse identifier used in storyboard/xib
    static let reuseIdentifier = "SettingsTableViewCell"
    
    /// Optional container view inside the cell which will receive the rounded corners & shadow.
    /// In Interface Builder, add a UIView inside the cell's contentView, inset it (8-16pt) and connect to this outlet.
    /// If not connected, the cell will apply a softer shadow to the contentView itself.
    @IBOutlet weak var cardView: UIView?
    
    /// Inner clipping container (optional). If you need subviews clipped to the rounded corners, add another view inside cardView and connect it.
    @IBOutlet weak var innerClipView: UIView?

    /// Visual constants — adjust to taste
    private struct Visual {
        static let cornerRadius: CGFloat = 10
        static let shadowOffset = CGSize(width: 0, height: 3)
        static let shadowRadius: CGFloat = 6
        // color alpha is handled via UIColor dynamic provider (dark/light mode)
        static let shadowAlphaLight: CGFloat = 0.18
        static let shadowAlphaDark: CGFloat  = 0.35
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Make sure the table row background is clear so shadow is visible
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        configureCardAppearance()
    }

    private func configureCardAppearance() {
        let target = cardView ?? contentView

        // Background color should match system background so it looks like a card
        target.backgroundColor = UIColor { trait in
            // use systemBackground so it adapts with dark mode
            return UIColor.systemBackground
        }

        // Corner radius
        target.layer.cornerRadius = Visual.cornerRadius
        // Do NOT set masksToBounds on the view that has the shadow
        target.layer.masksToBounds = false

        // Shadow color with dynamic alpha for dark mode friendliness
        let shadowAlpha = UIColor { trait -> UIColor in
            return UIColor.black.withAlphaComponent(trait.userInterfaceStyle == .dark ? Visual.shadowAlphaDark : Visual.shadowAlphaLight)
        }

        target.layer.shadowColor = shadowAlpha.cgColor
        // Use full shadowOpacity = 1.0; color alpha controls actual darkness
        target.layer.shadowOpacity = 1.0
        target.layer.shadowOffset = Visual.shadowOffset
        target.layer.shadowRadius = Visual.shadowRadius

        // If you need inner content clipped to rounded corners, enable masks on the innerClipView
        if let inner = innerClipView {
            inner.layer.cornerRadius = Visual.cornerRadius
            inner.layer.masksToBounds = true
            inner.backgroundColor = .clear
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // Update shadowPath for performance and crisp shadows
        let target = cardView ?? contentView
        let corner = target.layer.cornerRadius
        target.layer.shadowPath = UIBezierPath(roundedRect: target.bounds, cornerRadius: corner).cgPath

        // Rasterize for improved scrolling performance (careful if content changes often)
        target.layer.shouldRasterize = true
        target.layer.rasterizationScale = UIScreen.main.scale
    }

    // Optional: remove default selection highlight or provide custom background
    override func setSelected(_ selected: Bool, animated: Bool) {
        // keep default behavior but avoid cell content jumping; no changes required here unless you want a custom highlight
        super.setSelected(selected, animated: animated)
    }

}