//
//  RecipeViewController.swift
//  RecipeApp
//
//  Created by Kishor Pahalwani on 18/02/20.
//  Copyright © 2020 Kishor Pahalwani. All rights reserved.
//

import UIKit

class RecipeViewController: UIViewController {
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var pickerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var viewPicker: UIView!
    @IBOutlet weak var tableViewRecipes: UITableView!
    @IBOutlet weak var labelNoRecipe: UILabel!
    
    var arrCategories: [CategoryModel]!
    var arrAllRecipes: [RecipeModel]!
    var elementName: String?
    var categoryId: String?
    var categoryName: String?
    var isFilterSelected: Bool = false
    var isLoadedRecipeList: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        getAllRecipeAndCategories()
        checkIfRecipeAvail()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = Utils.localizedString(forKey: Keys.listRecipe)
        isFilterSelected = false
        
        if let loadedView = isLoadedRecipeList, loadedView == true {
            self.addOrDeleteOperation()
        }
    }
    
    @IBAction func btnPickerViewDoneTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.3) {
            self.isPickerViewHidden(isHidden: true)
            self.view.layoutIfNeeded()
        }
    }
    
    private func initialSetup() {
        setupPickerView()
        labelNoRecipe.text = Utils.localizedString(forKey: Keys.noRecipeText)
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        let play = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(filterTapped))

        navigationItem.rightBarButtonItems = [add, play]
    }
    
    private func setupPickerView() {
        isPickerViewHidden(isHidden: true)
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.showsSelectionIndicator = true
        pickerViewHeight.constant = (self.view.bounds.height / 2) - 60
    }
    
    @objc fileprivate func filterTapped(button: UIBarButtonItem) {
        
        if isFilterSelected {
            UIView.animate(withDuration: 0.3) {
                self.isPickerViewHidden(isHidden: false)
            }
        }
        else {
            if self.arrAllRecipes.count > 1 {
                UIView.animate(withDuration: 0.3) {
                    self.isPickerViewHidden(isHidden: false)
                }
            }
            else {
                Utils.showAlert(AlertTitle: Utils.localizedString(forKey: Keys.moreRecipe), AlertMessage: "", controller: self)
            }
        }
        self.view.layoutIfNeeded()
    }
    
    fileprivate func isPickerViewHidden(isHidden: Bool)
    {
        self.viewPicker.isHidden = isHidden
        
        if isHidden {
            self.tableViewRecipes.alpha = 1
            self.tableViewRecipes.isUserInteractionEnabled = true
        }
        
        else {
            self.tableViewRecipes.alpha = 0.1
            self.tableViewRecipes.isUserInteractionEnabled = false
        }
    }
    
    @objc fileprivate func addTapped(button: UIBarButtonItem) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: ControllerConstants.addCategoryViewController) as? AddCategoryViewController {
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    fileprivate func getAllRecipeAndCategories() {
        showProgressIndicator(view: self.view)
        getRecipesFromDB()
        getCategoriesFromXML()
        hideProgressIndicator(view: self.view)
    }
    
    private func setupTableView() {
        tableViewRecipes.separatorStyle = .none
        tableViewRecipes.delegate = self
        tableViewRecipes.dataSource = self
        tableViewRecipes.tableFooterView = UIView()
    }
    
    private func getRecipesFromDB() {
        arrCategories = DBService.sharedInstance.fetchAllCategories()
        arrAllRecipes = DBService.sharedInstance.fetchAllRecipes()
    }
    
    private func getCategoriesFromXML() {
        if !(arrCategories.count > 0) {
            if let path = Bundle.main.url(forResource: CodingKeysConstant.categoryType, withExtension: CodingKeysConstant.categoryFormat) {
                if let parser = XMLParser(contentsOf: path) {
                    parser.delegate = self
                    parser.parse()
                }
            }
        }
    }
    
    //Check if data is available or not
    fileprivate func checkIfRecipeAvail() {
       if arrAllRecipes.count > 0 && arrCategories.count > 0 {
            tableViewRecipes.isHidden = false
            labelNoRecipe.isHidden = true
        }
        else {
            tableViewRecipes.isHidden = true
            labelNoRecipe.isHidden = false
        }
    }
    
    fileprivate func addOrDeleteOperation() {
        if pickerView != nil {
            pickerView.selectRow(0, inComponent: 0, animated: false)
        }
        isFilterSelected = false
        getRecipesFromDB()
        checkIfRecipeAvail()
        tableViewRecipes.reloadData()
    }
}

//MARK:- Tableview Delegate and Datasource
extension RecipeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrAllRecipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: ControllerConstants.recipeCell) as? RecipeCell
        
        if (nil == cell) {
            let nib:Array = Bundle.main.loadNibNamed(ControllerConstants.recipeCell, owner: self, options: nil)!
            cell = nib[0] as? RecipeCell
        }
        
        cell?.selectionStyle = .none
        
        cell?.populateData(modelRecipe: arrAllRecipes[indexPath.row])
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 100
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: ControllerConstants.recipeDetailsViewController) as? RecipeDetailsViewController {
            vc.recipe = arrAllRecipes[indexPath.row]
            let category = DBService.sharedInstance.fetchCategoryBy(id: arrAllRecipes[indexPath.row].categoryId)
            if category.count > 0 {
                vc.category = category[0]
            }
            vc.delegate = self
            self.navigationController?.show(vc, sender: nil)
        }
    }
}

//MARK: Recipe XML Parse Delegate
extension RecipeViewController: XMLParserDelegate{
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {

        self.elementName = elementName
        if elementName == CodingKeysConstant.category {
            self.categoryId = ""
            self.categoryName = ""
        }
    }
   
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == CodingKeysConstant.category {
            let modelCategory = CategoryModel.init(id: categoryId, categoryName: categoryName)
            DBService.sharedInstance.saveUpdateCategory(model: modelCategory)
            arrCategories?.append(modelCategory)
            
            //Add dummy value of recipe (First time launch)
            let modelRecipe = RecipeModel.init(id: "\(modelCategory.id ?? "")\(Date().timeIntervalSince1970)", recipeName: "Default \(categoryName ?? "")", categoryId: categoryId ?? "", cookingSteps: "Add \(categoryId ?? "Default")", ingredients: "", timeDuration: "30m")
            
            DBService.sharedInstance.saveUpdateRecipe(model: modelRecipe)
            arrAllRecipes.append(modelRecipe)
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if (!data.isEmpty) {
            if self.elementName == CodingKeysConstant.id, self.categoryId != nil {
                self.categoryId! += data
            }else if self.elementName == CodingKeysConstant.categoryName, self.categoryName != nil {
                categoryName! += data
            }
        }
    }
    
    fileprivate func applyFilter(indexRecipe: Int) {
        if indexRecipe < 0 {
            isFilterSelected = false
            self.navigationItem.title = Utils.localizedString(forKey: Keys.listRecipe)
            arrAllRecipes = DBService.sharedInstance.fetchAllRecipes()
        }
        else {
            isFilterSelected = true
            self.navigationItem.title = arrCategories[indexRecipe].categoryName
            arrAllRecipes = DBService.sharedInstance.fetchAllRecipesWithCategory(categoryId: arrCategories[indexRecipe].id)
        }
        checkIfRecipeAvail()
        tableViewRecipes.reloadData()
    }
}

//MARK:- Picker control delegate
extension RecipeViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        applyFilter(indexRecipe: row - 1)
        isPickerViewHidden(isHidden: true)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if row == 0 {
            return Utils.localizedString(forKey: Keys.listRecipe)
        }
        
        else {
            return arrCategories[row - 1].categoryName
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrCategories.count + 1
    }
}

//MARK:- Recipe Delete protocol
extension RecipeViewController: RecipeDeleteProtocol {
    func deleteRecipe(isDeletedOrEdited: Bool) {
        if isDeletedOrEdited {
            addOrDeleteOperation()
        }
    }
}

//MARK:- Added Recipe successfully
extension RecipeViewController: RecipeAddedProtocol {
    func addedRecipe(success: Bool) {
        addOrDeleteOperation()
    }
}
