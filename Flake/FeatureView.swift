//
//  FeatureView.swift
//  
//
//  Created by Kendall Lewis on 7/2/18.
//

import UIKit
import UICircularProgressRing

class FeatureView: UIView {
    //-------------feature view -------------
    @IBOutlet weak var flakeLocation: UILabel!
    @IBOutlet weak var flakeTitle: UILabel!
    @IBOutlet weak var flakeDate: UILabel!
    @IBOutlet weak var flakeBalance: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    //-------------feature details view -------------
    @IBOutlet var flakeDetailsTitle: UILabel!
    @IBOutlet var flakeDetailsLocation: UILabel!
    @IBOutlet var flakeDetails: UITextView!
    @IBOutlet var flakeDetailsDate: UILabel!
    @IBOutlet weak var addPaymentButton: UIButton!
    @IBOutlet weak var progressBar: UICircularProgressRing!
    @IBOutlet weak var personalProgressBar: UICircularProgressRing!
    @IBOutlet weak var returnHome: UIButton!
    @IBOutlet weak var featureContainer: UIView!
}
