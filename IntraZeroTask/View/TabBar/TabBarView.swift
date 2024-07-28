//
//  TabBarView.swift
//  IntraZeroTask
//
//  Created by Moataz Mohamed on 28/07/2024.
//

import Foundation
import UIKit



class TabBarView:UITabBarController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let charactersView = CharactersView()
        charactersView.tabBarItem = UITabBarItem(title: "Characters", image: UIImage(systemName: "person.3"), tag: 0)
        
        let starshipsView = StarshipsView()
        starshipsView.tabBarItem = UITabBarItem(title: "Starships", image: UIImage(systemName: "airplane"), tag: 1)
        
        let viewControllerList = [charactersView, starshipsView]
        
        viewControllers = viewControllerList.map { UINavigationController(rootViewController: $0) }
        
        tabBar.tintColor = .lightGray
        tabBar.unselectedItemTintColor = .black
        

    }
}
