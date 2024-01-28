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
            
            let rewardIdentifier: Int = tag * 100
            
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
                    print("button tag: \(rewardButton.tag)")
                    print("reward img val: \(currentRewards)")
                } else {
                    print("Button with tag \(rewardIdentifier) not found.")
                }
            } else {
                print("String does not contain a valid integer")
            }
        }
        print(rewardMap)
    }
    
    // Variables to store information about opened suitcases and values
    var suitcaseInfo1: BreafCaseInfo?
    var valueInfo: ValueInfo?
    
    
    @IBAction func Case_buttons(_ sender: Any) {
        let Case_buttons = sender as! UIButton
        let tag = Case_buttons.tag

        if let soutcasInfo = soutcaseMap[tag] {
            if !soutcasInfo.isMatched && !soutcasInfo.isFlipped {

                soutcasInfo.isFlipped = true
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
            }
        }
    }


    // Action function for reset button
    @IBAction func Reset_Button(_ sender: Any) {
        setupGame() // Call the setup function to reset the game
    }
}
