/// Copyright (c) 2020 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

final class PopAnimator: NSObject {

  // MARK: - Properties

  var presenting = true

  var originFrame = CGRect()
  private let duration: TimeInterval = 1

}

// MARK: - UIViewController Animated Transitioning

extension PopAnimator: UIViewControllerAnimatedTransitioning {

  func transitionDuration(using _: UIViewControllerContextTransitioning?) -> TimeInterval {
    duration
  }

  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    // Set up transition
    let containerView = transitionContext.containerView

    guard let herbView = transitionContext.view(forKey: presenting ? .to : .from) else { return }

    let (initialFrame, finalFrame) = presenting ? (originFrame, herbView.frame) : (herbView.frame, originFrame)

    let scaleTransform = presenting
      ? CGAffineTransform(scaleX: initialFrame.width / finalFrame.width, y: initialFrame.height / finalFrame.height)
      : .init(scaleX: finalFrame.width / initialFrame.width, y: finalFrame.height / initialFrame.height)

    if presenting {
      herbView.transform = scaleTransform
      herbView.center = .init(x: initialFrame.midX, y: initialFrame.midY)
    }

    herbView.clipsToBounds = true
    herbView.layer.cornerRadius = presenting ? 20 / scaleTransform.a : 0

    if let toView = transitionContext.view(forKey: .to) {
      containerView.addSubview(toView)
    }

    containerView.bringSubviewToFront(herbView)

    guard let herbDetailsContainer = ( transitionContext.viewController( forKey: presenting ? .to : .from) as? HerbDetailsViewController )?.containerView else { return }

    if presenting {
      herbDetailsContainer.alpha = 0
    }

    // Animate
    UIView.animate(withDuration: duration,
                   delay: 0,
                   usingSpringWithDamping: 0.6,
                   initialSpringVelocity: 0,
                   animations: { [weak self ] in
                    guard let strongSelf = self else { return }

                    herbDetailsContainer.alpha = strongSelf.presenting ? 1 : 0

                    herbView.transform = strongSelf.presenting ? .identity : scaleTransform
                    herbView.center = .init(x: finalFrame.midX, y: finalFrame.midY)
                    herbView.layer.cornerRadius = strongSelf.presenting ? 0 : 20 / scaleTransform.a

    }, completion: { [weak self ] _ in
      guard let strongSelf = self else { return }

      if !strongSelf.presenting {
        (transitionContext.viewController(forKey: .to) as! ViewController).selectedImage?.alpha = 1
      }

      // Complete transition
      transitionContext.completeTransition(true)
    })
  }
}
