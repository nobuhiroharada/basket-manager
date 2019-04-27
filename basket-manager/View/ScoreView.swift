//
//  ShotClockView.swift
//  basket-manager
//
//  Created by Nobuhiro Harada on 2019/04/06.
//  Copyright © 2019 Nobuhiro Harada. All rights reserved.
//

import UIKit

class ScoreView: UIView {
    
    // スコアA
    var scoreA: Int = 0
    var teamLabelA: TeamLabel
    var scoreLabelA: ScoreLabel
    var scoreMinusButtonA: ScoreSmallButton
    var scorePlusButtonA: ScoreSmallButton
    
    // スコアB
    var scoreB: Int = 0
    var teamLabelB: TeamLabel
    var scoreLabelB: ScoreLabel
    var scoreMinusButtonB: ScoreSmallButton
    var scorePlusButtonB: ScoreSmallButton
    
    override init(frame: CGRect) {
        teamLabelA = TeamLabel()
        teamLabelA.text = "HOME"
        
        teamLabelB = TeamLabel()
        teamLabelB.text = "GUEST"
        
        scoreLabelA = ScoreLabel()
        scoreLabelB = ScoreLabel()
        
        let upButtonImage = UIImage(named:"up-button")!
        let downButtonImage = UIImage(named:"down-button")!
        
        scoreMinusButtonA = ScoreSmallButton()
        scoreMinusButtonA.setImage(downButtonImage, for: .normal)
        
        scorePlusButtonA = ScoreSmallButton()
        scorePlusButtonA.setImage(upButtonImage, for: .normal)
        
        scoreMinusButtonB = ScoreSmallButton()
        scoreMinusButtonB.setImage(downButtonImage, for: .normal)
        
        scorePlusButtonB = ScoreSmallButton()
        scorePlusButtonB.setImage(upButtonImage, for: .normal)
        
        super.init(frame: frame)
        
        self.addSubview(teamLabelA)
        self.addSubview(teamLabelB)
        self.addSubview(scoreLabelA)
        self.addSubview(scoreLabelB)
        self.addSubview(scoreMinusButtonA)
        self.addSubview(scorePlusButtonA)
        self.addSubview(scoreMinusButtonB)
        self.addSubview(scorePlusButtonB)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func checkOrientation4Pad() {
        switch UIApplication.shared.statusBarOrientation {
        case .portrait, .portraitUpsideDown:
            initPadAttrPortrait()
            
        case .landscapeLeft, .landscapeRight:
            initPadAttrLandscape()
            
        default:
            initPadAttrPortrait()
        }
    }
    
    func portrait(frame: CGRect) {
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            checkOrientation4Pad()
        }
        
        let teamNameY = frame.height*(1/8)
        teamLabelA.center = CGPoint(x: frame.width*(1/4),
                                    y: teamNameY)
        
        teamLabelB.center = CGPoint(x: frame.width*(3/4),
                                    y: teamNameY)
        
        let scoreLabelY = frame.height*(1/2)
        
        scoreLabelA.center = CGPoint(x: frame.width*(1/4),
                                     y: scoreLabelY)
        
        scoreLabelB.center = CGPoint(x: frame.width*(3/4),
                                     y: scoreLabelY)
        
        let scoreButtonY = frame.height*(7/8)
        
        scoreMinusButtonA.center = CGPoint(x: frame.width*(1/8), y: scoreButtonY)
        
        scorePlusButtonA.center = CGPoint(x: frame.width*(3/8), y: scoreButtonY)
        
        scoreMinusButtonB.center = CGPoint(x: frame.width*(5/8), y: scoreButtonY)
        
        scorePlusButtonB.center = CGPoint(x: frame.width*(7/8), y: scoreButtonY)
    }
    
    func landscape(frame: CGRect) {
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            checkOrientation4Pad()
        }
        
        let teamNameY = frame.height*(1/8)
        
        teamLabelA.center = CGPoint(x: frame.width*(1/6),
                                    y: teamNameY)
        
        teamLabelB.center = CGPoint(x: frame.width*(5/6),
                                    y: teamNameY)
        
        let scoreLabelY = frame.height*(1/2)
        
        scoreLabelA.center = CGPoint(x: frame.width*(1/6),
                                     y: scoreLabelY)
        
        scoreLabelB.center = CGPoint(x: frame.width*(5/6),
                                     y: scoreLabelY)
        
        let scoreButtonY = frame.height*(7/8)
        
        scoreMinusButtonA.center = CGPoint(x: frame.width*(1/11), y: scoreButtonY)
        
        scorePlusButtonA.center = CGPoint(x: frame.width*(3/12), y: scoreButtonY)
        
        scoreMinusButtonB.center = CGPoint(x: frame.width*(9/12), y: scoreButtonY)
        
        scorePlusButtonB.center = CGPoint(x: frame.width*(11/12), y: scoreButtonY)
    }

    func initPadAttrPortrait() {
        scoreLabelA.initPadAttrPortrait()
        scoreLabelB.initPadAttrPortrait()
    }
    
    func initPadAttrLandscape() {
        scoreLabelA.initPadAttrLandscape()
        scoreLabelB.initPadAttrLandscape()
    }
}
