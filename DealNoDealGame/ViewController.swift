//
//  ViewController.swift
//  DealNoDealGame
//
//  Created by Ajmal Amir on 1/24/24.
//

import UIKit

class ViewController: UIViewController {
    
    // Arrays to store names of suitcases, positions, rewards, and opened rewards
    let suitcaseArray = [
        "suitcase_open_1",
        "suitcase_open_10",
        "suitcase_open_50",
        "suitcase_open_100",
        "suitcase_open_300",
        "suitcase_open_1000",
        "suitcase_open_10000",
        "suitcase_open_50000",
        "suitcase_open_100000",
        "suitcase_open_500000",
    ]

    let suitcasePositionArray = [
        "suitcase_position_1",
        "suitcase_position_2",
        "suitcase_position_3",
        "suitcase_position_4",
        "suitcase_position_5",
        "suitcase_position_6",
        "suitcase_position_7",
        "suitcase_position_8",
        "suitcase_position_9",
        "suitcase_position_10"
    ]

    let rewardsArray = [
        "reward_1",
        "reward_10",
        "reward_50",
        "reward_100",
        "reward_300",
        "reward_1000",
        "reward_10000",
        "reward_50000",
        "reward_100000",
        "reward_500000"
    ]

    let rewardopenArray = [
        "reward_open_1",
        "reward_open_10",
        "reward_open_50",
        "reward_open_100",
        "reward_open_300",
        "reward_open_1000",
        "reward_open_10000",
        "reward_open_50000",
        "reward_open_100000",
        "reward_open_500000"
    ]

    // Dictionaries to store suitcase and reward information
    var soutcaseMap = [Int: BreafCaseInfo]()
    var rewardMap = [String: String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupGame() // Call the initial setup function
    }
    
    func setupGame() {
        dealOngoing = false
        showDealButtons()
        
        // Create a shuffled array of suitcases
        var suffledSutcase = [String]()
        suffledSutcase.append(contentsOf: suitcaseArray)
        suffledSutcase = suffledSutcase.shuffled()
        
        soutcaseMap.removeAll() // Clear the suitcase map
        rewardMap.removeAll() // Clear the reward map

        // Iterate through 10 suitcases
        for index in 0..<10 {
            let tag: Int = 1 + index
            let valuTag: Int = 1 + index
            let suitcaseName = suffledSutcase[index]
            
            // Use modulo to cycle through the positions
            let positionIndex = index % suitcasePositionArray.count
            let soutcasePosition = suitcasePositionArray[positionIndex]
            

            let moneyValue = suitcaseName.split(separator: "_").last
//            let tmp2 = temp.last;
            
            var reward_open_string = "reward_open_"  // open means reward with cross (the reward is opened)
            reward_open_string += moneyValue!
            
            
            rewardMap[suitcaseName] = reward_open_string // Map suitcase to its corresponding opened reward
            

            let soutcaseInfo = BreafCaseInfo(tage: tag, suitcaseName: suitcaseName)
            soutcaseMap[tag] = soutcaseInfo // Map tag to suitcase information
            
            // Set background images for suitcase and value buttons
            if let button = view.viewWithTag(tag) as? UIButton, let valueButton = view.viewWithTag(valuTag) as? UIButton {
                button.configuration?.background.image = UIImage(named: soutcasePosition)
                valueButton.configuration?.background.image = UIImage(named: soutcasePosition)
                print("value button tag: \(valueButton.tag)")
                print("button tag: \(button.tag)")
            } else {
                print("Button with tag \(tag) not found.")
            }
        }
        
        // iterate through the 10 rewards button
        for currentRewards in rewardsArray {
            if let rewardValue = currentRewards.split(separator: "_").last, let moneyValue = Int(rewardValue) {
                let rewardIdentifier = moneyValue * 100
                if let rewardButton = view.viewWithTag(rewardIdentifier) as? UIButton {
                    rewardButton.configuration?.background.image = UIImage(named: currentRewards)
                    print("reward button tag: \(rewardButton.tag)")
                    print("reward img val: \(currentRewards)")
                } else {
                    print("Button with tag \(rewardIdentifier) not found.")
                }
            } else {
                print("String does not contain a valid integer")
            }
        }
        print(rewardMap)
        caseNumber = 4
        self.caseNumberLabel.text = "Choose \(self.caseNumber) Cases"
    }
    
    // Variables to store information about opened suitcases and values
    var openedSuitCase: BreafCaseInfo?
    var valueInfo: ValueInfo?
    
    // storing the card number
    var caseNumber: Int = 4
    
    var dealOngoing: Bool = false, mainRound: Bool = true, finalRound: Bool = false
    var bankDealValue: Double = 0
    
    @IBOutlet weak var caseNumberLabel: UILabel!
    
    @IBAction func Case_buttons(_ sender: Any) {
        let Case_buttons = sender as! UIButton
        let tag = Case_buttons.tag

        if let soutcasInfo = soutcaseMap[tag] {
            if !soutcasInfo.isMatched && !soutcasInfo.isFlipped {

                soutcasInfo.isFlipped = true
                soutcasInfo.isMatched = true    // if matched, means will exclude in bank deal calculation
                // Update suitcase image
                if let newImage = UIImage(named: soutcasInfo.suitcaseName) {
                    Case_buttons.configuration?.background.image = newImage
                    Case_buttons.setNeedsUpdateConfiguration()
                    print("Updated suitcase image for \(soutcasInfo.suitcaseName)")
                } else {
                    print("Image not found for suitcase: \(soutcasInfo.suitcaseName)")
                }

                if let rewardName = rewardMap[soutcasInfo.suitcaseName] {
                    // Find the index of the corresponding reward in rewardsArray
                    let moneyValue = rewardName.split(separator: "_").last
                    var reward_unopened_string = "reward_"
                    reward_unopened_string += moneyValue!

                    var tagNumber = Int(moneyValue!)
                    tagNumber = tagNumber! * 100

                    if let rewardButton = self.view.viewWithTag(tagNumber!) as? UIButton {
                        // Update reward button image
                        if let newImage = UIImage(named: rewardName) {
                            rewardButton.configuration?.background.image = newImage
                            rewardButton.setNeedsUpdateConfiguration()
                            print("Updated reward button image for \(rewardName)")
                        } else {
                            print("Image not found for reward: \(rewardName)")
                        }
                    }

                    // what does the following do?
                    if let rewardIndex = rewardsArray.firstIndex(where: { rewardName.contains($0) }) {
                        let rewardTag = rewardIndex + 1
                        // Update reward image
                        if let rewardButton = view.viewWithTag(rewardTag) as? UIButton {
                            print("Reward tag: \(rewardTag)")
                            if let newRewardImage = UIImage(named: rewardopenArray[rewardIndex]) {
                                rewardButton.configuration?.background.image = newRewardImage
                                rewardButton.setNeedsUpdateConfiguration()
                                print("Updated reward image for \(rewardopenArray[rewardIndex])")
                            } else {
                                print("Image not found for reward: \(rewardopenArray[rewardIndex])")
                            }
                        }
                    }
                }
                // case number handling
                if 1...4 ~= self.caseNumber {
                    self.caseNumber -= 1
                    if self.caseNumber != 0 {
                        self.caseNumberLabel.text = "Choose \(caseNumber) Cases"
                    }
                    print("current case number: \(caseNumber)")
                    if self.caseNumber == 0 {
                        // show bank deal (60% of the avg. of unopened suitcase)
                        // button -> deal, no deal
                        
                        dealOngoing = true
                        let deal = calculateBankDeal(soutcaseMap)
                        bankDealValue = deal.rounded()
                        print("Bank deal is \(bankDealValue)")
                        self.caseNumberLabel.text = "Bank Deal is $\(bankDealValue)"
                        showDealButtons()
                    }
                }
            }
        }
    }
    
    func calculateBankDeal(_ suitCaseMap: [Int: BreafCaseInfo]) -> Double {
        var sum: Double = 0
        var count: Int = 0
        for suitCase in suitCaseMap {
            if !suitCase.value.isMatched {
                // extract last string, i.e. money value of the suitcase and add to sum
                let moneyValue = suitCase.value.suitcaseName.split(separator: "_").last
                count += 1
                sum += Double(moneyValue!)!
            }
        }
        let dealValue: Double = (sum / Double(count)) * 0.6 // 60% of the average of values of the non opened cases.
        return dealValue
    }
    
    // show the deal buttons
    func showDealButtons() {
        dealButton.isHidden = !dealOngoing
        noDealButton.isHidden = !dealOngoing
    }

    // Action function for reset button
    @IBAction func Reset_Button(_ sender: Any) {
        setupGame() // Call the setup function to reset the game
    }
    
    // Action no deal
    @IBOutlet weak var noDealButton: UIButton!
    @IBAction func noDealAction(_ sender: UIButton) {
        dealOngoing = false
        
    }
    
    // Action deal
    @IBOutlet weak var dealButton: UIButton!
    @IBAction func dealAction(_ sender: UIButton) {
        dealOngoing = false
        showDealButtons()
        // show bankDealValue
        self.caseNumberLabel.text = "You won $\(bankDealValue)!"
    }
}
