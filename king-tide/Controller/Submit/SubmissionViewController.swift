//
//  SubmissionViewController.swift
//  king-tide
//
//  Created by Alexandra Saldana on 11/21/17.
//  Copyright © 2017 Alexandra Saldana. All rights reserved.
//

import UIKit

class SubmissionViewController: UIViewController {
  @IBOutlet weak var statusLabel: UILabel!

  @IBOutlet weak var enterAnotherButton: UIButton!
  @IBOutlet weak var spinner: UIActivityIndicatorView!
  @IBOutlet weak var blur: UIVisualEffectView!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    self.spinner.startAnimating()
    NotificationCenter.default.addObserver(self, selector: #selector(self.stopSpinner(notification:)), name: Notification.Name.Readings.success, object: nil)

    NotificationCenter.default.addObserver(self, selector: #selector(self.stopSpinner(notification:)), name: Notification.Name.Readings.fail, object: nil)
  }

  @IBAction func enterButton(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }

  @objc func stopSpinner(notification: Notification) {

    if notification.name == Notification.Name.Readings.fail {
      DispatchQueue.main.async {
        self.statusLabel.text = "Something went wrong"
        self.enterAnotherButton.attributedTitle(for: .normal)
        self.enterAnotherButton.titleLabel?.text = "Try Again!"
        self.spinner.stopAnimating()
        self.blur.isHidden = true
        return
      }

    } else {
      DispatchQueue.main.async {
        self.spinner.stopAnimating()
        self.blur.isHidden = true
      }
    }

  }


}
extension Notification.Name {
  struct Readings {
    static let success = Notification.Name("successPost")
    static let fail = Notification.Name("fail")
  }
  struct Photo {
    static let success = Notification.Name("successUpload")
    static let fail = Notification.Name("fail")
  }

}
