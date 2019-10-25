//
//  CoreDataPhotosViewController.swift
//  CoreDataPhotos
//
//  Created by Brady Webb on 10/25/19.
//  Copyright © 2019 Brady Webb. All rights reserved.
//

import UIKit
import CoreData

class CoreDataPhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var CoreDataPhotos = [Text]()
    var dateFormatter = DateFormatter()
    @IBOutlet weak var CoreDataPhotosTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchTexts()
        CoreDataPhotosTableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CoreDataPhotos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let text = text[indexPath.row]
        cell.textLabel?.text = text.title
        if let addDate = text.addDate {
            cell.detailTextLabel?.text = dateFormatter.string(from: addDate)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (rowAction, indexPath) in
            self.deletephotos(indexPath: indexPath)
        }
        
        return [deleteAction]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? CoreDataPhotosTableViewController else {
            return
        }
        
        if let segueIdentifier = segue.identifier, segueIdentifier == "text", let indexPathForSelectedRow = CoreDataPhotosTableView.indexPathForSelectedRow {
            destination.CoreDataPhotos = text[indexPathForSelectedRow.row]
        }
    }
    
    func fetchText() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            text = [Text]()
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Text> = Text.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "rawAddDate", ascending: true)]
        
        do {
            text = try managedContext.fetch(fetchRequest)
        }
    }
    
    func deleteText(indexPath: IndexPath) {
        let text = text[indexPath.row]
        
        if let managedObjectContext = text.managedObjectContext {
            managedObjectContext.delete(text)
            
            do {
                try managedObjectContext.save()
                self.text.remove(at: indexPath.row)
                CoreDataPhotosTableView.reloadData()
            }
        }
    }
}
