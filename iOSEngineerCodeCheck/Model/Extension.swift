//
//  Extension.swift
//  iOSEngineerCodeCheck
//
//  Created by 佐藤駿樹 on 2021/11/12.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import Foundation

extension StringProtocol where Self: RangeReplaceableCollection {
    ///スペースを取り除き、新しい文を返す
    var removeWhitespacesAndNewlines: Self {
        filter { !$0.isNewline && !$0.isWhitespace }
    }
}
