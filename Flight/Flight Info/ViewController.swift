import UIKit

class ViewController: UIViewController {

  // MARK: - Outlets

  @IBOutlet var background: UIImageView!
  
  @IBOutlet var summaryIcon: UIImageView!
  @IBOutlet var summary: UILabel!
  
  @IBOutlet var flightNumberLabel: UILabel!
  @IBOutlet var gateNumberLabel: UILabel!
  @IBOutlet var originLabel: UILabel!
  @IBOutlet var destinationLabel: UILabel!
  @IBOutlet var plane: UIImageView!
  
  @IBOutlet var statusLabel: UILabel!
  @IBOutlet var statusBanner: UIImageView!

  // MARK: - Properties

  private let snowView = SnowView(frame: .init(x: -150, y:-100, width: 300, height: 50))

  // MARK: - View Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()

    setupSnowView()

    // Start rotating the flights
    changeFlight(to: .londonToParis, animated: false)
  }

  //MARK:- Helper Methods

  private func setupSnowView() {
    // Add the snow effect layer
    let snowClipView = UIView( frame: view.frame.offsetBy(dx: 0, dy: 50))
    snowClipView.clipsToBounds = true
    snowClipView.addSubview(snowView)
    view.addSubview(snowClipView)
  }

  private func changeFlight(to flight: Flight, animated: Bool = false) {
    // Populate the UI with the next flight's data
    flightNumberLabel.text = flight.number
    gateNumberLabel.text = flight.gateNumber

    if animated {
      // Animate Image
      guard let image = UIImage(named: flight.weatherImageName) else { return }
      fade(to: image, showEffects: flight.showWeatherEffects)

      // Animate Origin and Destination labels
      move(label: originLabel, text: flight.origin, offset: .init(x: -80, y: 0))
      move(label: destinationLabel, text: flight.destination, offset: .init(x: 80, y: 0))

      // Animate Status label
      cubeTransition(label: statusLabel, text: flight.status)

      // Animate Plane
      depart()

      // Animate Summary Label
      changeSummary(to: flight.summary)
    } else {
      summary.text = flight.summary
      statusLabel.text = flight.status
      originLabel.text = flight.origin
      destinationLabel.text = flight.destination
      background.image = UIImage(named: flight.weatherImageName)
    }

    // Schedule next flight
    delay(seconds: 3) {
      self.changeFlight(to: flight.isTakingOff ? .parisToRome : .londonToParis,
                        animated: true)
    }
  }

  private func duplicate(_ label: UILabel) -> UILabel {
    let newLabel = UILabel(frame: label.frame)
    newLabel.font = label.font
    newLabel.textAlignment = label.textAlignment
    newLabel.textColor = label.textColor
    newLabel.backgroundColor = label.backgroundColor

    return newLabel
  }

  private func delay(seconds: TimeInterval, execute: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: execute)
  }

  // MARK:- Animations

  private func fade(to image: UIImage, showEffects: Bool) {
    // Create and set up a temporary view
    let tempView = UIImageView(frame: background.frame)
    tempView.image = image
    tempView.alpha = 0
    tempView.center.y += 20
    tempView.bounds.size.width = background.bounds.size.width * 1.3

    background.superview?.insertSubview(tempView, aboveSubview: background)

    // Animate temporary view transition
    UIView.animate(withDuration: 0.5,
                   animations: {
                    // Fade temporary view in
                    tempView.alpha = 1
                    tempView.center.y -= 20
                    tempView.bounds.size = self.background.bounds.size
    }, completion: { _ in
      // Update backgropund view and remove temporary view
      self.background.image = image
      tempView.removeFromSuperview()
    })

    // New animations in order to animate the snow at a different duration
    UIView.animate(withDuration: 1.3,
                   delay: 0,
                   options: .curveEaseOut,
                   animations: {
                    self.snowView.alpha = showEffects ? 1 : 0
    })
  }
  
  private func move(label: UILabel, text: String, offset: CGPoint) {
    // Create and set up a temporary label
    let tempLabel = duplicate(label)
    tempLabel.text = text
    tempLabel.transform = .init(translationX: offset.x, y: offset.y)
    tempLabel.alpha = 0

    // Add tempLabel to the view
    view.addSubview(tempLabel)

    // Fade out and translate the real label
    UIView.animate(withDuration: 0.5,
                   delay: 0,
                   options: .curveEaseOut,
                   animations: {
                    label.transform = .init(translationX: offset.x, y: offset.y)
                    label.alpha = 0
    })

    // Fade in and translate the temporary label
    UIView.animate(withDuration: 0.25,
                   delay: 0.2,
                   options: .curveEaseIn,
                   animations: {
                    tempLabel.transform = .identity
                    tempLabel.alpha = 1
    }, completion: { _ in
      // Update real label and remove the temporary label
      label.text = text
      label.alpha = 1
      label.transform = .identity

      tempLabel.removeFromSuperview()
    })
  }
  
  private func cubeTransition(label: UILabel, text: String) {
    // Create and set up temporary label
    let tempLabel = duplicate(label)
    tempLabel.text = text

    let tempLabelOffset = label.bounds.size.height / 2
    let scale = CGAffineTransform(scaleX: 1, y: 0.1)
    let translate = CGAffineTransform(translationX: 0, y: tempLabelOffset)

    tempLabel.transform = scale.concatenating(translate)

    label.superview?.addSubview(tempLabel)

    UIView.animate(withDuration: 0.5,
                   delay: 0,
                   options: .curveEaseOut,
                   animations: {
                    // Scale temporary label up and translate down
                    tempLabel.transform = .identity

                    // Scale real label up and translate down
                    label.transform = scale.concatenating( translate.inverted() )
    }, completion: { _ in
      // Update real label's text and reset it's trnasform
      label.text = tempLabel.text
      label.transform = .identity

      // Remove temporary label
      tempLabel.removeFromSuperview()
    })
  }
  
  private func depart() {
    // Store the plane's center value
    let originalCenter = plane.center

    //Create new key frame animation
    UIView.animateKeyframes(withDuration: 1.5,
                            delay: 0,
                            animations: { [weak self] in
                              guard let strongSelf = self else { return }

                              // Move plane right and up
                              UIView.addKeyframe(withRelativeStartTime: 0,
                                                 relativeDuration: 0.25) {
                                                  strongSelf.plane.center.x += 80
                                                  strongSelf.plane.center.y -= 10
                              }

                              // Rotate plane
                              UIView.addKeyframe(withRelativeStartTime: 0.1,
                                                 relativeDuration: 0.4) {
                                                  strongSelf.plane.transform = .init(rotationAngle: -.pi / 8)
                              }
                              
                              // Move plane right and up off screen, while fading out
                              UIView.addKeyframe(withRelativeStartTime: 0.25,
                                                 relativeDuration: 0.25) {
                                                  strongSelf.plane.center.x += 100
                                                  strongSelf.plane.center.y -= 50
                                                  strongSelf.plane.alpha = 0
                              }
                              
                              // Move plane just off left side, reset transform nd hegith
                              UIView.addKeyframe(withRelativeStartTime: 0.51,
                                                 relativeDuration: 0.01) {
                                                  strongSelf.plane.transform = .identity
                                                  strongSelf.plane.center = .init(x: 0, y: originalCenter.y)
                              }

                              // Move plane back to original position and fade in
                              UIView.addKeyframe(withRelativeStartTime: 0.55,
                                                 relativeDuration: 0.45) {
                                                  strongSelf.plane.alpha = 1
                                                  strongSelf.plane.center = originalCenter
                              }

    })
  }
  
  private func changeSummary(to summaryText: String) {
    UIView.animateKeyframes(withDuration: 1,
                            delay: 0,
                            animations: { [weak self] in
                              guard let strongSelf = self else { return }

                              // Animate summary label up
                              UIView.addKeyframe(withRelativeStartTime: 0,
                                                 relativeDuration: 0.45) {
                                                  strongSelf.summary.center.y -= 100
                              }

                              // Animate summary label down
                              UIView.addKeyframe(withRelativeStartTime: 0.5,
                                                 relativeDuration: 0.45) {
                                                  strongSelf.summary.center.y += 100
                              }
    })

    // Set the summary label text
    delay(seconds: 0.5) { [weak self] in
      guard let strongSelf = self else { return }
      strongSelf.summary.text = summaryText
    }
  }
}
