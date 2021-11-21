//
//  TableViewController.swift
//  MotivationApp
//
//  Created by Nikita on 14.11.2021.
//

import UIKit
import CoreData

//cоздаю массив всех цитат и делаю общедоступным на всякий случай
var allQuotes = [Quotes]()


class TableViewController: UITableViewController {

    var firstLoad = true
    
    func nonDeletedQuotes() -> [Quotes] {
        var nonDeletedAllQuotes = [Quotes]()
        for quote in allQuotes {
            if quote.deletedDate == nil {
                nonDeletedAllQuotes.append(quote)
            }
        }
        
        return nonDeletedAllQuotes
    }
    
    override func viewDidLoad() {
        if (firstLoad) {
            firstLoad = false
            //опять получаю контекст
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Quotes")
            do {
                let results: NSArray = try context.fetch(request) as NSArray
                for result in results {
                    let quote = result as! Quotes
                    allQuotes.append(quote)
                }
            } catch  {
                print("Error")
            }
            
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // использую dequeue, чтобы переиспользовать ячейку
        let newCell = tableView.dequeueReusableCell(withIdentifier: "theCell", for: indexPath) as! Cells
        
        let thisQuote: Quotes!
        thisQuote = nonDeletedQuotes()[indexPath.row]
        
        newCell.quoteLabel.text = thisQuote.quote
        newCell.authorLabel.text = thisQuote.author
       
        
        return newCell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return nonDeletedQuotes().count
      
    }

    override func viewDidAppear(_ animated: Bool) {
        //не уверен в правильности этого действия, но насколько я понимаю операции с обновлением интерфейса нужно делать в освновном потоке, поэтому попробовал реализовать 
        DispatchQueue.main.async {

            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "editQuote", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editQuote" {
            let indexPath = tableView.indexPathForSelectedRow!
            
            let quoteDetail = segue.destination as? ViewController
            
            let selectedQuote: Quotes!
            selectedQuote = nonDeletedQuotes()[indexPath.row]
            quoteDetail!.selectedQuote = selectedQuote
            
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
