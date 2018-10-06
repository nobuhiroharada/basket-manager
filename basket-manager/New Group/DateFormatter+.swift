//
//  DateFormatter.swift
//  basket-manager
//
//  Created by Nobuhiro Harada on 2018/10/05.
//  Copyright © 2018年 Nobuhiro Harada. All rights reserved.
//
import Foundation

private let formatter: DateFormatter = {
    let f: DateFormatter = DateFormatter()
    f.dateStyle = .medium
    f.timeStyle = .none
    f.doesRelativeDateFormatting = false
    f.locale = Locale(identifier: "ja_JP")
    return f
}()

extension DateFormatter {
    
    func getFormat() -> DateFormatter{
        
        return formatter
    }
}
