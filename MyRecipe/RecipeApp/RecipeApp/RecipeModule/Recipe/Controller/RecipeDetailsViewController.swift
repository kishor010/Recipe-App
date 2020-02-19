//
//  RecipeDetailsViewController.swift
//  RecipeApp
//
//  Created by Kishor Pahalwani on 18/02/20.
//  Copyright © 2020 fourtitude. All rights reserved.
//

import UIKit

protocol RecipeDeleteProtocol: class {
    func deleteRecipe(isDeletedOrEdited: Bool)
}

class RecipeDetailsViewController: UIViewController {

    @IBOutlet weak var tableViewRecipeDetails: UITableView!
    @IBOutlet weak var viewFullImageView: UIView!
    weak var delegate: RecipeDeleteProtocol?
    
    @IBOutlet weak var imgViewFullRecipeImage: UIImageView!
    var recipe: RecipeModel?
    var category: CategoryModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if recipe != nil {
            setupTableView()
            initialSetup()
        }
    }
    
    @IBAction func btnCloseFullImageViewTapped(_ sender: Any) {
        imageViewFullRecipeImageStatus(isShown: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = category?.categoryName
        self.viewFullImageView.isHidden = true
    }
    
    fileprivate func imageViewFullRecipeImageStatus(isShown: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.viewFullImageView.isHidden = !isShown
            self.view.layoutIfNeeded()
        }
    }
    
    @objc fileprivate func imgRecipeTapped(tapGs: UITapGestureRecognizer) {
        imageViewFullRecipeImageStatus(isShown: true)
    }
    
    fileprivate func initialSetup() {
        if let appDir = DirectoryFolder.getApplicationFolderPath() {
            let fileURL = appDir.appendingPathComponent(recipe?.id ?? "")
            if FileManager.default.fileExists(atPath: fileURL.path) {
                let image = UIImage(contentsOfFile: fileURL.path)
                imgViewFullRecipeImage.image = image
            }
        }
    }
    
    @IBAction func btnEditRecipeTapped(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: ControllerConstants.addCategoryViewController) as? AddCategoryViewController {
            vc.recipe = self.recipe
            vc.selectedCategory = self.category
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func btnDeleteRecipeTapped(_ sender: Any) {
        
        let alert = UIAlertController.init(title: "Alert", message: Utils.localizedString(forKey: Keys.deleteRecipe), preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: Utils.localizedString(forKey: Keys.yes), style: .default, handler: { (alertAction) in
            DBService.sharedInstance.deleteRecipe(id: self.recipe?.id, categoryId: self.category?.id)
            self.delegate?.deleteRecipe(isDeletedOrEdited: true)
            DirectoryFolder.deleteRecipeImage(imagePath: self.recipe?.id)
            self.navigationController?.popViewController(animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: Utils.localizedString(forKey: Keys.no), style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func setupTableView() {
        tableViewRecipeDetails.separatorStyle = .none
        tableViewRecipeDetails.delegate = self
        tableViewRecipeDetails.dataSource = self
        tableViewRecipeDetails.tableFooterView = UIView()
    }
}

//MARK:- Recipe Table view Delagate and Datasource
extension RecipeDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1  
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: ControllerConstants.recipeDetailsCell) as? RecipeDetailsCell
        
        if (nil == cell) {
            let nib:Array = Bundle.main.loadNibNamed(ControllerConstants.recipeDetailsCell, owner: self, options: nil)!
            cell = nib[0] as? RecipeDetailsCell
        }
        
        cell?.selectionStyle = .none
        cell?.populateData(modelRecipe: recipe, categoty: category)
        let tapGs = UITapGestureRecognizer(target: self, action: #selector(imgRecipeTapped))
        cell?.imgViewRecipe.addGestureRecognizer(tapGs)
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 100
        return UITableView.automaticDimension
    }
}
