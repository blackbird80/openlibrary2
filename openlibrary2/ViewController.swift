//
//  ViewController.swift
//  openlibrary2
//
//  Created by rocio urtecho on 12/3/15.
//  Copyright © 2015 Carlos Concha. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var titulo: UITextView!
    @IBOutlet weak var autores: UITextView!
    @IBOutlet weak var imageURL: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        searchBar.delegate = self
        autores.text = ""
        titulo.text = ""
        imageURL.image = UIImage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()

        //
    }
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        sincrono(searchBar.text!)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            autores.text = ""
            titulo.text = ""
            imageURL.image = UIImage()
        }
    }
    
    func sincrono(texto:String){
        autores.text = ""
        titulo.text = ""
        imageURL.image = UIImage()
        let urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:" + texto
        let url = NSURL(string: urls)
        let datos:NSData? = NSData(contentsOfURL: url!)
        if datos == nil{
            let msgeAlerta = UIAlertController(title: "Mensaje", message: "Error en la conexión", preferredStyle: .Alert)
            msgeAlerta.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(msgeAlerta, animated: true, completion: nil)
        }else{
            do{
                let isbn = "ISBN:\(texto)"
                let cadenaJSON = try NSJSONSerialization.JSONObjectWithData(datos!, options: NSJSONReadingOptions.MutableLeaves)
                let diccio1 = cadenaJSON as! NSDictionary
                let diccio2 = diccio1[isbn] as! NSDictionary
                self.titulo.text = diccio2["title"] as! NSString as String
                let diccio3 = diccio2["authors"] as! NSArray
                for (var i=0;i<diccio3.count;i++){
                    let diccio4 = diccio3[i] as! NSDictionary
                    self.autores.text = String(diccio4["name"]!)
                }
                let diccio5 : NSDictionary? = diccio2["cover"] as? NSDictionary
                if ((diccio5) != nil) {
                    let urlTxt = diccio5!["small"] as! NSString as String
                    if let url = NSURL(string: urlTxt) {
                        if let data = NSData(contentsOfURL: url) {
                            imageURL.image = UIImage(data: data)
                        }
                    }
                }

              //  self.autores.text = diccio3["name"] as! NSString as String
            }catch _ {
                
            }
            
           // let cadenaJSON = NSString(data: datos!, encoding: NSUTF8StringEncoding)
            //print(cadenaJSON)
            
        }
        
        
    }
}

