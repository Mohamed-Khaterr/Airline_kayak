//
//  ImageView+Extension.swift
//  Airlines
//
//  Created by Khater on 25/12/2023.
//

import UIKit
import SDWebImage

extension UIImageView {
    func setImage(with urlString: String) {
        sd_setImage(with: KayakEndpoint.logo(urlString).url)
    }
}
