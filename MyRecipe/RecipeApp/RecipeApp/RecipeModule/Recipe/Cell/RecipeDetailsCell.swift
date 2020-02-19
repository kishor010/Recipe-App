//
//  RecipeDetailsCell.swift
//  RecipeApp
//
//  Created by Kishor Pahalwani on 18/02/20.
//  Copyright © 2020 fourtitude. All rights reserved.
//

import UIKit

class RecipeDetailsCell: UITableViewCell {

    @IBOutlet weak var imgViewRecipe: UIImageView!
    @IBOutlet weak var labelTimeDuration: UILabel!
    @IBOutlet weak var labelCookingSteps: UILabel!
    @IBOutlet weak var labelRecipeIngredients: UILabel!
    @IBOutlet weak var labelCategoryName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func populateData(modelRecipe: RecipeModel?, categoty: CategoryModel?) {
        labelCategoryName.text = modelRecipe?.recipeName
        labelTimeDuration.text = Utils.localizedString(forKey: Keys.durationRecipe) + (modelRecipe?.timeDuration ?? "")
        labelCookingSteps.text = Utils.localizedString(forKey: Keys.steps) + ( modelRecipe?.cookingSteps ?? "")
        labelRecipeIngredients.text = Utils.localizedString(forKey: Keys.ingredients) + (modelRecipe?.ingredients ?? "")
        
        if let appDir = DirectoryFolder.getApplicationFolderPath(), let recipeId = modelRecipe?.id, !recipeId.contains("") {
            let fileURL = appDir.appendingPathComponent(recipeId)
            if FileManager.default.fileExists(atPath: fileURL.path) {
                let image = UIImage(contentsOfFile: fileURL.path)
                imgViewRecipe.image = image
                self.imgViewRecipe.isUserInteractionEnabled = true
            }
            else {
                imgViewRecipe.image = UIImage.init(named: Keys.defaultImg)
                self.imgViewRecipe.isUserInteractionEnabled = false
            }
        }
        
        else {
            imgViewRecipe.image = UIImage.init(named: Keys.defaultImg)
            self.imgViewRecipe.isUserInteractionEnabled = false
        }
    }
}
