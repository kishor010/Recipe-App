//
//  ViewController.swift
//  RecipeApp
//
//  Created by Kishor Pahalwani on 18/02/20.
//  Copyright © 2020 fourtitude. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setCustomNavigation(title: Utils.localizedString(forKey: Keys.home))
    }
    
    @IBAction func btnRecipeModuleTapped(_ sender: Any) {
        if let recipeVC = self.storyboard?.instantiateViewController(withIdentifier: ControllerConstants.recipeViewController) as? RecipeViewController {
            self.navigationController?.show(recipeVC, sender: nil)
        }
    }
}

