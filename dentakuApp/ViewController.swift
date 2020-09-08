//
//  ViewController.swift
//  dentakuApp
//
//  Created by アプリ開発 on 2020/07/25.
//  Copyright © 2020 Masato.achiwa. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - IBOutlet
        
    @IBOutlet var calculatiorCollectionView: UICollectionView!
    @IBOutlet var formulaHiddenLabele: UILabel!
    @IBOutlet var formulaLabel: UILabel!
    @IBOutlet var symbolLabel: UILabel!
    @IBOutlet var showLabel: UILabel!
    @IBOutlet var hiddenLabel: UILabel!
    @IBOutlet var caluculateHegihtConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    
    var culSymbol = ""
    var firstNumber = ""
    var secondNumber = ""
    var a: Double = 0
    var calculateStatus: CalculateStatus = .none
    var result = ""
    var aaa: String = ""
    var value1: NSDecimalNumber  = 0
    var value2: NSDecimalNumber = 0
    var value3: NSDecimalNumber = 0
    var shoCount: Int  = 0
    
    var numberArray = [String]()
    var firstNumberrr = "0"
    var secondNumberrr = "0"
    var resultNumber = 0
    var last : String = ""
    
    // NOTE: 連続で数字が入力された場合の一つ前に入力された数字を保持する変数.
    // ex) 96 の場合は 9 が入る.
    var previousNumberString: String? {
        didSet {
            print("[DEBUG] previous number = \(previousNumberString ?? "nil")")
        }
    }
    
    let numbers = [
            ["C", "%", "S", "De"],
            ["7", "8", "9", "+"],
            ["4", "5", "6", "-"],
            ["1", "2", "3", "×"],
            ["0", ".", "=", "÷"],
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureLabels()
    }
    
    func clear() {
        firstNumber = ""
        secondNumber = ""
        showLabel.text = ""
        calculateStatus = .none
        formulaLabel.text = "0"
        hiddenLabel.text = ""
        self.shoCount = 0
    }
}

extension ViewController {
    
    private func configureCollectionView() {
        calculatiorCollectionView.delegate = self
        calculatiorCollectionView.dataSource = self
        calculatiorCollectionView.register(CaluculatiorViewCell.self,forCellWithReuseIdentifier: "callId")
        //caluculateHegihtConstraint.constant = view.frame.width * 1.4
        caluculateHegihtConstraint.constant = view.frame.height * 0.6
        calculatiorCollectionView.backgroundColor = .clear
        calculatiorCollectionView.contentInset = .init(top: 0,left: 14,bottom: 0, right: 14)
    }
    
    private func configureLabels() {
        //showLabel.isHidden = true
        showLabel.text = "0"
        formulaLabel.text = "0"
        symbolLabel.text = ""
        hiddenLabel.text = ""
        
        self.shoCount = 0
    }
}

extension ViewController {
    
    func formulaControl(send: String) {
        guard let nowFormula = formulaLabel.text else {
            return
        }
        
        guard let showNum = showLabel.text else {
            return
        }
        
        guard let nowCulc = symbolLabel.text else {
            return
        }
        
        switch nowCulc {
        case "+","-","×","÷","=":
            formulaHiddenLabele.text = String(nowFormula[nowFormula.startIndex ..< nowFormula.index(before: nowFormula.endIndex)]) + send
            
            //記号を押したら、formulaLabelのテキストの最初の文字から最後の文字まで(記号)から一文字戻してsendを追加
            if nowFormula.hasSuffix("+") {
                formulaLabel.text = String(nowFormula[nowFormula.startIndex ..< nowFormula.index(before: nowFormula.endIndex)]) + send
            } else if nowFormula.hasSuffix("-") {
                formulaLabel.text = String(nowFormula[nowFormula.startIndex ..< nowFormula.index(before: nowFormula.endIndex)]) + send
            } else if nowFormula.hasSuffix("×") {
                formulaLabel.text = String(nowFormula[nowFormula.startIndex ..< nowFormula.index(before: nowFormula.endIndex)]) + send
            } else if nowFormula.hasSuffix("÷") {
                formulaLabel.text = String(nowFormula[nowFormula.startIndex ..< nowFormula.index(before: nowFormula.endIndex)]) + send
            } else if nowFormula.hasSuffix("=") {
                formulaLabel.text = String(nowFormula[nowFormula.startIndex ..< nowFormula.index(before: nowFormula.endIndex)]) + send
            } else {
                formulaLabel.text = nowFormula  + send
            }
        default:
            //culc()
            
            formulaLabel.text = nowFormula  + send
            formulaHiddenLabele.text = nowFormula  + send
        }
    }
    
    func arrayCulc() {
        guard let symbol = symbolLabel.text else{
            return
        }
    
        let arrayCount = numberArray.count
        
        if arrayCount >= 3 && arrayCount < 5 {
            print("firstNumberrrとsecondNumbeerは\(firstNumberrr)と\(secondNumberrr)")
           
            switch symbol {
            case "+":
                let aNumber: Int = Int(firstNumberrr) ?? 0
                let bNumber: Int = Int(secondNumberrr) ?? 0
                self.resultNumber =  aNumber + bNumber
                
                print("resultNumberは\(self.resultNumber)")
                hiddenLabel.text = String(self.resultNumber)
            default:
                print("デフォルト")
            }
        }
    
        if arrayCount >= 5 {
            print("firstNumberrrとsecondNumbeerは\(firstNumberrr)と\(secondNumberrr)")
            let aNumber = hiddenLabel.text
            
            print("aNumberとsecondNumbeerは\(aNumber)と\(secondNumberrr)")
            
            switch symbol {
            case "+":
                // NOTE: 配列が 5 以上の長さ( 2回目の計算に入った )
                // この場合 hiddenLabel に計算結果が入り、それを取り出すが、
                // 2桁の場合前の計算結果をそのままにしたまま2桁入力後の数字を計算してしまうので良くない.
                // 足算の場合は一つ前に入力された数字を引いて戻す処理が必要になる.
                
                // NOTE: 今までの計算結果
                let aNumber: Int = Int(hiddenLabel.text ?? "0") ?? 0
                // NOTE: 配列に入っている最後の数字
                let bNumber: Int = Int(secondNumberrr) ?? 0
                
                // NOTE: `previousNumberString` があれば足算なので、マイナスして結果を整える.
                // しかしこの場合全ての演算子において逆の操作( 乗算の場合は除算など )をする処理を書かなければならない.
                if let previousNumberString = previousNumberString,
                    let previousNumber = Int(previousNumberString) {
                    self.resultNumber = aNumber - previousNumber + bNumber
                } else {
                    self.resultNumber = aNumber + bNumber
                }
                
                print("resultNumberは\(self.resultNumber)")
                
                hiddenLabel.text = String(self.resultNumber)
            default:
                print("デフォルト")
            }
        }
    }
}

extension ViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numbers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numbers[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "callId", for: indexPath) as! CaluculatiorViewCell  //表示するセルを登録(先程命名した"Cell")
        //cell.backgroundColor = .red
        cell.numberLabel.text = numbers[indexPath.section][indexPath.row]
        numbers[indexPath.section][indexPath.row].forEach{ (numberString) in  //numberStringは変数　forEacheそれぞれのという意味
            if "0"..."9" ~= numberString || numberString.description == "." {
                cell.numberLabel.backgroundColor = .black
            }
        }
        return cell
    }
}

extension ViewController: UICollectionViewDelegate {
    
    //セルをタップした時のメソッド
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let number = numbers[indexPath.section][indexPath.row]  //ラベルの振り分け
        // print(number)
                    
        guard let showNum = showLabel.text else {
            return
        }
        
        let senderNum : String = number //タップされたセルの値の取得
                    
        switch senderNum {
        case "0"..."9": //０から９のセルをタップしたら
            guard let nowFormula = formulaLabel.text else {
                return
            }
                           
            if symbolLabel.text != "" {      //プラス等があったら¥
                showLabel.text = showNum + senderNum
                //symbolLabel.text = ""
                showLabel.isHidden = false
                
                guard let showNum = showLabel.text else {
                    return
                }
                
                guard let last = numberArray.last else {
                    return
                }
                
                print(last)
                
                switch last {
                case "+", "-", "×", "÷": //配列の最後が記号だったら（３＋５）の５を入力した場合
                    numberArray.append(senderNum)
                    
                    print(numberArray)
                    
                    secondNumberrr = numberArray.last ?? "0"
                    print("secondNumberrrは\(secondNumberrr)")

                    arrayCulc()
                default: //配列の最後が数字だったら(数字をつづけて入力した場合）
                    // NOTE: 配列の最後に残っている一つ前に入力された数字を保持して記憶する.
                    previousNumberString = last
                        
                    numberArray.removeLast()
                    numberArray.append(showNum)

                    secondNumberrr = numberArray.last ?? "0"

                    arrayCulc()
                    
                    print("最後の数字は\(last)")
                    print(numberArray)
                    print("secondNumberrrは\(secondNumberrr)")
                    print("aaaaa")
                }
            } else if showNum == "0" { //ラベルが０だったら
                showLabel.text = senderNum
                self.shoCount = showNum.count
                
                print("shoCount\(shoCount)")
                
                showLabel.isHidden = false
                formulaLabel.text = senderNum
                
                let hidden = showLabel.text
                hiddenLabel.text = hidden
                            
                numberArray.append(senderNum)
                
                print(numberArray)
                
                firstNumberrr = numberArray[0]
                
                print("firstNumberrrdは\(firstNumberrr)")
            } else {  //0じゃなくて数字が入力されたら
                showLabel.text = showNum + senderNum
                formulaLabel.text = showNum + senderNum
                showLabel.isHidden = false
                
                guard let last = numberArray.last else {
                    return
                }
                
                print("最後の数字は\(last)")

                numberArray.removeLast()
                numberArray.append(showNum + senderNum)
                
                print(numberArray)
                firstNumberrr = numberArray[0]
                print("firstNumberrrdは\(firstNumberrr)")
                
                guard let showNum = showLabel.text else{ //
                    return
                }
                            
                self.shoCount = showNum.count
                
                print("shoCount\(shoCount)")
            }
            
            if nowFormula != "0" {
                formulaLabel.text = nowFormula + number
            }
                           
            if nowFormula.contains("=") {
                formulaLabel.text = senderNum
                showLabel.text = senderNum
                hiddenLabel.text = ""
            }
        case "+", "-", "×", "÷":
            guard let last = numberArray.last else {
                return
            }
            
            // NOTE: 演算子が入力されたら `previousNumberString` をリセット
            previousNumberString = nil
            
            showLabel.isHidden = false
            showLabel.text = ""
            
            let senderdCulc = number

            switch last {
            case "+", "-", "×", "÷":
                numberArray.removeLast()
                numberArray.append(senderdCulc)
                print(numberArray)
            default:
                numberArray.append(senderdCulc)
                print("最後の数字は\(last)")
                print(numberArray)

            }
            formulaControl(send: senderdCulc) //記号を引数にしたメソッド
            //let hidden = showLabel.text
            //hiddenLabel.text = hidden
            symbolLabel.text = number
        case "C":
            showLabel.text = "0"
            formulaLabel.text = "0"
            symbolLabel.text = ""
            self.result = ""
            //hiddenLabel.text = self.result
            formulaHiddenLabele.text = ""
            value1 = 0
            numberArray.removeAll()
        case "De":
            guard let showNum = showLabel.text else{
                return
            }
            
            guard let nowformula = formulaLabel.text else{
                return
            }
            
            self.shoCount = showNum.count

            print("shoCount\(shoCount)")
                         
            if nowformula.hasSuffix("+") ||
                nowformula.hasSuffix("-") ||
                nowformula.hasSuffix("×") ||
                nowformula.hasSuffix("÷") {
                return
            } else {
                if shoCount >= 1 {
                    let a =  showNum.dropLast()
                    showLabel.text = String(a)
                    
                    let b = nowformula.dropLast()
                    formulaLabel.text = String(b)
                    shoCount = shoCount - 1
                    print("ループ中")
                }
            }
        case "=":
            guard let nowFormula1 = formulaLabel.text else {
                return
            }
            
            if nowFormula1.contains("=") {
                formulaLabel.text = aaa
            } else if nowFormula1.hasSuffix("+") ||
                nowFormula1.hasSuffix("-") ||
                nowFormula1.hasSuffix("×") ||
                nowFormula1.hasSuffix("÷") {
                return
            } else if nowFormula1.contains("+") ||
                nowFormula1.contains("-") ||
                nowFormula1.contains("×") ||
                nowFormula1.contains("÷") {
                symbolLabel.text = ""
                
                //culc()
                
                guard let nowFormula = formulaLabel.text else{
                    return
                }
                
                formulaLabel.text = nowFormula + "=" + self.result
                self.aaa = formulaLabel.text ?? ""
                //hiddenLabel.text = self.result
            }
        default:
            print("")
        }
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout{
    
    //ヘッダーの大きさ
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: collectionView.frame.width, height: 10)
    }
        
    //cellの大きさ
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = ((collectionView.frame.width - 10) - 14 * 5) / 4
        let height = ((collectionView.frame.width - 10) - 14 * 5) / 5
        return .init(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 14
    }
}
