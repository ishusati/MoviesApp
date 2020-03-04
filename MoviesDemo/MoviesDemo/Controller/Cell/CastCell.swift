

import UIKit

class CastCell: UITableViewCell {

    @IBOutlet var ImgMovies: UIImageView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblReleaseDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
