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
    originLabel.text = flight.origin
    destinationLabel.text = flight.destination
    flightNumberLabel.text = flight.number
    gateNumberLabel.text = flight.gateNumber
    statusLabel.text = flight.status
    summary.text = flight.summary

    if animated {
      guard let image = UIImage(named: flight.weatherImageName) else { return }
      fade(to: image, showEffects: flight.showWeatherEffects)
    } else {
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

    // Animate Temporary view transition
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
    //TODO: Animate a label's translation property
  }
  
  private func cubeTransition(label: UILabel, text: String) {
    //TODO: Create a faux rotating cube animation
  }
  
  private func depart() {
    //TODO: Animate the plane taking off and landing
  }
  
  private func changeSummary(to summaryText: String) {
    //TODO: Animate the summary text
  }
}
