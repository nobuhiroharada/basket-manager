//
//  SettingViewController.swift
//  basket-manager
//
//  Created by 原田順啓 on 2020/05/18.
//  Copyright © 2020 Nobuhiro Harada. All rights reserved.
//

import UIKit
 
final class SettingViewController: UIViewController {
    
    private let tableSections: Array = [" ", " ", " ", " "]
    private let tableRowTitles: Array = [
        ["setting_auto_buzzer".localized],
        ["setting_sync_shotclock_gametime".localized],
        ["setting_reset".localized],
        ["app_version".localized]
    ]
    private let tableCellId: String = "Cell"
    
    private var tableView: UITableView!
    
    public var shotClockView: ShotClockView!
    public var gameTimeView: GameTimeView!
    public var scoreView: ScoreView!
    
    private var scrollView: UIScrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .black
        
        let viewWidth = self.view.frame.width
        let viewHeight = self.view.frame.height
        
        var closeBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(close(_:)))
        
        if #available(iOS 13.0, *) {
            closeBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.close, target: self, action: #selector(close(_:)))
        }
        
        self.navigationItem.title = "setting_title".localized
        self.navigationItem.leftBarButtonItem = closeBtn
        
        var barHeight: CGFloat = 0
        if #available(iOS 13.0, *) {
            barHeight = CGFloat(view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0)
        }
        
        scrollView.frame = CGRect(x: 0, y: barHeight, width: viewWidth, height: viewHeight)
        scrollView.contentSize = CGSize(width: viewWidth, height: viewHeight*1.2)
        if #available(iOS 13.0, *) {
            scrollView.backgroundColor = .systemBackground
        } else {
            scrollView.backgroundColor = .gray
        }

        scrollView.isScrollEnabled = true
        self.view.addSubview(scrollView)
        
        tableView = UITableView(frame:
            CGRect(x: 0,
                   y: 0,
                   width: viewWidth,
                   height: viewHeight))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: tableCellId)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = true
        
        self.scrollView.addSubview(tableView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(orientationDidChange(_:)), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    @objc func close(_ sender: UIButton) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func orientationDidChange(_ notification: NSNotification) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - TableView Delegate, Datasource
extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableRowTitles[section].count
    }
    
     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableSections[section]
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: tableCellId, for: indexPath)
        
        switch indexPath.section {
        case 0: // セクション 1
            switch indexPath.row {
            case 0: // 自動ブザー
                let switchView = UISwitch(frame: .zero)

                if userdefaults.bool(forKey: BUZEER_AUTO_BEEP) {
                    switchView.setOn(true, animated: true)
                } else {
                    switchView.setOn(false, animated: true)
                }

                switchView.tag = indexPath.row // for detect which row switch Changed
                switchView.addTarget(self, action: #selector(self.switchAutoBuzzer(_:)), for: .valueChanged)
                
                if UIDevice.current.userInterfaceIdiom == .phone {
                    cell.accessoryView = switchView
                } else {
                    switchView.center = CGPoint(x: self.view.frame.width - 50, y: cell.frame.height/2)
                    cell.contentView.addSubview(switchView)
                }
                
                cell.textLabel?.text = tableRowTitles[indexPath.section][indexPath.row]
                cell.selectionStyle = .none
                return cell
            default:
                break
            }
        case 1: // セクション 2
            switch indexPath.row {
            case 0: // ショットクロック、タイマー同期設定
                let switchView = UISwitch(frame: .zero)

                if userdefaults.bool(forKey: IS_SYNC_SHOTCLOCK_GAMETIME) {
                    switchView.setOn(true, animated: true)
                } else {
                    switchView.setOn(false, animated: true)
                }

                switchView.tag = indexPath.row
                switchView.addTarget(self, action: #selector(self.switchSyncShotClockGameTime(_:)), for: .valueChanged)
                
                if UIDevice.current.userInterfaceIdiom == .phone {
                    cell.accessoryView = switchView
                } else {
                    switchView.center = CGPoint(x: self.view.frame.width - 50, y: cell.frame.height/2)
                    cell.contentView.addSubview(switchView)
                }
                
                cell.textLabel?.text = tableRowTitles[indexPath.section][indexPath.row]
                cell.selectionStyle = .none
                return cell
            default:
                break
        }
        case 2: // セクション3
            switch indexPath.row { // リセット
            case 0:
                cell.textLabel?.text = tableRowTitles[indexPath.section][indexPath.row]
                cell.textLabel?.textColor = .systemBlue
                return cell
            default:
                break
            }
        case 3: // セクション4
            switch indexPath.row { // バージョン
            case 0:
                if cell.detailTextLabel == nil {
                    cell = UITableViewCell(style: .value1, reuseIdentifier: tableCellId)
                }
                cell.textLabel?.text = tableRowTitles[indexPath.section][indexPath.row]
                cell.selectionStyle = .none
                
                if UIDevice.current.userInterfaceIdiom == .phone {
                    cell.detailTextLabel?.text = (Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String) ?? "Unknown"
                } else {
                    let vesionLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
                    vesionLabel.center = CGPoint(x: self.view.frame.width - 50, y: cell.frame.height/2)
                    vesionLabel.textAlignment = .center
                    vesionLabel.text = (Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String) ?? "Unknown"
                    vesionLabel.textColor = .systemGray
                    cell.contentView.addSubview(vesionLabel)
                }
                
                return cell
            default:
                break
            }
        
        default:
            return UITableViewCell()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 && indexPath.row == 0 { // リセット
            self.shotClockView.reset()
            self.scoreView.reset()
            self.gameTimeView.reset()
            self.dismiss(animated: true, completion: nil)
        }
    }

    @objc func switchAutoBuzzer(_ sender : UISwitch!){
        if sender.isOn {
            userdefaults.set(true, forKey: BUZEER_AUTO_BEEP)
            shotClockView.autoBuzzerLabel.textColor = .white
            gameTimeView.autoBuzzerLabel.textColor = .white
        } else {
            userdefaults.set(false, forKey: BUZEER_AUTO_BEEP)
            shotClockView.autoBuzzerLabel.textColor = .black
            gameTimeView.autoBuzzerLabel.textColor = .black
        }
    }
    
    @objc func switchSyncShotClockGameTime(_ sender : UISwitch!){
        if sender.isOn {
            userdefaults.set(true, forKey: IS_SYNC_SHOTCLOCK_GAMETIME)
        } else {
            userdefaults.set(false, forKey: IS_SYNC_SHOTCLOCK_GAMETIME)
        }
    }
}
