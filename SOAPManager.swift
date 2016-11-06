//
//  SOAPManager.swift
//  practica1
//
//  Created by Invitado on 21/10/16.
//  Copyright © 2016 Invitado. All rights reserved.
//

import Foundation

//un padre seguido de un protocolo

public class SOAPManager:NSObject, NSURLConnectionDelegate, NSXMLParserDelegate{

    private let NODO_RESULTADOS:String = "NewDataSet"
    private let NODO_MUNICIPIO:String = "ReturnDataSet"

    private var municipios:NSMutableArray?
    private var municipio:NSMutableDictionary?
    private var guardaResultados:Bool = false
    private var esMunicipio:Bool = false
    private var nombreCampo:String?

    
    
    static let instance:SOAPManager = SOAPManager()
    
    private let wsURL = "http://edg3.mx/webservicessepomex/sepomex.asmx"
    
    private var datosRecibidos:NSMutableData?
    private var conexion:NSURLConnection?
    
    public func consultaMunicipios (estado:String){
        let soapMun1 = "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body><WMRegresaMunicipios xmlns=\"http://tempuri.org/\"><c_estado>"
        
        let soapMun2 = "</c_estado></WMRegresaMunicipios></soap:Body></soap:Envelope>"

        
        let soapMessage = soapMun1 + estado + soapMun2
        
        let laURL = NSURL(string: self.wsURL)!
        let elRequest = NSMutableURLRequest(URL: laURL)
        //Configurar el request
        elRequest.HTTPMethod = "POST"
        elRequest.setValue("text/xml", forHTTPHeaderField: "Content-Type")
        let longitudMensaje = "\(soapMessage.characters.count)"
        elRequest.setValue(longitudMensaje, forHTTPHeaderField: "Content-Length")
        
        //lo tenia David
        elRequest.setValue("http://tempuri.org/WMRegresaMunicipios", forHTTPHeaderField:"SOAPAction")
        
        elRequest.HTTPBody = soapMessage.dataUsingEncoding(NSUTF8StringEncoding)
            self.datosRecibidos = NSMutableData(capacity: 0)
        self.conexion = NSURLConnection(request: elRequest, delegate: self, startImmediately: false)
        
        if self.conexion == nil{
            self.datosRecibidos = nil
            self.conexion = nil
            print ("no se puede acceder al ws estados")
        }
            /* YA NO LO TENIA DAVID
        else{
            self.conexion!.scheduleInRunLoop(NSRunLoop.mainRunLoop(), forMode:NSURLConnection){
                self.conexion!.start()
            }
        }
        */
        
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
        //soap response es un xml, implementar parseo
        let responseSTR = NSString(data: self.datosRecibidos!, encoding: NSUTF8StringEncoding)
        print (responseSTR)
        
        let xmlParser = NSXMLParser(data: self.datosRecibidos!)
        xmlParser.delegate = self
        xmlParser.shouldResolveExternalEntities = true
        xmlParser.parse()
        
    }
    
    
    
   
    public func parser(parser: NSXMLParser, didStartElement elementName, namespaceURI: String?, qualifiedName qName: String?, attribute attributeDict: [String: String]){
        if elementName == NODO_RESULTADOS{
            guardaResultados = true
        }
        if guardaResultados && elementName == NODO_MUNICIPIO {
            self.municipio = NSMutableDictionary()
            esMunicipio = true
        }
        nombreCampo = elementName
    }

    
    public func parser(parser:NSXMLParser, foundCharacters string: String){
        if esMunicipio{
            municipio!.setObject(string, forKey: nombreCampo!)
        }
    }
    


    public func parser(parser:NSXMLParser, didEndElement elementName: , namespaceURI: String?, qualifiedName qName: String?){
        
        
        if elementName == NODO_MUNICIPIO{
            if municipios == nil{
                municipios = NSMutableArray()
            }
            municipios!.addObject(municipio!)
            esMunicipio = false
        }

        
    }
    
    public func parserDidEndDocument(parser: NSXMLParser) {
        print ("resultado, parseado: \(municipios!.description)")
    }
}




