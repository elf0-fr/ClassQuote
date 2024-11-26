//
//  ViewController.swift
//  ClassQuote
//
//  Created by Romain Tirbisch on 24/11/2024.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var quoteStack: QuoteStack!
    @IBOutlet private weak var newQuoteButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        quoteStack.displayShadowToQuoteLabel()
        displayNewQuote()
    }
    
    @IBAction func didTapNewQuoteButton() {
        displayNewQuote()
    }
    
    private func displayNewQuote() {
        toggleActivityIndicator(shown: true)
        
        QuoteService.shared.getQuote { success, quote in
            self.toggleActivityIndicator(shown: false)
            
            guard success == true, let quote else {
                self.presentAlert()
                return
            }
            
            self.updateQuote(quote)
        }
    }
    
    private func toggleActivityIndicator(shown: Bool) {
        newQuoteButton.isHidden = shown
        activityIndicator.isHidden = !shown
    }
    
    private func updateQuote(_ quote: QuoteModel) {
        self.quoteStack.quote = quote.quote
        self.quoteStack.author = quote.author
        self.quoteStack.image = UIImage(data: quote.imageData)!
    }
    
    @MainActor
    private func presentAlert() {
        let alertVC = UIAlertController(
            title: "Error",
            message: "The quote download failed",
            preferredStyle: .alert
        )
        
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}

