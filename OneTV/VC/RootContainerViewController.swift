import UIKit

final class RootContainerViewController: UIViewController {

    private let homeVC = Home()
    private let vpnVC = VPNBlockedViewController()
    private var currentVC: UIViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        switchTo(homeVC)
    }

    func update(vpnActive: Bool) {
        let target = vpnActive ? vpnVC : homeVC
        switchTo(target)
    }

    private func switchTo(_ vc: UIViewController) {
        guard currentVC !== vc else { return }

        currentVC?.willMove(toParent: nil)
        currentVC?.view.removeFromSuperview()
        currentVC?.removeFromParent()

        addChild(vc)
        vc.view.frame = view.bounds
        view.addSubview(vc.view)
        vc.didMove(toParent: self)

        currentVC = vc
    }
}
