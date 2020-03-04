
import UIKit

class SearchMoviesCell: UITableViewCell {

    @IBOutlet var ImgSearch: UIImageView!
    @IBOutlet var lblMoviesName: UILabel!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblTotalView: UILabel!
    @IBOutlet var lblVote: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
