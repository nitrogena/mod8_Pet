//
//  NuevoRViewController.swift
//  practica1
//
//  Created by Invitado on 15/10/16.
//  Copyright © 2016 Invitado. All rights reserved.
//

import UIKit


//lo que se pone aqui son protocolos, los ultimos tienen metodos requeridos, los primeros no
class NuevoRViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource
{
    //PARA PICKERS DE ESTADOS
    var estados:NSArray?
    var municipios:NSArray?
    var colonias:NSArray?
    
    var conexion:NSURLConnection?
    var datosRecibidos:NSMutableData?
    
    
    @IBOutlet weak var txtFechaNac: UITextField!
    @IBOutlet weak var txtNombres: UITextField!
    @IBOutlet weak var dtePckFechaNac: UIDatePicker!
    
    @IBOutlet weak var txtColonia: UITextField!
    @IBOutlet weak var txtEdo: UITextField!
    @IBOutlet weak var txtApellidos: UITextField!
    @IBOutlet weak var txtMunicipio: UITextField!
    @IBOutlet weak var txtCalleNo: UITextField!
    
    @IBOutlet weak var pickerEstados: UIPickerView!
    @IBOutlet weak var pickerMuns: UIPickerView!
    @IBOutlet weak var pickerCols: UIPickerView!
    
    
    @IBAction func pickerDateChanged(sender: AnyObject) {
        var formato = NSDateFormatter()
        formato.dateFormat = "dd-MM-yyyy"
        let fechaString = formato.stringFromDate(self.dtePckFechaNac.date)
        self.txtFechaNac.text = fechaString
    }
    
    //LOS REQUERIDOS POR LOS PROTOCOLOS DE LOS PICKERS DE ESTADOS
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    // returns the # of rows in each component..
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        //comparar lo recibido contra lo que se tiene
        if pickerEstados.isEqual(pickerView){
            return estados!.count
        }
        else if pickerMuns.isEqual(pickerView){
            return municipios!.count
        }
        else {
            return colonias!.count
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        if pickerEstados.isEqual(pickerView){
            
            return (estados![row].valueForKey("nombreEstado") as! String)
        }
        else if pickerMuns.isEqual(pickerView){
            return municipios![row] as! String
        }
        else {
            return colonias![row] as! String        }
    }
    
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool{
        
        if textField.isEqual(self.txtNombres) || textField.isEqual(self.txtApellidos) || textField.isEqual(self.txtCalleNo)
        {
            
            self.ocultaPickers()
            return true
            
        }
        else{
            self.txtNombres.resignFirstResponder()
            self.txtApellidos.resignFirstResponder()
            self.txtCalleNo.resignFirstResponder()
            if textField.isEqual(self.txtFechaNac){
                self.subeBajaPicker(self.dtePckFechaNac, subeObaja: true)
            }
            
            if textField.isEqual(self.txtEdo){
                self.subeBajaPicker(self.pickerEstados, subeObaja: true)
            }
            if textField.isEqual(self.txtMunicipio){
                self.subeBajaPicker(self.pickerMuns, subeObaja: true)
            }
            if textField.isEqual(self.txtColonia){
                self.subeBajaPicker(self.pickerCols, subeObaja: true)
            }
            
            //TODO: otros pickers
            return false
        }
        
        
    }
    
    func subeBajaPicker(elPicker:UIView, subeObaja:Bool){
        var elFrame:CGRect = elPicker.frame
        UIView.animateWithDuration(0.5){
            if subeObaja{
                
                //TAREA EL IF
                if elPicker == self.dtePckFechaNac{
                elFrame.origin.y = CGRectGetMaxY(self.txtFechaNac.frame)
                }
                if elPicker == self.pickerEstados{
                    elFrame.origin.y = CGRectGetMaxY(self.txtEdo.frame)
                }
                if elPicker == self.pickerMuns{
                    elFrame.origin.y = CGRectGetMaxY(self.txtMunicipio.frame)
                }
                if elPicker == self.pickerCols{
                    elFrame.origin.y = CGRectGetMaxY(self.txtColonia.frame)
                }
                
                
                
                
                
                
                
                elPicker.hidden = false
            }else{
                //bajarlo que aparezca fuera de la pantalla
                elFrame.origin.y = CGRectGetMaxY(self.view.frame)
            }
            elPicker.frame = elFrame
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.txtNombres.delegate = self
        self.txtApellidos.delegate = self
        self.txtFechaNac.delegate = self
        self.txtCalleNo.delegate = self
        self.txtColonia.delegate = self
        self.txtEdo.delegate = self
        self.txtMunicipio.delegate = self
        self.dtePckFechaNac.hidden = true
        
        //para que no haga crash, porque va a llamar a los arreglos
        self.pickerEstados.delegate = self
        self.estados = NSArray()
        
        
         //self.estados = ["municipio1", "municipio2", "municipio3"]
        
        
        //self.municipios = NSArray()
        
        self.pickerMuns.delegate = self
        self.municipios = ["municipio1", "municipio2", "municipio3"]
        
        self.pickerCols.delegate = self
        //self.colonias = NSArray()
        self.colonias = ["col1", "col2", "col3"]
        
        //TODO: REVISAR SI ESTE EL EL MEJOR MOMENTO PARA CARGAR EL WEB SERVICE
        self.consultaEstados()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        self.ocultaPickers()
        

    }
    
    func ocultaPickers(){
        var unFrame:CGRect
        
        unFrame = self.dtePckFechaNac.frame
        self.dtePckFechaNac.frame = CGRectMake(unFrame.origin.x, CGRectGetMaxY(self.view.frame), unFrame.size.width, unFrame.size.height)
        self.dtePckFechaNac.hidden = true
        
        var edoFrame:CGRect
        edoFrame = self.pickerEstados.frame
        self.pickerEstados.frame = CGRectMake(edoFrame.origin.x, CGRectGetMaxY(self.view.frame), edoFrame.size.width, edoFrame.size.height)
        self.pickerEstados.hidden = true
        
        var munFrame:CGRect
        munFrame = self.pickerMuns.frame
        self.pickerMuns.frame = CGRectMake(munFrame.origin.x, CGRectGetMaxY(self.view.frame), munFrame.size.width, munFrame.size.height)
        self.pickerMuns.hidden = true
        
        var colFrame:CGRect
        colFrame = self.pickerCols.frame
        self.pickerCols.frame = CGRectMake(colFrame.origin.x, CGRectGetMaxY(self.view.frame), colFrame.size.width, colFrame.size.height)
        self.pickerCols.hidden = true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func consultaEstados(){
        let urlString = "http://edg3.mx/webservicessepomex/WMRegresaEstados.php"
        let laURL = NSURL(string: urlString)!
        let elRequest = NSURLRequest(URL: laURL)
        self.datosRecibidos = NSMutableData(capacity: 0)
        self.conexion = NSURLConnection(request: elRequest, delegate: self)
        if self.conexion == nil{
            self.datosRecibidos = nil
            self.conexion = nil
            print("No se puede accesder a los edos")
        }

    }
    
    func connection(connection: NSURLConnection, didFailWithError error: NSError){
        self.datosRecibidos = nil
        self.conexion = nil
        print("error del server")
        
    }
    
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse){
        //YA LOGRO LA CONEXION, PREPARANDO PARA RECIBIR DATOS
        self.datosRecibidos?.length = 0
    }
    
    func connection (connection: NSURLConnection, didReceiveData data: NSData){
        //SE RECIBIO PAQUETE DE DATOS. GUARDARLO CON LOS DEMAS
        self.datosRecibidos?.appendData(data)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection) {
        do{
            let arregloRecibido = try NSJSONSerialization.JSONObjectWithData(self.datosRecibidos!, options: .AllowFragments) as! NSArray
            
            self.estados = arregloRecibido
            self.pickerEstados.reloadAllComponents()
        }
        catch{
            print("Error al recibir webservice de Estados")
        }
    }
}
