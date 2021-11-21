//
//  ViewController.swift
//  MotivationApp
//
//  Created by Nikita on 15.11.2021.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    //получаю контекст

    @IBOutlet weak var quoteText: UITextView!
    @IBOutlet weak var authorText: UITextField!
    
    var selectedQuote: Quotes? = nil 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if selectedQuote != nil {
            quoteText.text = selectedQuote?.quote
            authorText.text = selectedQuote?.author
        }
    }
    
    @IBAction func saveButton(_ sender: Any) {
        //создаю контекст для сущности
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        if selectedQuote == nil {
            //создаю сущность
            let entity = NSEntityDescription.entity(forEntityName: "Quotes", in: context)
            
            let newQuote = Quotes(entity: entity!, insertInto: context)
            newQuote.quote = quoteText.text
            newQuote.author = authorText.text
            
            do {
                try context.save()
                allQuotes.append(newQuote)
                navigationController?.popViewController(animated: true)
            } catch  {
                print("Error")
            }
        } else //редактирование
            {
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Quotes")
                do {
                    let results: NSArray = try context.fetch(request) as NSArray
                    for result in results {
                        let quote = result as! Quotes
                        if quote == selectedQuote {
                            quote.quote = quoteText.text
                            quote.author = authorText.text
                            try context.save()
                            navigationController?.popViewController(animated: true)
                        }
                    }
                } catch  {
                    print("Error")
                }
            }
    }
    
    @IBAction func deleteQuote(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Quotes")
        do {
            let results: NSArray = try context.fetch(request) as NSArray
            for result in results {
                let quote = result as! Quotes
                if quote == selectedQuote {
                    quote.deletedDate = Date()
                    try context.save()
                    navigationController?.popViewController(animated: true)
                }
            }
        } catch  {
            print("Error")
        }
        
    }
}
