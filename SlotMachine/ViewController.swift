//
//  ViewController.swift
//  SlotMachine
//
//  Created by Admin on 19.03.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //views
    var firstContainer: UIView!
    var secondContainer: UIView!
    var thirdContainer: UIView!
    var fourthContainer: UIView!
    
    //labels
    var titleLabel: UILabel!
    var creditsLabel: UILabel!
    var creditsTitleLabel: UILabel!
    var betLabel: UILabel!
    var betTitleLabel: UILabel!
    var winnerPaidLabel: UILabel!
    var winnerPaidTitleLabel: UILabel!
    
    //buttons
    var betButton: UIButton!
    var betAllButton: UIButton!
    var resetButton: UIButton!
    var spinButton: UIButton!
    
    //stats
    var credits = 0
    var winnings = 0
    var currentBet = 0
    
    //constants
    let kMarginForView: CGFloat = 10.0
    let kMarginForSlot: CGFloat = 0.3
    let kThird: CGFloat = 1.0/3
    let kFourth: CGFloat = 1.0/4
    let kFifth: CGFloat = 1.0/5
    let kSixth: CGFloat = 1.0/6
    let kSeventh: CGFloat = 1.0/8
    let kNumberOfContainers = 3
    let kNumberOfSlots = 3
    
    //Slots
    var slots:[[Slot]] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupContainerViews()
        let containers = [firstContainer /*secondContainer*/, thirdContainer, fourthContainer]
        hardReset()
       
        for container in containers{
            setupContainer(container)
        }
        updateMainView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func betButtonPressed (button: UIButton) {
        

        if credits <= 0 {
            showAlertMessage(header: "Game over", body: "Out of credits, press reset")
        } else {
            if currentBet < 5 {
                currentBet += 1
                credits -= 1
                updateMainView()
            } else {
                showAlertMessage(header: nil, body: "That's already a maximum bet")
            }
        }
        
    }
    
    func resetButtonPressed(button: UIButton){
        hardReset()
        updateMainView()
    }
    
    func betAllButtonPressed(button: UIButton) {
        if (self.credits <= 0) && (self.currentBet <= 0) {
            showAlertMessage(header: "Game over", body: "Out of credits, press reset")
        } else {
            if credits < 5 {
                showAlertMessage(header: "Not enough credits", body: "Can't make maximum bet, press Bet")
            } else {
                self.currentBet += 5
                self.credits -= 5
                updateMainView()
            }
        }
    }
    
    func spinButtonPressed(button: UIButton) {
        
        removeSlotImageViews()
        slots = Factory.createSlots()
        setupContainer(secondContainer)
        var winningMultiplier = ArrayOfRows.calculateWinnigs(slots)
            winnings += winningMultiplier * currentBet
            credits += winnings
            currentBet = 0
        
        
        //winnings += wonPoints
        updateMainView()
        winnings = 0
        
    }
    
    func setupContainerViews(){
        
        /*self.backgroundView = UIView(frame: CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.width, self.view.bounds.height))
        self.backgroundView.backgroundColor = UIColor.blackColor()
        self.view.addSubview(backgroundView)*/
        self.view.backgroundColor = UIColor(white: 0.9, alpha: 0.2)
        
        self.firstContainer = UIView(frame: CGRectMake(self.view.bounds.origin.x + kMarginForView, self.view.bounds.origin.y, self.view.bounds.width - (kMarginForView*2), self.view.bounds.height * kSixth))
        self.firstContainer.backgroundColor = UIColor.redColor()
        self.view.addSubview(firstContainer)
        
        self.secondContainer = UIView(frame: CGRectMake(self.view.bounds.origin.x + kMarginForView, self.firstContainer.frame.height, self.view.bounds.width - (kMarginForView*2), self.view.bounds.height * (kSixth*3)))
        self.secondContainer.backgroundColor = UIColor.blackColor()
        self.view.addSubview(secondContainer)
        
        self.thirdContainer = UIView(frame: CGRectMake(self.view.bounds.origin.x + kMarginForView, (self.secondContainer.frame.height + self.firstContainer.frame.height), self.view.bounds.width - (kMarginForView*2), self.view.bounds.height * kSixth))
        self.thirdContainer.backgroundColor = UIColor.lightGrayColor()
        self.view.addSubview(thirdContainer)
    
        self.fourthContainer = UIView(frame: CGRectMake(self.view.bounds.origin.x + kMarginForView, (self.secondContainer.frame.height + self.firstContainer.frame.height + self.thirdContainer.frame.height), self.view.bounds.width - (kMarginForView*2), self.view.bounds.height * kSixth))
        self.fourthContainer.backgroundColor = UIColor(white: 0.3, alpha: 0.6)
        self.view.addSubview(fourthContainer)
    }

    func setupContainer(container: UIView){
        switch container{
        case firstContainer:
            self.titleLabel = UILabel()
            self.titleLabel.text = "Slot Machine"
            self.titleLabel.font = UIFont(name: "MarkerFelt-Wide", size: 40)
            self.titleLabel.textColor = UIColor.yellowColor()
            //self.titleLabel.textAlignment = NSTextAlignment.Center
            self.titleLabel.sizeToFit()
            self.titleLabel.center = firstContainer.center
            container.addSubview(self.titleLabel)
        case secondContainer:
            for var containerNumber = 0; containerNumber < kNumberOfContainers; ++containerNumber {
                for var slotNumber = 0; slotNumber < kNumberOfSlots; ++slotNumber {
                    var slot: Slot
                    var slotImageView = UIImageView()
                    
                    if slots.count != 0 {
                        let slotContainer = slots[containerNumber]
                        slot = slotContainer[slotNumber]
                        slotImageView.image = slot.image
                    }
                    else {
                        slotImageView.image = UIImage(named: "Ace")
                    }
                    
                    slotImageView.backgroundColor = UIColor.yellowColor()
                    slotImageView.frame = CGRectMake(container.bounds.origin.x + (container.bounds.size.width * CGFloat(containerNumber) *  kThird),
                        container.bounds.origin.y + container.bounds.size.height * CGFloat(slotNumber) * kThird,
                        container.bounds.width * kThird - kMarginForSlot,
                        container.bounds.height * kThird - kMarginForSlot)
                    container.addSubview(slotImageView)
                }
            }
        case thirdContainer:
            var labelsArray = [UILabel]()
            self.creditsLabel = UILabel()
            self.creditsLabel.text = "\(String(self.credits))"
            self.creditsLabel.font = UIFont(name: "MarkerFelt-Wide", size: 20)
            self.creditsLabel.textColor = UIColor.redColor()
            self.creditsLabel.sizeToFit()
            self.creditsLabel.backgroundColor = UIColor.darkGrayColor()
            //self.creditsLabel.frame = CGRectMake(container.bounds.origin.x * kThird, container.bounds.origin.y * kThird, container.bounds.width / 3.0, container.bounds.height / 3.0)
            self.creditsLabel.center = CGPointMake(container.frame.width * kSixth, container.frame.height * kFourth)
            labelsArray.append(self.creditsLabel)
            
            self.betLabel = UILabel()
            self.betLabel.text = "\(String(self.currentBet))"
            self.betLabel.font = UIFont(name: "MarkerFelt-Wide", size: 20)
            self.betLabel.textColor = UIColor.redColor()
            self.betLabel.sizeToFit()
            self.betLabel.backgroundColor = UIColor.darkGrayColor()
            self.betLabel.center = CGPointMake(container.frame.width * kSixth * 3, container.frame.height * kFourth)
            labelsArray.append(self.betLabel)
            
            self.winnerPaidLabel = UILabel()
            self.winnerPaidLabel.text = "\(String(self.winnings))"
            self.winnerPaidLabel.font = UIFont(name: "MarkerFelt-Wide", size: 20)
            self.winnerPaidLabel.textColor = UIColor.redColor()
            self.winnerPaidLabel.backgroundColor = UIColor.darkGrayColor()
            self.winnerPaidLabel.sizeToFit()
            self.winnerPaidLabel.center = CGPointMake(container.frame.width * kSixth * 5, container.frame.height * kFourth)
            labelsArray.append(self.winnerPaidLabel)
            
            self.creditsTitleLabel = UILabel()
            self.creditsTitleLabel.text = "Credits"
            self.creditsTitleLabel.font = UIFont(name: "MarkerFelt-Wide", size: 20)
            self.creditsTitleLabel.textColor = UIColor.darkGrayColor()
            self.creditsTitleLabel.sizeToFit()
            self.creditsTitleLabel.backgroundColor = UIColor.lightGrayColor()
            self.creditsTitleLabel.center = CGPointMake(container.frame.width * kSixth, container.frame.height * kFifth * 3)
            labelsArray.append(self.creditsTitleLabel)
            
            self.betTitleLabel = UILabel()
            self.betTitleLabel.text = "Bet"
            self.betTitleLabel.font = UIFont(name: "MarkerFelt-Wide", size: 20)
            self.betTitleLabel.textColor = UIColor.darkGrayColor()
            self.betTitleLabel.sizeToFit()
            self.betTitleLabel.backgroundColor = UIColor.lightGrayColor()
            self.betTitleLabel.center = CGPointMake(container.frame.width * kSixth * 3, container.frame.height * kFifth * 3)
            labelsArray.append(self.betTitleLabel)
            
            self.winnerPaidTitleLabel = UILabel()
            self.winnerPaidTitleLabel.text = "Win"
            self.winnerPaidTitleLabel.font = UIFont(name: "MarkerFelt-Wide", size: 20)
            self.winnerPaidTitleLabel.textColor = UIColor.darkGrayColor()
            self.winnerPaidTitleLabel.sizeToFit()
            self.winnerPaidTitleLabel.backgroundColor = UIColor.lightGrayColor()
            self.winnerPaidTitleLabel.center = CGPointMake(container.frame.width * kSixth * 5, container.frame.height * kFifth * 3)
            labelsArray.append(self.winnerPaidTitleLabel)
            for label in labelsArray {
                container.addSubview(label)
            }
        
        case fourthContainer:
            var buttonsArray = [UIButton]()
            self.resetButton = UIButton()
            self.resetButton.setTitle("Reset", forState: UIControlState.Normal)
            self.resetButton.titleLabel?.font = UIFont(name:"MarkerFelt-Wide", size: 20)
            self.resetButton.titleLabel!.textColor = UIColor.redColor()
            self.resetButton.backgroundColor = UIColor(white: 0.3, alpha: 0.0)
            self.resetButton.sizeToFit()
            self.resetButton.center = CGPointMake(container.frame.width * kSeventh, container.frame.height * 0.5)
            //self.resetButton.frame = CGRectMake(container.frame.width * kNinth * 3, container.frame.height * kFourth * 2, container.frame.width * kThird - kMarginForSlot, container.frame.height * kFourth * 2)
            self.resetButton.addTarget(self, action: "resetButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
            buttonsArray.append(self.resetButton)
            
            self.betButton = UIButton()
            self.betButton.setTitle("Bet", forState: UIControlState.Normal)
            self.betButton.titleLabel!.font = UIFont(name: "MarkerFelt-Wide", size: 20)
            self.betButton.titleLabel?.textColor = UIColor.yellowColor()
            self.betButton.backgroundColor = UIColor(white: 0.3, alpha: 0.0)
            self.betButton.sizeToFit()
            self.betButton.center = CGPointMake(container.frame.width * kSeventh * 3, container.frame.height * 0.5)
            self.betButton.addTarget(self, action:"betButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
            //self.betAllbutton.frame = CGRectMake(container.frame.width * kSixth * 3, container.frame.height * kFourth * 2, container.frame.width * kThird - kMarginForSlot, container.frame.height * kFourth * 2)
            buttonsArray.append(self.betButton)
            
            self.betAllButton = UIButton()
            self.betAllButton.setTitle("All in", forState: UIControlState.Normal)
            self.betAllButton.titleLabel!.font = UIFont(name: "MarkerFelt-Wide", size: 20)
            self.betAllButton.titleLabel?.textColor = UIColor.yellowColor()
            self.betAllButton.backgroundColor = UIColor(white: 0.3, alpha: 0.0)
            self.betAllButton.sizeToFit()
            self.betAllButton.center = CGPointMake(container.frame.width * kSeventh * 5, container.frame.height * 0.5)
            self.betAllButton.addTarget(self, action: "betAllButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
            //self.betAllbutton.frame = CGRectMake(container.frame.width * kSixth * 3, container.frame.height * kFourth * 2, container.frame.width * kThird - kMarginForSlot, container.frame.height * kFourth * 2)
            buttonsArray.append(self.betAllButton)
            
            self.spinButton = UIButton()
            self.spinButton.setTitle("Spin", forState: UIControlState.Normal)
            self.spinButton.titleLabel!.font = UIFont(name: "MarkerFelt-Wide", size: 20)
            self.spinButton.titleLabel?.textColor = UIColor.yellowColor()
            self.spinButton.backgroundColor = UIColor(white: 0.3, alpha: 0.0)
            self.spinButton.sizeToFit()
            self.spinButton.center = CGPointMake(container.frame.width * kSeventh * 7, container.frame.height * 0.5)
            self.spinButton.addTarget(self, action: "spinButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
            //self.betAllbutton.frame = CGRectMake(container.frame.width * kSixth * 3, container.frame.height * kFourth * 2, container.frame.width * kThird - kMarginForSlot, container.frame.height * kFourth * 2)
            buttonsArray.append(self.spinButton)
            
            for button in buttonsArray {
                container.addSubview(button)
            }
        default:
            println("default")
        }
        
    }
    
    func removeSlotImageViews(){
        
        
        if self.secondContainer != nil {
            let container:UIView = self.secondContainer!
            let subViews:Array? = container.subviews
            for view in subViews!{
                view.removeFromSuperview()
            }
        }
    }
    
    func hardReset() {
        removeSlotImageViews()
        slots.removeAll(keepCapacity: true)
        setupContainer(secondContainer)
        credits = 50
        winnings = 0
        currentBet = 0
    }
    
    func updateMainView() {
        self.betLabel.text = "\(String(self.currentBet))"
        self.creditsLabel.text = "\(self.credits)"
        self.winnerPaidLabel.text = "\(self.winnings)"
    }
    
    func showAlertMessage(header: String? = "Warning", body: String) {
        var alert = UIAlertController(title: header, message: body, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
}

