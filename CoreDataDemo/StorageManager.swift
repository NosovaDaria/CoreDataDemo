//
//  StorageManager.swift
//  CoreDataDemo
//
//  Created by Дарья Носова on 29.01.2022.
//
 
import CoreData

class StorageManager {
  
  static let shared = StorageManager()
  
// MARK: - Core Data stack
private let persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "CoreDataDemo")
  container.loadPersistentStores {_, error in
        if let error = error as NSError? {
          
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    }
    return container
}()

  private let viewContext: NSManagedObjectContext
  
  private init() {
    viewContext = persistentContainer.viewContext
  }
// MARK: - Core Data Saving support

 func fetchData(completion: (Result<[Task], Error>) -> Void) {
    let fetchRequest = Task.fetchRequest()
    
    do {
      let tasks = try viewContext.fetch(fetchRequest)
      completion(.success(tasks))
    } catch let error{
      completion(.failure(error))
    }
  }
  
  func save(_ taskName: String, completion: (Task) -> Void) {
    let task = Task(context: viewContext)
    task.name = taskName
    completion(task)
    saveContext()
  }
  
  func edit(_ task: Task, newName: String) {
    task.name = newName
    saveContext()
  }
  
  func delete(_ task: Task) {
    viewContext.delete(task)
    saveContext()
  }
  
  
  func saveContext () {
      if viewContext.hasChanges {
          do {
              try viewContext.save()
          } catch {
              let nserror = error as NSError
              fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
          }
      }
  }}
