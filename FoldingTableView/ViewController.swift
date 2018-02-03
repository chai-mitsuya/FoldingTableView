//
//  ViewController.swift
//  FoldingTableView
//
//  Created by Mitsuya-Daisa on 2018/01/27.
//  Copyright © 2018年 mitsuya-daisa. All rights reserved.
//

import UIKit

class ViewController: UIViewController,  UITableViewDelegate,UITableViewDataSource {

    // テーブルビュー
    @IBOutlet weak var myTableView: UITableView!
    
    // 折りたたみフラグ
    var foldingFlg1 = false
    var foldingFlg2 = false
    var foldingFlg3 = false

    // 配列
    var items1: NSMutableArray = ["ねずみ", "うし", "とら", "うさぎ", "りゅう"]
    var items2: NSMutableArray = ["へび", "うま","ひつじ","さる","とり","いぬ","いのしし","ねこ","しまうま"]
    var items3: NSMutableArray = ["やぎ","くま","しろくま","こぶら","ごりら","ぶた","ぞう","おおかみ"]
    var section1: Dictionary = [String:NSMutableArray]()
    var section2: Dictionary = [String:NSMutableArray]()
    var section3: Dictionary = [String:NSMutableArray]()
    var sections: Array = [Dictionary<String,NSMutableArray>]()
    
    // MARK: メソッド
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // テーブルビューの背景色を設定する。
        let bgColor = UIColor.green.withAlphaComponent(0.1)
        self.myTableView.backgroundColor = bgColor
        self.myTableView.backgroundView?.backgroundColor = bgColor
        
        // セクションのタイトルとデータの配列を設定する。
        section1 = ["セクション１":items1]
        section2 = ["セクション２":items2]
        section3 = ["セクション３":items3]
        
        // セクションを配列に設定する。
        sections.append(section1)
        sections.append(section2)
        sections.append(section3)
        
        // デリゲートを設定する。
        myTableView.delegate = self
        myTableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: テーブルビューのデリゲードメソッド
    // UIViewを返す。
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        // セクションのヘッダとなるビューを作成する。
        let myView: UIView = UIView()
        let label:UILabel = UILabel()
        for (key) in sections[section].keys
        {
            label.text = key
        }
        label.sizeToFit()
        label.textColor = UIColor.black
        myView.addSubview(label)
        myView.backgroundColor = UIColor.green
        
        // セクションのビューに対応する番号を設定する。
        myView.tag = section
        // セクションのビューにタップジェスチャーを設定する。
        myView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapHeader(gestureRecognizer:))))
        
        return myView
    }
    
    // セクションの数を返す。
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    // セルの数を返す。
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // テーブルビューのセル数の設定する。
        switch section {
        case 0:
            return foldingFlg1 ? 0 : self.items1.count
        case 1:
            return foldingFlg2 ? 0 : self.items2.count
        case 2:
            return foldingFlg3 ? 0 : self.items3.count
        default:
            return 0
        }
    }
    
    // セルを返す。
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルにテキストを出力する。
        let cell = tableView.dequeueReusableCell(withIdentifier:  "cell", for:indexPath as IndexPath)
        for (value) in sections[indexPath.section].values
        {
            cell.textLabel?.text = value[indexPath.row] as? String
        }
        
        return cell
    }
    
    // テーブルビューをスワイプしてデータを削除する。
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteButton: UITableViewRowAction = UITableViewRowAction(style: .normal, title: "削除") { (action, index) -> Void in
            for (value) in self.sections[indexPath.section].values
            {
                value.removeObject(at: indexPath.row)
            }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        deleteButton.backgroundColor = UIColor.red
        
        return [deleteButton]
    }
    
    // 選択したセルの値を出力する。
    func tableView(_ table: UITableView,didSelectRowAt indexPath: IndexPath) {
        // タップしたセルのテキストを取得する。
        var selectText = ""
        for (value) in self.sections[indexPath.section].values
        {
            selectText = value[indexPath.row] as! String
        }
        
        // アラートを生成する。
        let alert: UIAlertController = UIAlertController(title: selectText, message: "\(selectText)を選択しました。", preferredStyle:  UIAlertControllerStyle.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:nil)
        alert.addAction(defaultAction)
        
        // アラートを表示する。
        present(alert, animated: true, completion: nil)
    }

    // MARK: アクション
    @objc func tapHeader(gestureRecognizer: UITapGestureRecognizer) {
        // タップされたセクションを取得する。
        guard let section = gestureRecognizer.view?.tag as Int! else {
            return
        }
        
        // フラグを設定する。
        switch section {
        case 0:
            foldingFlg1 = foldingFlg1 ? false : true
        case 1:
            foldingFlg2 = foldingFlg2 ? false : true
        case 2:
            foldingFlg3 = foldingFlg3 ? false : true
        default:
            break
        }
        
        // タップされたセクションを再読込する。
        myTableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .none)
    }
    
}

