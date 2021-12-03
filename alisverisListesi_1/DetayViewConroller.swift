//
//  DetayViewConroller.swift
//  alisverisListesi_1
//
//  Created by xmod on 29.11.2021.
//

import UIKit
import CoreData

class DetayViewConroller: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {


    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var isimTextField: UITextField!
    @IBOutlet weak var fiyatTextField: UITextField!
    @IBOutlet weak var bedenTextField: UITextField!
    
    var secilenUrun = ""
    var secilen : UUID?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if secilenUrun != ""{
            
            if let uuidString =  secilen?.uuidString{
                
                let appDelagate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelagate.persistentContainer.viewContext
                
                
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Alisveris")
              
                fetchRequest.predicate = NSPredicate(format: "id = %@" , uuidString)
                fetchRequest.returnsObjectsAsFaults = false
                
                do {
                    let sonuclar = try context.fetch(fetchRequest)
                    
                    if sonuclar.count > 0{
                        
                        for sonuc in sonuclar as! [NSManagedObject]{
                            
                            if let isim = sonuc.value(forKey: "isim") as? String{
                                isimTextField.text = isim
                            }
                            
                            if let fiyat = sonuc.value(forKey: "fiyat") as? Int{
                                fiyatTextField.text = String(fiyat)
                            }
                            
                            if let beden = sonuc.value(forKey: "beden") as? String{
                                bedenTextField.text = beden
                            }
                            
                            if let gorsel = sonuc.value(forKey: "gorsel") as? Data{
                                let image = UIImage(data: gorsel)
                                img2.image = image
                            }
                                
                                
                        }
                        
                    }
                    
                }catch{
                    print("hata var")
                }
            
                
            }
            
            
        }else{
            isimTextField.text = ""
            fiyatTextField.text = ""
            bedenTextField.text = ""
        }
        
        
        /// klavye kapatma
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(klavyeKapat))
        view.addGestureRecognizer(gestureRecognizer)
        
        /// image Click
        img2.isUserInteractionEnabled = true
        let imageClickRecognizer = UITapGestureRecognizer(target: self, action: #selector(ImageClick))
        img2.addGestureRecognizer(imageClickRecognizer)

    }
    
    @objc func ImageClick(){

       let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        img2.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    @objc func klavyeKapat(){
        view.endEditing(true)
    }
    

    @IBAction func saveButton(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let alisveris = NSEntityDescription.insertNewObject(forEntityName: "Alisveris", into: context)
        
        
        alisveris.setValue(isimTextField.text! , forKey: "isim")
        alisveris.setValue(bedenTextField.text!, forKey: "beden")
        
        if let fiyat = Int(fiyatTextField.text!){
            alisveris.setValue(fiyat, forKey: "fiyat")
        }
        
        
        alisveris.setValue(UUID(), forKey: "id")
        
        let imageData = img2.image!.jpegData(compressionQuality: 0.5)
        alisveris.setValue(imageData, forKey: "gorsel")
        
        
        do {
            try context.save()
            
        }catch{
            print("hata")
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "veri"), object: nil)
        self.navigationController?.popViewController(animated: true)
        
    }
    

}
