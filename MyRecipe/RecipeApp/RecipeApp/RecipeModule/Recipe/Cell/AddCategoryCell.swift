//
//  AddCategoryCell.swift
//  RecipeApp
//
//  Created by Kishor Pahalwani on 18/02/20.
//  Copyright © 2020 fourtitude. All rights reserved.
//

import UIKit

class AddCategoryCell: UITableViewCell {

    @IBOutlet weak var labelCategoryName: UILabel!
    @IBOutlet weak var imgViewPicture: UIImageView!
    @IBOutlet weak var textFieldRecipeName: UITextField!
    @IBOutlet weak var textViewGredients: UITextView!
    @IBOutlet weak var textFiledTimeDuration: UITextField!
    @IBOutlet weak var textViewSteps: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        //textFiledTimeDuration.delegate = self
        //textFiledTimeDuration.delegate = self
        //textViewGredients.delegate = self
        //textViewSteps.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func populateData(modelRecipe: RecipeModel?, categoty: CategoryModel?) {
        textFieldRecipeName.text = modelRecipe?.recipeName
        textViewGredients.text = modelRecipe?.ingredients
        textViewSteps.text = modelRecipe?.cookingSteps
        textFiledTimeDuration.text = modelRecipe?.timeDuration
        labelCategoryName.text = categoty?.categoryName
        
        if let appDir = DirectoryFolder.getApplicationFolderPath(), let recipeId = modelRecipe?.id, !recipeId.contains("") {
            let fileURL = appDir.appendingPathComponent(recipeId)
            if FileManager.default.fileExists(atPath: fileURL.path) {
                let image = UIImage(contentsOfFile: fileURL.path)
                imgViewPicture.image = image
            }
            else {
                imgViewPicture.image = UIImage.init(named: Keys.defaultCamera)
            }
        }
        
        else {
            imgViewPicture.image = UIImage.init(named: Keys.defaultCamera)
        }
    }
}
