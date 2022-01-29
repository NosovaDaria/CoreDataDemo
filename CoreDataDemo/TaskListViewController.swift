//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by Дарья Носова on 29.01.2022.
//

import UIKit
import CoreData

class TaskListViewController: UITableViewController {
//  private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
  private let cellID = "task"
  private var taskList: [Task] = []

  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    fetchData()
  }
  
  private func setupView() {
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
    view.backgroundColor = .white
    setupNavigationBar()  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    fetchData()
    tableView.reloadData()
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
    showAlert()
  }
  
  private func fetchData() {
    StorageManager.shared.fetchData { result in
      switch result {
      case .success(let tasks):
        self.taskList = tasks
      case .failure(let error):
        print(error.localizedDescription)
      }
    }
  }
  
  private func save(_ taskName: String) {
    StorageManager.shared.save(taskName) { task in
      self.taskList.append(task)
      self.tableView.insertRows(
        at: [IndexPath(row: self.taskList.count - 1, section: 0)],
        with: .automatic)
    }
  }
}

extension TaskListViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    taskList.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
    let task = taskList[indexPath.row]
    
    var content = cell.defaultContentConfiguration()
    content.text = task.name
    cell.contentConfiguration = content
    return cell
   }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let task = taskList[indexPath.row]
    showAlert(task: task) {
      tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    let task = taskList[indexPath.row]
    
    if editingStyle == .delete {
      taskList.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .automatic)
      StorageManager.shared.delete(task)
    }
  }
}

extension TaskListViewController {
  
  private func showAlert(task: Task? = nil, completion: (() -> Void)? = nil) {
    let title = task != nil ? "Update task" : "New task"
    let alert = UIAlertController.createAlertController(withTitle: title)
    
    alert.action(task: task) { taskName in
      if let task = task, let completion = completion {
        StorageManager.shared.edit(task, newName: taskName)
        completion()
      } else {
        self.save(taskName)
      }
    }
    
    present(alert, animated: true)
  }
}
