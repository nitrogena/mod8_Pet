//
//  ConnectionManager.swift
//  practica1
//
//  Created by Invitado on 21/10/16.
//  Copyright © 2016 Invitado. All rights reserved.
//

import Foundation

//SE VA A VERIFICAR LA CONEXION A INTERNET Y
//EL TIPO DE CONEXION

import SystemConfiguration

public class ConnectionManager{
    
    //es un metodo estatico
    /*class func hayConexion() -> Bool {
    
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, UnsafePointer($0))
        }
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        //EN EL SIMULADOR DE LA COMPU SIEMBRE SE VA A TENER UNA CONEXION POR ESO 
        //SE DEBE PROBAR CON EL DISPOSITIVO
        //LA ENUMERACION .Reachable da true cuando esta conectado
        
        //SI NO IMPORTA EL TIPO DE CONEXION
        let isReachable = flags == .Reachable
        
        if isReachable{
            let isWifi = flags == .IsWWAN
            
        }
        
        //si quiero saber si esta conectado por wifi, 
        //SI DEVUELVE FALSE ESO NO SIGNIFICA QUE NO TENGA INTERNET
        //let isReachable = flags == .IsWWAN
        
        let needsConnection = flags == .ConnectionRequired
        return isReachable && !needsConnection
        

    }*/
    
    static func hayConexion() -> Bool {
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, UnsafePointer($0))
        }
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        let isReachable = flags == .Reachable
        let needsConnection = flags == .ConnectionRequired
        return isReachable && !needsConnection
    }
    
    static func esConexionWiFi () -> Bool {
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, UnsafePointer($0))
        }
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        let isReachable = flags == .Reachable
        if isReachable {
            let isWiFi = flags == .IsWWAN
            let needsConnection = flags == .ConnectionRequired
            return isWiFi && !needsConnection
        }
        return false
    }

    
    
}