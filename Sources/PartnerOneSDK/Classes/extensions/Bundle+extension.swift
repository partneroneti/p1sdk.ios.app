import Foundation

extension Bundle {
    class func getBundle() -> Bundle {
        return Bundle.module // Bundle(for: BaseViewController.self)
    }
}
