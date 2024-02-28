import Foundation

extension Bundle {
    class func getBundle() -> Bundle {
        print("Bundle \(Bundle(for: BaseViewController.self))")
        return Bundle(for: BaseViewController.self)
    }
}
