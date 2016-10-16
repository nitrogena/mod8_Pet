//
//  DBManager.swift
//  practica1
//
//  Created by Invitado on 14/10/16.
//  Copyright © 2016 Invitado. All rights reserved.
//

import Foundation

import CoreData

class DBManager{
    
    //SE HACE UN SINGLETON con un static, VER APUNTES DEL 01-10-2016
    static let instance = DBManager()
    
    //ocurre en la precarga, porque todos se cargan,
    
    
    
    //STATIC PARA NO INSTANCIARLA, NO LA QUEREMOS INSTANCIAR CADA QUE
    //LA OCUPEMOS
    //ANGEL: SI HAY DOS O MAS ARGUMENTOS, DEL SEGUNDO EN ADELANTE, EL IDENTIFICADOR
    //DEL PARAMETRO SE DEBE USAR COMO ETIQUETA AL INVOCAR EL METODO
    
    //static func encuentraTodosLos(nombreEntidad:String, ordenadosPor:String)
    
    
    func encuentraTodosLos(nombreEntidad:String, filtradosPor:NSPredicate)-> NSArray{
        //PARA TRABAJAR CON QUERIES
        let elQuery:NSFetchRequest = NSFetchRequest()
        let laEntidad:NSEntityDescription = NSEntityDescription.entityForName(nombreEntidad, inManagedObjectContext: self.managedObjectContext!)!
        elQuery.entity = laEntidad
        elQuery.predicate = filtradosPor
        do{//try-catch al estilo swift...
            let result = try self.managedObjectContext!.executeFetchRequest(elQuery)
            return result as! NSArray
            //ES UN CAST FORZOSO EL DE ARRIBA
            
            
        }
        catch{
            print("Error al ejecutar request")
            return NSArray()
        }
    }
    
    
    
    //SI NO QUIERO QUE APAREZCAN LOS IDENTIFICADORES COMO ETIQUETAS,
    //SE AGREGAN EL GUION BAJO ESPACIO ANTES DE CADA IDENTIFICADOR
    func encuentraTodosLos(nombreEntidad:String, _ ordenadosPor:String)-> NSArray{
        
        //PARA TRABAJAR CON QUERIES
        let elQuery:NSFetchRequest = NSFetchRequest()
        let laEntidad:NSEntityDescription = NSEntityDescription.entityForName(nombreEntidad, inManagedObjectContext: self.managedObjectContext!)!
        elQuery.entity = laEntidad
        do{
            let result = try self.managedObjectContext!.executeFetchRequest(elQuery)
            return result as! NSArray
            //ES UN CAST FORZOSO EL DE ARRIBA
            
            
        }
        catch{
            print("Error al ejecutar request")
            return NSArray()
        }
        
        
    }
    
    /*se instancia un objeto cuando necesitas espacio en la memoria para usarlo*/
    
    //OBJETOS INDISPENSABLES A USAR CON EL SQLITE
    
    //SE INICIALIZA HASTA QUE ALGUIEN LA PIDA
    lazy var managedObjectContext:NSManagedObjectContext? = {
        let persistence = self.persistentStore
        if persistence == nil{
            return nil
        }
        //ESPERA VALOR DE UNA ENUMERACION POR LO QUE SE PONE EL PUNTO Y ALGO
        var moc = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        moc.persistentStoreCoordinator = persistence
        return moc
    }() //SE INICIALIZA CON LO QUE RESULTE DEL CODIGO ANTERIOR
    lazy var managedObjectModel:NSManagedObjectModel? = {
        let modelURL = NSBundle.mainBundle().URLForResource("PetCens", withExtension: "momd")
        var model = NSManagedObjectModel(contentsOfURL: modelURL!)
        //LOS ARCHIVOS QUE SE AGREGAN AL PROY, EN TIMPO DE DISEÑO, QUEDAN UBICADOS EN "RESOURCES" Y SON
        //DE SOLO LECTURA
        
        
        /* - en var model colocar el breakpoint
         */
        
        return model
    }()
    lazy var persistentStore:NSPersistentStoreCoordinator? = {
        let model = self.managedObjectModel
        if model == nil{
            return nil
        }
        let persist = NSPersistentStoreCoordinator(managedObjectModel:model!)
        //persist
        //ENCONTRAR LA UBICACION DE LA BD
        let urlDeLaBD = self.directorioDocuments.URLByAppendingPathComponent("PetCens.sqlite")
        do{
            //hacemos un diccionario, que son como arreglos asociativos de php
            let opcionesDePersistencia = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
            try persist.addPersistentStoreWithType(NSSQLiteStoreType, configuration:nil, URL:urlDeLaBD, options:opcionesDePersistencia)
        }
        catch{
            print ("no se puede abrir la base de datos")
            abort() //terminar la ejecucion del app
        }
        return persist
    }()
    lazy var directorioDocuments:NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        //return urls[0]
        //DEVUELVE EL PRIMErO
        return urls[urls.count-1]
        
        //OBJETO UNICO COMPARTIDO POR ...
    }()
    
    
    
    
}