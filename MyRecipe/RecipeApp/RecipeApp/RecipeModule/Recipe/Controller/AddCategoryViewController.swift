//
//  AddCategoryViewController.swift
//  RecipeApp
//
//  Created by Kishor Pahalwani on 18/02/20.
//  Copyright © 2020 Kishor Pahalwani. All rights reserved.
//

import UIKit
import Photos

protocol RecipeAddedProtocol: class {
    func addedRecipe(success: Bool)
}

class AddCategoryViewController: UIViewController {

    @IBOutlet weak var pickerHeight: NSLayoutConstraint!
    @IBOutlet weak var btnAddRecipe: UIButton!
    @IBOutlet weak var tableViewAddCategory: UITableView!
    @IBOutlet weak var viewPicker: UIView!
    @IBOutlet weak var picker: UIPickerView!
    
    weak var delegate: RecipeAddedProtocol?
    
    var recipe: RecipeModel?
    var arrCategories: [CategoryModel] = []
    var selectedCategory: CategoryModel?
    var imageData: Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        setupTableView()
        setupPickerView()
    }
    
    private func setupPickerView() {
        isPickerViewHidden(isHidden: true)
        picker.delegate = self
        picker.dataSource = self
        picker.showsSelectionIndicator = true
        pickerHeight.constant = (self.view.bounds.height / 2) - 60
    }
    
    fileprivate func isPickerViewHidden(isHidden: Bool) {
        self.viewPicker.isHidden = isHidden
        if isHidden {
            self.tableViewAddCategory.alpha = 1
            self.tableViewAddCategory.isUserInteractionEnabled = true
        }
        
        else {
            self.tableViewAddCategory.alpha = 0.1
            self.tableViewAddCategory.isUserInteractionEnabled = false
        }
    }
    
    @IBAction func btnPickerDoneTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.3) {
            self.isPickerViewHidden(isHidden: true)
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func btnAddRecipeTapped(_ sender: Any) {
        
        if recipe != nil {
            let alert = UIAlertController(title: Utils.localizedString(forKey: Keys.editRecipeConfirmation), message: "", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: Utils.localizedString(forKey: Keys.yes), style: .default, handler: { (alertAction) in
                
                self.saveUpdateDataIntoDB()
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: RecipeViewController.self) {
                        if let vc = (controller as? RecipeViewController) {
                            vc.isLoadedRecipeList = true
                            self.navigationController?.popToViewController(vc, animated: true)
                        }
                        break
                    }
                }
            }))
            alert.addAction(UIAlertAction(title: Utils.localizedString(forKey: Keys.no), style: .cancel, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
        
        else {
            saveUpdateDataIntoDB()
            delegate?.addedRecipe(success: true)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func saveUpdateDataIntoDB() {
        if let cell = tableViewAddCategory.cellForRow(at: IndexPath(row: 0, section: 0)) as? AddCategoryCell {
            if (cell.textFieldRecipeName.text!.count > 0) {
                if recipe == nil {
                    recipe = RecipeModel.init(id: "", recipeName: "", categoryId: "", cookingSteps: "", ingredients: "", timeDuration: "")
                    recipe?.id = "\(selectedCategory?.id ?? "")\(Date().timeIntervalSince1970)"
                }
                
                recipe?.recipeName = cell.textFieldRecipeName.text
                recipe?.categoryId = selectedCategory?.id
                recipe?.ingredients = cell.textViewGredients.text
                recipe?.cookingSteps = cell.textViewSteps.text
                recipe?.timeDuration = cell.textFiledTimeDuration.text
                DBService.sharedInstance.saveUpdateRecipe(model: recipe)
                DirectoryFolder.saveImage(imagePath: recipe?.id, imageData: self.imageData)
            }
            else {
                Utils.showAlert(AlertTitle: Utils.localizedString(forKey: Keys.alert), AlertMessage: Utils.localizedString(forKey: Keys.enterRecipeError), controller: self)
            }
        }
            
        else {
            debugPrint("Error")
        }
    }
    
    private func setupTableView() {
        tableViewAddCategory.separatorStyle = .none
        tableViewAddCategory.delegate = self
        tableViewAddCategory.dataSource = self
        tableViewAddCategory.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if recipe != nil {
            self.navigationItem.title = Utils.localizedString(forKey: Keys.editRecipe)
        }
        else {
            self.navigationItem.title = Utils.localizedString(forKey: Keys.addRecipe)
        }
    }
    
    //Initial
    private func initialSetup() {
        arrCategories = DBService.sharedInstance.fetchAllCategories()
        
        if selectedCategory == nil && arrCategories.count > 0 {
            selectedCategory = arrCategories[0]
        }
        
        if recipe != nil {
            btnAddRecipe.setTitle(Utils.localizedString(forKey: Keys.editRecipe), for: .normal)
        }
            
        else {
            btnAddRecipe.setTitle(Utils.localizedString(forKey: Keys.addRecipe), for: .normal)
        }
        
        let categoryType = UIBarButtonItem.init(title: Utils.localizedString(forKey: Keys.addCategory), style: .plain, target: self, action: #selector(tappedCategories))
        
        let customBack = UIBarButtonItem.init(title: Utils.localizedString(forKey: Keys.back), style: .plain, target: self, action: #selector(tappedBack))
        
        self.navigationItem.rightBarButtonItem = categoryType
        self.navigationItem.leftBarButtonItem = customBack
        
    }
    
    @objc fileprivate func tappedBack(buttonItem: UIBarButtonItem) {
        let alert = UIAlertController.init(title: Utils.localizedString(forKey: Keys.alert), message: Utils.localizedString(forKey: Keys.goBack), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Utils.localizedString(forKey: Keys.yes), style: .default, handler: { (alertAction) in
            self.navigationController?.popViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: Utils.localizedString(forKey: Keys.no), style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc fileprivate func tappedCategories(buttonItem: UIBarButtonItem) {
        UIView.animate(withDuration: 0.3) {
            self.isPickerViewHidden(isHidden: false)
            self.view.layoutIfNeeded()
        }
    }
    
    fileprivate func changeCategory() {
        if let cell = tableViewAddCategory.cellForRow(at: IndexPath(row: 0, section: 0)) as? AddCategoryCell {
            cell.labelCategoryName.text = self.selectedCategory?.categoryName
        }
    }
    
    @objc func tappedImageView(tapGesure: UITapGestureRecognizer) {
        authorisationStatus()
    }
    
    fileprivate func openCameraPhotos() {
        DispatchQueue.main.async {
            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.delegate = self
            self.present(imagePickerController,animated: true, completion: nil)
        }
    }
    
    //Camera Alert
    fileprivate func addAlertForPhotosAccess() {
        let alertController = UIAlertController (title: Utils.localizedString(forKey: Keys.alert), message: Utils.localizedString(forKey: Keys.cameraAccess), preferredStyle: .alert)

        let settingsAction = UIAlertAction(title: Utils.localizedString(forKey: Keys.gotoSettings), style: .default) { (_) -> Void in

            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }

            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    
                })
            }
        }
        
        alertController.addAction(settingsAction)
        
        let cancelAction = UIAlertAction(title: Utils.localizedString(forKey: Keys.no), style: .default, handler: nil)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }
    
    //Check camera authorisation status
    fileprivate func authorisationStatus() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            openCameraPhotos()
            break
        case .denied, .restricted:
            addAlertForPhotosAccess()
            break
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ (status) in
                if status == PHAuthorizationStatus.authorized{
                    // photo library access given
                    self.openCameraPhotos()
                }
            })
        default:
            break
        }
    }
}

//MARK:- Tableview Delegate and Datasource
extension AddCategoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: ControllerConstants.addCategoryCell) as? AddCategoryCell
        
        if (nil == cell) {
            let nib:Array = Bundle.main.loadNibNamed(ControllerConstants.addCategoryCell, owner: self, options: nil)!
            cell = nib[0] as? AddCategoryCell
        }
        
        cell?.selectionStyle = .none
        cell?.populateData(modelRecipe: recipe, categoty: selectedCategory)
        //cell?.populateData(modelRecipe: arrAllRecipes[indexPath.row])
        cell?.textFieldRecipeName.delegate = self
        cell?.textFiledTimeDuration.delegate = self
        cell?.textViewSteps.delegate = self
        cell?.textViewGredients.delegate = self
        let addTapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedImageView))
        cell?.addGestureRecognizer(addTapGesture)
        cell?.imgViewPicture.isUserInteractionEnabled = true
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 100
        return UITableView.automaticDimension
    }
}

//MARK:- Picker control delegate
extension AddCategoryViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCategory = arrCategories[row]
        changeCategory()
        isPickerViewHidden(isHidden: true)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrCategories[row].categoryName
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrCategories.count
    }
}

//MARK:- Text Field and TextView delegate
extension AddCategoryViewController: UITextFieldDelegate, UITextViewDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    fileprivate func setImageFromPicker(image: UIImage) {
        if let cell = tableViewAddCategory.cellForRow(at: IndexPath(row: 0, section: 0)) as? AddCategoryCell {
            cell.imgViewPicture?.image = image
        }
    }
}

//MARK: Image picker controller delegate
extension AddCategoryViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            dismiss(animated: false, completion: nil)
            return
        }
        
        setImageFromPicker(image: selectedImage)
        if let data = selectedImage.jpegData(compressionQuality: 1) {
            self.imageData = data
        }
        /*if let data = selectedImage.jpegData(compressionQuality: 0.5) ?? selectedImage.pngData() {
            self.imageData = data
        }*/
        dismiss(animated: true, completion: nil)
    }
}
