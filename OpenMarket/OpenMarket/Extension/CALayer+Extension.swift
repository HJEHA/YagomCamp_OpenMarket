import UIKit

extension CALayer {
    @discardableResult
    func addBorder(_ edges: [UIRectEdge], color: UIColor, width: CGFloat = 1.0, radius: CGFloat = 10.0) -> CALayer {
        let border = CALayer()
        for edge in edges {
            switch edge {
            case .top:
                border.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: width)
            case .bottom:
                border.frame = CGRect.init(x: 0, y: frame.height - width, width: frame.width, height: width)
            case .left:
                border.frame = CGRect.init(x: 0, y: 0, width: width, height: frame.height)
            case .right:
                border.frame = CGRect.init(x: frame.width - width, y: 0, width: width, height: frame.height)
            case .all:
                borderColor = color.cgColor
                cornerRadius = radius
                borderWidth = width
            default:
                break
            }
            border.backgroundColor = color.cgColor
        }
        return border
    }
}
