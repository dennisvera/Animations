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

  private let snowView = SnowView( frame: .init(x: -150, y:-100, width: 300, height: 50) )

  // MARK: - View Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()

    // Add the snow effect layer
    let snowClipView = UIView( frame: view.frame.offsetBy(dx: 0, dy: 50) )
    snowClipView.clipsToBounds = true
    snowClipView.addSubview(snowView)
    view.addSubview(snowClipView)

    // Start rotating the flights
    changeFlight(to: .londonToParis, animated: false)
  }

  //MARK:- Animations

  private func fade(to image: UIImage, showEffects: Bool) {
    //TODO: Create a crossfade animation for the background

    //TODO: Create a fade animation for snowView
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

  private func changeFlight(to flight: Flight, animated: Bool = false) {
    // populate the UI with the next flight's data
    background.image = UIImage(named: flight.weatherImageName)
    originLabel.text = flight.origin
    destinationLabel.text = flight.destination
    flightNumberLabel.text = flight.number
    gateNumberLabel.text = flight.gateNumber
    statusLabel.text = flight.status
    summary.text = flight.summary

    if animated {
      // TODO: Call your animation
    } else {

    }
    
    // schedule next flight
    delay(seconds: 3) {
      self.changeFlight(
        to: flight.isTakingOff ? .parisToRome : .londonToParis,
        animated: true
      )
    }
  }
  
  // MARK:- Helper Methods

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
}
