//  MIT License

//  Copyright (c) 2017 Haik Aslanyan

//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import UIKit


// uicolor init simplified
extension UIColor{
    class func rbg(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        let color = UIColor.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
        return color
    }
}

extension MutableCollection where Index == Int {
    mutating func myShuffle() {
        if count < 2 { return }
        for i in startIndex ..< endIndex - 1 {
            let j = Int(arc4random_uniform(UInt32(endIndex - i))) + i
            if i != j {
                self.swapAt(i, j)
            }
        }
    }
}

extension Int {
    func secondsToFormattedString() -> String {
        let hours = self / 3600
        let minutes = (self % 3600) / 60
        let second = (self % 3600) % 60
        let hoursString: String = {
            let hs = String(hours)
            return hs
        }()
        
        let minutesString: String = {
            var ms = ""
            if  (minutes <= 9 && minutes >= 0) {
                ms = "0\(minutes)"
            } else{
                ms = String(minutes)
            }
            return ms
        }()
        
        let secondsString: String = {
            var ss = ""
            if  (second <= 9 && second >= 0) {
                ss = "0\(second)"
            } else{
                ss = String(second)
            }
            return ss
        }()
        
        var label = ""
        if hours == 0 {
            label =  minutesString + ":" + secondsString
        } else{
            label = hoursString + ":" + minutesString + ":" + secondsString
        }
        return label
    }
}

enum stateOfVC {
    case minimized
    case fullScreen
    case hidden
}
enum Direction {
    case up
    case left
    case none
}

protocol Convertable: Codable {

}
extension Convertable {

    /// 直接将Struct或Class转成Dictionary
    func convertToDict() -> Dictionary<String, Any>? {

        var dict: Dictionary<String, Any>? = nil

        do {
            print("init student")
            let encoder = JSONEncoder()

            let data = try encoder.encode(self)
            print("struct convert to data")

            dict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? Dictionary<String, Any>

        } catch {
            print(error)
        }

        return dict
    }
}
var vSpinner : UIView?

extension UIViewController {
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(activityIndicatorStyle: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        //DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
       //}
        
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        //DispatchQueue.main.async {
            vSpinner?.removeFromSuperview()
            vSpinner = nil
        //}
    }
}
