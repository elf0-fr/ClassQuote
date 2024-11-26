//
//  QuoteStack.swift
//  ClassQuote
//
//  Created by Romain Tirbisch on 25/11/2024.
//

import UIKit

class QuoteStack: UIStackView {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var quoteLabel: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    
    var quote = "" {
        didSet {
            quoteLabel.text = quote
        }
    }
    
    var author = "" {
        didSet {
            authorLabel.text = author
        }
    }
    
    var image = UIImage() {
        didSet {
            imageView.image = image
        }
    }
    
    func displayShadowToQuoteLabel() {
        quoteLabel.layer.shadowColor = UIColor.black.cgColor
        quoteLabel.layer.shadowOpacity = 0.9
        quoteLabel.layer.shadowOffset = CGSize(width: 1, height: 1)
    }
}
