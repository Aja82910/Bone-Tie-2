//
//  AddReminders.swift
//  Bone Tie 3
//
//  Created by Alex Arovas on 4/30/16.
//  Copyright © 2016 Alex Arovas. All rights reserved.
//

import UIKit
import AVFoundation
import Interpolate

var type = "Food"
var Medicine = ""

class AddReminders: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate/*, AVAudioPlayerDelegate*/ {
    var DogName = ""
    var alarm: Alarm!
    var soundEffect: AVAudioPlayer!
    let path = NSBundle.mainBundle().pathForResource("Dog Bark.mp3", ofType: nil)
    let button = UIButton()
    var datePicker = UIDatePicker()
    var ReminderType = UIPickerView()
    let pickerData = ["Food", "Medicine"]
    let image = UIImage(named: "Food")
    let images = UIImage(named: "Medicine")
    var imageView = UIImageView()
    var imageViews = UIImageView()
    var medName = UITextField()
    var done = UILabel()
    var colorView = UIView()
    var foodColor: Interpolate?
    override func viewDidLoad() {
        super.viewDidLoad()
        foodColor  = Interpolate(from: UIColor.orangeColor(),
                          to: UIColor.blueColor(),
                          apply: { (color) in
                     self.button.titleLabel?.textColor = color
            })
        self.alarm = Alarm(hour: 23, minute: 39, {
            debugPrint("Alarm Triggered!")
        })
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.snoozeButton), name: "ACTION_ONE_IDENTIFIER", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.doneButton), name: "ACTION_TWO_IDENTIFIER", object: nil)
        done.frame = CGRect(x: 0, y: 64, width: self.view.frame.width, height: 19)
        done.text = "Reminder Set"
        done.font = UIFont(name: "Noteworthy-Light", size: 15)
        done.textAlignment = NSTextAlignment.Center
        done.textColor = UIColor.orangeColor()
        done.backgroundColor = UIColor.blueColor()
        done.alpha = 0.0
        self.view.addSubview(done)
        imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        imageView.alpha = 1.0
        imageViews = UIImageView(image: images)
        imageViews.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        imageViews.alpha = 0.0
        self.view.addSubview(imageView)
        self.view.addSubview(imageViews)
        medName.frame = CGRectMake(57, 300, 300, 30)
        medName.center = CGPoint(x: self.view.center.x, y: medName.center.y)
        medName.alpha = 0.0
        medName.delegate = self
        medName.borderStyle = UITextBorderStyle.RoundedRect
        medName.returnKeyType = UIReturnKeyType.Done
        medName.backgroundColor = UIColor.clearColor()
        medName.placeholder = "Medicine Name"
        colorView.frame = medName.frame
        colorView.center = medName.center
        colorView.layer.masksToBounds = true
        colorView.layer.cornerRadius = 5
        colorView.backgroundColor = UIColor.orangeColor()
        colorView.alpha = 0.0
        medName.allowsEditingTextAttributes = true
        ReminderType.frame = CGRectMake(0, 100, self.view.frame.width, 125)
        ReminderType.delegate = self
        ReminderType.dataSource = self
        self.view.addSubview(ReminderType)
        view.bringSubviewToFront(ReminderType)
        
        datePicker.setValue(UIColor.blueColor(), forKeyPath: "textColor")
        datePicker.datePickerMode = UIDatePickerMode.DateAndTime
        self.datePicker.frame = CGRectMake(0, 275, self.view.frame.width, 150)
        //datePicker.sizeToFit()
        datePicker.addTarget(self, action: #selector(self.remindMe) , forControlEvents: UIControlEvents.ValueChanged)
        self.view.addSubview(datePicker)
        
        button.frame = CGRectMake(0, 510, self.view.frame.width, 50)
        button.center = CGPoint(x: self.view.center.x, y: self.button.center.y)
        button.setTitle("Add Reminder", forState: .Normal)
        button.setTitle("Add Reminder", forState: .Selected)
        button.setTitleColor(UIColor.blueColor(), forState: .Normal)
        button.userInteractionEnabled = true
        //button.sizeToFit()
        button.addTarget(self, action: #selector(self.addReminder(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(button)
        self.view.addSubview(datePicker)
        self.view.addSubview(ReminderType)
        self.view.addSubview(done)
        self.view.addSubview(colorView)
        self.view.addSubview(medName)
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if row == 0 {
            return NSAttributedString(string: pickerData[row], attributes: [NSForegroundColorAttributeName:UIColor.blueColor()])
        }
        else {
            return NSAttributedString(string: pickerData[row], attributes: [NSForegroundColorAttributeName:UIColor.orangeColor()])
        }
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerData[row] == "Food" {
            let duration = 2.0
            let delay = 0.0
            let options = UIViewKeyframeAnimationOptions.CalculationModeLinear
            //self.datePicker.setValue(UIColor.blueColor(), forKeyPath: "textColor")
            self.datePicker.datePickerMode = .CountDownTimer
            self.datePicker.datePickerMode = .DateAndTime
            foodColor?.animate(duration: 2.0)
            UIView.animateKeyframesWithDuration(duration, delay: delay, options: options,  animations: { () -> Void in
                // each keyframe needs to be added here
                // within each keyframe the relativeStartTime and relativeDuration need to be values between 0.0 and 1.0
                UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 1, animations: { () -> Void in
                    self.imageView.alpha = 1.0
                    self.imageViews.alpha = 0.0
                    self.datePicker.frame = CGRectMake(0, 275, self.view.frame.width, 150)
                    //self.button.setTitleColor(UIColor.blueColor(), forState: .Normal)
                    //self.button.setTitleColor(UIColor.blueColor(), forState: .Selected)
                    self.button.tintColor = UIColor.orangeColor()
                    self.medName.alpha = 0.0
                    self.colorView.alpha = 0.0
                    
                    
                })
                }, completion: { finshed in
                    
            })
            type = "Food"
            view.bringSubviewToFront(ReminderType)
            view.bringSubviewToFront(datePicker)
            view.bringSubviewToFront(button)
        }
        else {
            let duration = 2.0
            let delay = 0.0
            let options = UIViewKeyframeAnimationOptions.CalculationModeLinear
            self.datePicker.setValue(UIColor.orangeColor(), forKeyPath: "textColor")
            self.datePicker.datePickerMode = .CountDownTimer
            self.datePicker.datePickerMode = .DateAndTime
            UIView.animateKeyframesWithDuration(duration, delay: delay, options: options,  animations: { () -> Void in
                // each keyframe needs to be added here
                // within each keyframe the relativeStartTime and relativeDuration need to be values between 0.0 and 1.0
                UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 2, animations: { () -> Void in
                    self.imageView.alpha = 0.0
                    self.imageViews.alpha = 1.0
                    self.medName.alpha = 1.0
                    self.colorView.alpha = 0.3
                    self.datePicker.frame = CGRectMake(0, 350, self.view.frame.width, 150)
                    self.button.setTitleColor(UIColor.orangeColor(), forState: .Normal)
                    self.button.setTitleColor(UIColor.orangeColor(), forState: .Selected)
                    self.datePicker.tintColor = UIColor.blueColor()
                    self.view.bringSubviewToFront(self.button)
                    self.view.bringSubviewToFront(self.datePicker)
                    self.view.addSubview(self.datePicker)
                    self.view.addSubview(self.ReminderType)
                    self.view.addSubview(self.medName)
                })
                }, completion: { finshed in
            })

            view.bringSubviewToFront(ReminderType)
            view.bringSubviewToFront(datePicker)
            view.bringSubviewToFront(button)
            type = "Medicine"
        }
    }
    func remindMe () {
        let (hour, minute) = components(self.datePicker.date)
        self.alarm.hour = hour
        self.alarm.minute = minute
    }
    func components (date: NSDate) -> (Int, Int) {
        let flags = NSCalendarUnit.Hour.union(NSCalendarUnit.Minute)
        let comps = NSCalendar.currentCalendar().components(flags, fromDate: date)
        return (comps.hour, comps.minute)
    }
    func snoozeButton() {
        
    }
    func doneButton() {
        
    }
    func notification(message: String) {
        let ac = UIAlertController(title: "What's that Breed?", message: message, preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(ac, animated: true, completion: nil)
    }
    func addReminder(notification: NSNotification) {
        self.alarm.turnOn()
        let now = NSDate()
        let alarmTime = datePicker.date
        let calendar = NSCalendar.currentCalendar()
        let dayCalendarUnit: NSCalendarUnit = [.Day, .Hour, .Minute, .Second]
        let alarmTimeDifference = calendar.components(
            dayCalendarUnit,
            fromDate: now,
            toDate:  alarmTime,
            options:  [])
        let secondsFromNow: NSTimeInterval = (Double(alarmTimeDifference.second)+Double(alarmTimeDifference.minute*60)+Double(alarmTimeDifference.hour*3600)+Double(alarmTimeDifference.day*86400))
        if self.alarm.isOn  {
            let userInfo = ["url": "www.mobiwise.co"]
            if ReminderType.selectedRowInComponent(0) == 0 {
                let message = "Don't forget to feed \(DogName)"
                LocalNotificationHelper.sharedInstance().scheduleNotificationWithKey("mobiwise", title: "Food", message: message, seconds: secondsFromNow, userInfo: userInfo)
                NSTimer.scheduledTimerWithTimeInterval(secondsFromNow, target: self, selector: Selector(self.notification(message)), userInfo: nil, repeats: false)
                let url = NSURL(fileURLWithPath: path!)
                do {
                    let sound = try AVAudioPlayer(contentsOfURL: url)
                    soundEffect = sound
                    sound.play()
                } catch {
                    //no file found
                }
                let duration = 10.0
                let delay = 0.0
                let options = UIViewKeyframeAnimationOptions.CalculationModeLinear
                done.backgroundColor = UIColor.blueColor()
                done.textColor = UIColor.orangeColor()
                UIView.animateKeyframesWithDuration(duration, delay: delay, options: options,  animations: { () -> Void in
                    // each keyframe needs to be added here
                    
                    UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0.2, animations: { () -> Void in
                        self.done.alpha = 1.0
                    })
                    UIView.addKeyframeWithRelativeStartTime(0.8, relativeDuration: 0.2, animations: { () -> Void in
                        self.done.alpha = 0.0
                    })
                    }, completion: { finshed in
                        
                })
            }
            if ReminderType.selectedRowInComponent(0) == 1 {
                if medName.text! == "" {
                    Medicine = "medicine"
                }
                else {
                    Medicine = medName.text!
                }
                let message = "Don't forget to give \(Medicine) to \(DogName)"
                LocalNotificationHelper.sharedInstance().scheduleNotificationWithKey("mobiwise", title: "Medicine", message: message, seconds: secondsFromNow, userInfo: userInfo)
                NSTimer.scheduledTimerWithTimeInterval(secondsFromNow, target: self, selector: Selector(self.notification(message)), userInfo: nil, repeats: false)
                let url = NSURL(fileURLWithPath: path!)
                do {
                    let sound = try AVAudioPlayer(contentsOfURL: url)
                    soundEffect = sound
                    sound.play()
                } catch {
                    //no file found
                }
                /*if soundEffect != nil {
                    soundEffect.stop()
                    soundEffect = nil
                }*/
                let duration = 10.0
                let delay = 0.0
                let options = UIViewKeyframeAnimationOptions.CalculationModeLinear
                done.backgroundColor = UIColor.orangeColor()
                done.textColor = UIColor.blueColor()
                UIView.animateKeyframesWithDuration(duration, delay: delay, options: options,  animations: { () -> Void in
                    // each keyframe needs to be added here
                    
                    UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0.2, animations: { () -> Void in
                        self.done.alpha = 1.0
                    })
                    UIView.addKeyframeWithRelativeStartTime(0.8, relativeDuration: 0.2, animations: { () -> Void in
                        self.done.alpha = 0.0
                    })
                    }, completion: { finshed in
                        
                })


            }
        }
        
    }
 /*func notifyUser(title: String, message: String) -> Void {
    let alert = UIAlertController(title: title,
    message: message,
    preferredStyle: UIAlertControllerStyle.Alert)
 
    let cancelAction = UIAlertAction(title: "OK",
    style: .Cancel, handler: nil)
 
    alert.addAction(cancelAction)
    self.presentViewController(alert, animated: true,
    completion: nil)
}
 func notifyUserSound(title: String, message: String) -> Void {
    let alert = UIAlertController(title: title,
    message: message,
    preferredStyle: UIAlertControllerStyle.Alert)
    let coinSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Dog Bark", ofType: "mp3")!)
    do {
        audioPlayer = try AVAudioPlayer(contentsOfURL:coinSound)
        audioPlayer.delegate = self
        audioPlayer.volume = 1.0
        audioPlayer.numberOfLoops = -1
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    } catch {
    notifyUser("Could not Play Audio", message: "There was a problem playing the audio")
    }
    let cancelAction = UIAlertAction(title: "OK", style: .Cancel) { (UIAlertAction) in
    self.audioPlayer.stop()
    }
 
    alert.addAction(cancelAction)
    self.presentViewController(alert, animated: true,
    completion: nil)
 }*/
}
