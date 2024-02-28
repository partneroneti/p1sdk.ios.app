import Foundation

extension Bundle {
    class func getBundle() -> Bundle {
        print("Bundle \(Bundle(for: BaseViewController.self))")
        return Bundle.module // Bundle(for: BaseViewController.self)
    }
}
