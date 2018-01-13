//
//  StoryboardExt.swift
//  king-tide
//
//  Created by Erick Barbosa on 1/13/18.
//  Copyright © 2018 Alexandra Saldana. All rights reserved.
//

import UIKit

public extension UIStoryboard {

  public static var mainStoryboard: UIStoryboard? {
    let bundle = Bundle.main
    guard let name = bundle.object(forInfoDictionaryKey: "UIMainStoryboardFile") as? String else { return nil }
    return UIStoryboard(name: name, bundle: bundle)
  }

  public func instantiateViewController<T: UIViewController>(withClass name: T.Type) -> T? {
    return instantiateViewController(withIdentifier: String(describing: name)) as? T
  }
}
