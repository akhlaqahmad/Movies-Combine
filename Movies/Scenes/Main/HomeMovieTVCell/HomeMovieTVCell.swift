//
//  HomeMovieTVCell.swift
//
//  Created by Akhlaq Ahmad on 14/05/2022.
//

import UIKit
import Kingfisher

class HomeMovieTVCell: UITableViewCell {

    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemTitleLabel: UILabel!
    @IBOutlet weak var itemGenreLabel: UILabel!
    @IBOutlet weak var itemDateLabel: UILabel!
    @IBOutlet weak var itemVoteLabel: UILabel!
    @IBOutlet weak var itemVoteCountLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bgView.layer.cornerRadius = 15
        bgView.layer.shadowColor = UIColor.black.cgColor
        bgView.layer.shadowOffset = .zero
        bgView.layer.shadowRadius = 5
        bgView.layer.shadowOpacity = 0.2
        itemImageView.layer.cornerRadius = 10
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        

    }
    
    func configureCell(model: MovieModel) {
        let url = URL(string: "https://image.tmdb.org/t/p/original/\(model.posterPath ?? "")")
        itemImageView.kf.indicatorType = .activity
        itemImageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeholder"),
            options: [
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        itemTitleLabel.text = model.title
        itemDateLabel.text = model.releaseDate
        itemVoteLabel.text = "Rating: \(model.voteAverage)/10"
        itemVoteCountLabel.text = "(\(model.voteCount))"
        itemGenreLabel.text = model.genreString
    }

    
}
