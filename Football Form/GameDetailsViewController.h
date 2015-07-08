//
//  GameDetailsViewController.h
//  Football Form
//
//  Created by Aaron Wilkinson on 28/11/2013.
//  Copyright (c) 2013 Createanet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@interface GameDetailsViewController : UIViewController {
    NSMutableArray *gameData;
    NSMutableArray *homeTeamData;
    NSMutableArray *awayTeamData;
    NSMutableArray *goalScorers;
    __weak IBOutlet UILabel *homeTeamName;
    __weak IBOutlet UILabel *awayTeamName;
    __weak IBOutlet UILabel *score;
    
    __weak IBOutlet UILabel *currentPositionHomeTeam;
    __weak IBOutlet UILabel *currentPositionAwayTeam;
    __weak IBOutlet UILabel *currentLeague;
    
    
    __weak IBOutlet UIView *lineUpsView;
    
    __weak IBOutlet UIView *matchNotesView;
    __weak IBOutlet UILabel *matchNotes;
    
    __weak IBOutlet UIView *goalsView;
    __weak IBOutlet UIView *yellowCardsView;
    
    
    __weak IBOutlet UIScrollView *scrollView;
    
    __weak IBOutlet UIView *redCardsView;
    NSMutableArray *lineups;
    
    __weak IBOutlet UIImageView *scoreBg;
    
    
    __weak IBOutlet UIImageView *homeTeamColourBlock;
    __weak IBOutlet UIImageView *awayTeamColourBlock;
    
    
    __weak IBOutlet UILabel *goalsTitle;
    
}
- (IBAction)back:(id)sender;
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;
@end
