//
//  TabBarView.swift
//  IntraZeroTask
//
//  Created by Moataz Mohamed on 28/07/2024.
//

import Foundation
import UIKit
import CoreData


class TabBarView:UITabBarController{
    
    let modelContext:NSManagedObjectContext
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let charactersView = CharactersView(modelContext: modelContext)
        charactersView.tabBarItem = UITabBarItem(title: "Characters", image: UIImage(systemName: "person.3"), tag: 0)
        
        let starshipsView = StarshipsView(modelContext: modelContext)
        starshipsView.tabBarItem = UITabBarItem(title: "Starships", image: UIImage(systemName: "airplane"), tag: 1)
        
        let viewControllerList = [charactersView, starshipsView]
        
        viewControllers = viewControllerList.map { UINavigationController(rootViewController: $0) }
        
        tabBar.tintColor = .lightGray
        tabBar.unselectedItemTintColor = .black
        

    }
    
    init(modelContext: NSManagedObjectContext) {
        self.modelContext = modelContext
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
