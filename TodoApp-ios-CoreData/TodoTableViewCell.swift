//
//  TodoTableViewCell.swift
//  TodoApp-ios-CoreData
//
//  Created by Yujia on 2022/3/16.
//

import UIKit

class TodoTableViewCell: UITableViewCell {

    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var title: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // Configure the view for the selected state
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        //strikeThroughText(self.title.text!)
        if(selected){
            let title = NSAttributedString(string: self.title.text!,
                                           attributes:[.strikethroughColor: UIColor.gray,
                                                       .strikethroughStyle:2,
                                                       .strokeColor:UIColor.gray])
            self.title?.attributedText = title
        }
        UIView.animate(withDuration: 0.1, animations: {
            self.title.transform = self.title.transform.scaledBy(x: 1.2, y: 1.2)
                    }, completion: { (success) in
                        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                            self.title.transform = CGAffineTransform.identity
                        }, completion: nil)
                    })
    }

}

