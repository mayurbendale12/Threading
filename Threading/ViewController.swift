import UIKit

class ViewController: UIViewController {
    @IBAction private func didTapGCDButton(_ sender: AnyObject) {
        performSegue(withIdentifier: "GCD", sender: nil)
    }

    @IBAction private func didTapOperationButton(_ sender: AnyObject) {
        performSegue(withIdentifier: "Operation", sender: nil)
    }

    @IBAction private func didTapActorButton(_ sender: AnyObject) {
        performSegue(withIdentifier: "Actor", sender: nil)
    }
}
