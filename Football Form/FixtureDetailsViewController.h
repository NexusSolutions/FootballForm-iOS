//
//  FixtureDetailsViewController.h
//  Football Form
//
//  Created by Aaron Wilkinson on 28/11/2013.
//  Copyright (c) 2013 Createanet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FootballFormDB.h"
#import <StoreKit/StoreKit.h>
#import "MBProgressHUD.h"
@interface FixtureDetailsViewController : UIViewController <SKProductsRequestDelegate, UIScrollViewDelegate> {
    NSMutableArray *gameData;
    
    __weak IBOutlet UIPickerView *pickerView;
    __weak IBOutlet UIScrollView *scrollView;
    NSString *homeTeamID;
    NSString *awayTeamID;
    __weak IBOutlet UIView *pickerEntireView;
    
    NSArray *gamesArray;
    
    NSString *numberOfGames;
    
    NSMutableArray *awayTeamPrevData;
    NSMutableArray *homeTeamPrevData;
        
    NSMutableArray *awayColumnOne;
    NSMutableArray *homeColumnTwo;
    NSMutableArray *awayColumnThree;
    NSMutableArray *homeColumnFour;
    MBProgressHUD *HUD;
    
    __weak IBOutlet UIView *noOfGamesView;
    
    __weak IBOutlet UIView *teamTitleView;
    __weak IBOutlet UIButton *hidePickerBut;
}
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;

@property (weak, nonatomic) IBOutlet UIButton *awayOne;
@property (weak, nonatomic) IBOutlet UIButton *awayTwo;
@property (weak, nonatomic) IBOutlet UIButton *awayThree;
@property (weak, nonatomic) IBOutlet UIButton *awayFour;
@property (weak, nonatomic) IBOutlet UIButton *homeOne;
@property (weak, nonatomic) IBOutlet UIButton *homeTwo;
@property (weak, nonatomic) IBOutlet UIButton *homeThree;
@property (weak, nonatomic) IBOutlet UIButton *homefour;
@property (weak, nonatomic) IBOutlet UIButton *awayFive;
@property (weak, nonatomic) IBOutlet UIButton *awaySix;
@property (weak, nonatomic) IBOutlet UIButton *awaySeven;
@property (weak, nonatomic) IBOutlet UIButton *awayEight;
@property (weak, nonatomic) IBOutlet UIButton *homeFive;
@property (weak, nonatomic) IBOutlet UIButton *homeSix;
@property (weak, nonatomic) IBOutlet UIButton *homeSeven;
@property (weak, nonatomic) IBOutlet UIButton *homeEight;

//The additions (4 games and onwards)
@property (weak, nonatomic) IBOutlet UIButton *awayExtraOne;
@property (weak, nonatomic) IBOutlet UIButton *awayExtraTwo;
@property (weak, nonatomic) IBOutlet UIButton *awayExtraThree;
@property (weak, nonatomic) IBOutlet UIButton *awayExtraFour;
@property (weak, nonatomic) IBOutlet UIButton *awayExtraFive;
@property (weak, nonatomic) IBOutlet UIButton *awayExtraSix;
@property (weak, nonatomic) IBOutlet UIButton *homeExtraOne;
@property (weak, nonatomic) IBOutlet UIButton *homeExtraTwo;
@property (weak, nonatomic) IBOutlet UIButton *homeExtraThree;
@property (weak, nonatomic) IBOutlet UIButton *homeExtraFour;
@property (weak, nonatomic) IBOutlet UIButton *homeExtraFive;
@property (weak, nonatomic) IBOutlet UIButton *homeExtraSix;
@property (weak, nonatomic) IBOutlet UIButton *awayExtraEight;
@property (weak, nonatomic) IBOutlet UIButton *awayExtraNine;
@property (weak, nonatomic) IBOutlet UIButton *awayExtraTen;
@property (weak, nonatomic) IBOutlet UIButton *awayExtraEleven;
@property (weak, nonatomic) IBOutlet UIButton *awayExtraTwelve;
@property (weak, nonatomic) IBOutlet UIButton *awayExtraThirteen;
@property (weak, nonatomic) IBOutlet UIButton *homeExtraEight;
@property (weak, nonatomic) IBOutlet UIButton *homeExtraNine;
@property (weak, nonatomic) IBOutlet UIButton *homeExtraTen;
@property (weak, nonatomic) IBOutlet UIButton *homeExtraEleven;
@property (weak, nonatomic) IBOutlet UIButton *homeExtraTwelve;
@property (weak, nonatomic) IBOutlet UIButton *homeExtraThirteen;


@property (weak, nonatomic) IBOutlet UILabel *homeTeam;
@property (weak, nonatomic) IBOutlet UILabel *awayTeam;
- (IBAction)hidePicker:(id)sender;
- (IBAction)showPicker:(id)sender;

@end
