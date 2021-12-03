//
//  ViewController.swift
//  alisverisListesi_1
//
//  Created by xmod on 29.11.2021.
//

import UIKit
import CoreData

class ViewController: UIViewController , UITableViewDelegate,UITableViewDataSource{
  
    
    var isimDizi = [String]()
    var idDizi = [UUID]()
    
    var secilenUrunIsmı = ""
    var secilenUuıd : UUID?
    

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
      
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action:  #selector(eklemeFonk))
        
        verileriAl()
        
    }
    
    /// her zaman cağrılcak
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(verileriAl), name: NSNotification.Name(rawValue:"veri"), object: nil)
    }
    
    
    
    
   @objc func verileriAl(){
       
       isimDizi.removeAll(keepingCapacity: false)
       idDizi.removeAll(keepingCapacity: false)
       
        let appDelagate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelagate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Alisveris")
      
        fetchRequest.returnsObjectsAsFaults = false
        
        do{
            let sonuclar = try context.fetch(fetchRequest)
            
            // program ilk acıldığında sonuc büyükse datalari gosterilcek
            if sonuclar.count > 0 {
                for sonuc in sonuclar as! [NSManagedObject] {
                    if let isim = sonuc.value(forKey: "isim") as? String{
                        isimDizi.append(isim)
                    }
                    
                    if let id = sonuc.value(forKey: "id") as? UUID{
                        idDizi.append(id)
                    }
                    
                    
                    /// table view yenilemeyi unutma !!!
                    tableView.reloadData()
                    
                }
            }
            
           
            
        }catch{
            print("hata")
        }
         
    }
    
    @objc func eklemeFonk(){
    performSegue(withIdentifier: "ToDetayVc", sender: nil)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isimDizi.count
    }
    
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = isimDizi[indexPath.row]
        return cell
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ToDetayVc"{
            let destination = segue.destination as! DetayViewConroller
            destination.secilenUrun = secilenUrunIsmı
            destination.secilen = secilenUuıd
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        secilenUrunIsmı = isimDizi[indexPath.row]
        secilenUuıd = idDizi[indexPath.row]
        performSegue(withIdentifier: "ToDetayVc", sender: nil)
    }
    


}

