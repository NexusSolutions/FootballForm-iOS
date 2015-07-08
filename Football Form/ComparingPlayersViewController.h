//
//  ComparingPlayersViewController.h
//  Football Form
//
//  Created by Aaron Wilkinson on 05/12/2013.
//  Copyright (c) 2013 Createanet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import <StoreKit/StoreKit.h>
@interface ComparingPlayersViewController : UIViewController <SKProductsRequestDelegate> {
    
    NSMutableArray *playerOneData;
    NSMutableArray *playerTwoData;
    
    NSString *amountOfGames;
    
    NSArray *gamesArray;
    
    //Entire season
    __weak IBOutlet UILabel *totalScoredPlayerOne;
    __weak IBOutlet UILabel *totalScoredPlayerTwo;
    
    __weak IBOutlet UILabel *averageScoreTimePlayerOne;
    __weak IBOutlet UILabel *averageScoreTimePlayerTwo;
    
    __weak IBOutlet UILabel *totalYellowCardsPlayerOne;
    __weak IBOutlet UILabel *totalYellowCardsPlayerTwo;
    
    __weak IBOutlet UILabel *totalRedCardsPlayerOne;
    __weak IBOutlet UILabel *totalRedCardsPlayerTwo;
    
    __weak IBOutlet UILabel *averageCardTimePlayerOne;
    __weak IBOutlet UILabel *averageCardTimePlayerTwo;
    
    __weak IBOutlet UIImageView *vsIcon;
    
    __weak IBOutlet UITabBar *tabBar;
    __weak IBOutlet UIScrollView *scrollView;
    
    __weak IBOutlet UILabel *lastXGames;
    
    __weak IBOutlet UIView *noGamesView;
    //Last X Games
    __weak IBOutlet UILabel *lastXGamesTotScoredPlayerOne;
    __weak IBOutlet UILabel *lastXGamesTotScoredPlayerTwo;
    
    __weak IBOutlet UILabel *lastXGamesAvgScoreTimePlayerOne;
    __weak IBOutlet UILabel *lastXGamesAvgScoreTimePlayerTwo;
    
    __weak IBOutlet UILabel *lastXGamesTotYellowCardsPlayerOne;
    __weak IBOutlet UILabel *lastXGamesYellowCardsPlayerTwo;
    
    __weak IBOutlet UILabel *lastXGamesTotRedCardsPlayerOne;
    __weak IBOutlet UILabel *lastXGamesRedCardsPlayerTwo;
    
    __weak IBOutlet UILabel *lastXGamesAvgCardTimePlayer1;
    __weak IBOutlet UILabel *lastXGamesAvgCardTimePlayer2;
    
    __weak IBOutlet UILabel *lastXGamesTotalAppPlayerOne;
    __weak IBOutlet UILabel *lastXGamesTotalAppPlayerTwo;
    
    MBProgressHUD *HUD;
    
    __weak IBOutlet UIButton *closebutty;
    __weak IBOutlet UIView *lastXGamesView;
    __weak IBOutlet UIView *cardsView;
    
    
    __weak IBOutlet UIView *entireSeasonScoreView;
    __weak IBOutlet UIView *entireSeasonCards;
    
    
    
    __weak IBOutlet UIView *homeAwayGoals;
    
    NSString *teamOneLeagueID;
    NSString *teamTwoLeagueID;
    
}
- (IBAction)back:(id)sender;


- (IBAction)showPicker:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *gameAmountText;
@property (weak, nonatomic) IBOutlet UILabel *playerOne;
@property (weak, nonatomic) IBOutlet UILabel *playerTwo;

@property (weak, nonatomic) IBOutlet UIPickerView *picker;
- (IBAction)hidePicker:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *entirePickerView;
@end
