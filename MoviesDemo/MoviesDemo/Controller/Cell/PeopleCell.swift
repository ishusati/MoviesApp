

import UIKit

class PeopleCell: UITableViewCell {

    
    @IBOutlet weak var lblPeopleName: UILabel!
    @IBOutlet weak var ImgPeople: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
