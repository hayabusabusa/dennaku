//
//  CaluculatiorViewCell.swift
//  dentakuApp
//
//  Created by Shunya Yamada on 2020/09/06.
//  Copyright © 2020 Masato.achiwa. All rights reserved.
//

import UIKit

class CaluculatiorViewCell: UICollectionViewCell{
        
    let numberLabel: UILabel = {
            let label = UILabel()
            label.textColor = .white
            label.text = "1"
            label.textAlignment = .center
            label.font = .boldSystemFont(ofSize: 32)
            label.backgroundColor = .black
            label.clipsToBounds = true  //有効で丸になる
            return label
    }()
        
    override init(frame: CGRect){
        super.init(frame: frame)
        
        addSubview(numberLabel)//ラベルの追加
        //backgroundColor = .black
        numberLabel.frame.size = self.frame.size   //セルの大きさと同じ大きさ
        numberLabel.layer.cornerRadius = self.frame.height / 9
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
