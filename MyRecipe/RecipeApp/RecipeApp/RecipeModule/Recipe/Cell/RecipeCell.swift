//
//  RecipeCell.swift
//  RecipeApp
//
//  Created by Kishor Pahalwani on 18/02/20.
//  Copyright © 2020 Kishor Pahalwani. All rights reserved.
//

import UIKit

class RecipeCell: UITableViewCell {

    @IBOutlet weak var labelMoreDetails: UILabel!
    @IBOutlet weak var labelRecipeDuration: UILabel!
    @IBOutlet weak var labelRecipeName: UILabel!
    @IBOutlet weak var imgViewRecipe: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func populateData(modelRecipe: RecipeModel) {
        labelRecipeName.text = modelRecipe.recipeName
        labelRecipeDuration.text = modelRecipe.timeDuration
        labelMoreDetails.text = Utils.localizedString(forKey: Keys.moreDetailsRecipe)
        
        if let appDir = DirectoryFolder.getApplicationFolderPath(), let recipeId = modelRecipe.id, !recipeId.contains("") {
            let fileURL = appDir.appendingPathComponent(recipeId)
            if FileManager.default.fileExists(atPath: fileURL.path) {
                let image = UIImage(contentsOfFile: fileURL.path)?.resizeWithWidthHeight(width: 120, height: 120)
                imgViewRecipe.image = image
            }
            else {
                imgViewRecipe.image = UIImage.init(named: Keys.defaultImg)
            }
        }
        
        else {
            imgViewRecipe.image = UIImage.init(named: Keys.defaultImg)
        }
    }
}
