//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by Дарья Носова on 29.01.2022.
//

import UIKit

class TaskListViewController: UITableViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    setupNavigationBar()
  }

  private func setupNavigationBar() {
    title = "Task List"
    navigationController?.navigationBar.prefersLargeTitles = true
    
    let navBarAppearence = UINavigationBarAppearance()
    navBarAppearence.configureWithOpaqueBackground()
    navBarAppearence.titleTextAttributes = [.foregroundColor: UIColor.white]
    navBarAppearence.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    
    navBarAppearence.backgroundColor = UIColor(
      red: 21/255,
      green: 101/255,
      blue: 192/255,
      alpha: 194/255
    )
    
    navigationController?.navigationBar.standardAppearance = navBarAppearence
    navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearence
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .add,
      target: self,
      action: #selector(addNewTask)
    )
    
    navigationController?.navigationBar.tintColor = .white
  }
  
  @objc private func addNewTask() {
    let newTaskVC = TaskViewController()
    present(newTaskVC, animated: true)
  }
}

