//
//  TableViewController.swift
//  EuskoEvents
//
//  Created by David Nuño on 21/12/17.
//  Copyright © 2017 com.davidnuno. All rights reserved.
//

import UIKit



class TableViewController: UITableViewController {

    // Objeto de SwiftyJSON
    var json: JSON?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // REF: Desactivar verificación de HTTPS: https://stackoverflow.com/a/30732693/5136913
        let url = "http://opendata.euskadi.eus/contenidos/ds_eventos/eventos_turisticos/opendata/agenda.json"
        
        // No podemos usar .responseJSON(), porque no es un JSON válido
        Alamofire.request(url, method: .get).validate().responseString { response in
            switch response.result {
            case .success(let value):
                
                // Arreglamos los desperfectos
                var temp = value.dropFirst(13) // jsonCallback(
                temp = temp.dropLast(2) // );
                
                // La codificación de caractéres tampoco es válida, debería ser .utf8
                if let dataFromString = temp.data(using: .isoLatin1, allowLossyConversion: false) {
                    
                    // Convertir el String en JSON con SwiftyJSON
                    self.json = try! JSON(data: dataFromString)
                    
                    // Pedir la recarga de la tabla
                    self.tableView.reloadData()
                }
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Si no hay datos, no hay filas
        return json?.array?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath)
        
        cell.textLabel?.text = json?[indexPath.row]["documentName"].string
        
        return cell
    }

}
