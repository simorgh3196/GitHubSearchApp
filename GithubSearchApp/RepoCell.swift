//
//  RepoCell.swift
//  GithubSearchApp
//
//  Created by 早川智也 on 2016/06/10.
//  Copyright © 2016年 simorgh. All rights reserved.
//

import UIKit

final class RepoCell: UITableViewCell {
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var starCountLabel: UILabel!
    @IBOutlet weak var forkCountLabel: UILabel!
    @IBOutlet weak var lastCommitDateLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cardView.layer.cornerRadius = 4
        cardView.layer.borderWidth = 1
        cardView.layer.borderColor = UIColor(white: 0, alpha: 0.2).CGColor
    }
    
    func updateCell(repo: Repository) {
        
        titleLabel.text = repo.name
        ownerLabel.text = repo.owner.login
        descriptionLabel.text = repo.descriptionRepo
        NumberFormatter.instance.numberStyle = .DecimalStyle
        starCountLabel.text = NumberFormatter.instance.stringFromNumber(repo.stargazersCount)
        forkCountLabel.text = NumberFormatter.instance.stringFromNumber(repo.forksCount)
        lastCommitDateLabel.text = repo.pushedAt
    }
    
}
