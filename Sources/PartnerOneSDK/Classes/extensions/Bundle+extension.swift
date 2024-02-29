import Foundation

extension Bundle {
    class func getBundle() -> Bundle {
        print("Bundle \(Bundle(for: BaseViewController.self))")
        print("Bundle \(Bundle.allBundles)")
        
        return Bundle.module // Bundle(for: BaseViewController.self)
    }
}
