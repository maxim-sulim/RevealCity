import Foundation

extension Double {
    func trunc(_ decimal:Int) -> String {
        String(format: "%.\(decimal)f", self)
    }
}
