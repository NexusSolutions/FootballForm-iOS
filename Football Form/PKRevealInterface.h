//
//  PKRevealInterface.h
//  Football Form
//
//  Created by Aaron Wilkinson on 16/04/2014.
//  Copyright (c) 2014 Createanet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import <StoreKit/StoreKit.h>

@interface PKRevealInterface : UIViewController <SKPaymentTransactionObserver, SKStoreProductViewControllerDelegate, SKRequestDelegate, SKPaymentTransactionObserver, SKProductsRequestDelegate, MBProgressHUDDelegate> {
    
    MBProgressHUD *HUD;
    NSMutableArray *countriesArray;
    NSMutableArray *leaguesArray;
    NSMutableArray *continents;
    __weak IBOutlet UIActivityIndicatorView *shareSpinner;
    __weak IBOutlet UIView *countriesView;
    __weak IBOutlet UITableView *countriesTV;
    
    NSString *selectedCountry;
    NSString *selectedLeague;
    NSString *selectedContinent;
    BOOL state;
    NSString *stage;

}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UILabel *currentLeague;
@property (weak, nonatomic) IBOutlet UILabel *currentCountry;

- (IBAction)goToNews:(id)sender;
- (IBAction)goToCountries:(id)sender;
- (IBAction)goToShare:(id)sender;
- (IBAction)goToBetting:(id)sender;
- (IBAction)goToRate:(id)sender;
- (IBAction)hideCountriesView:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *leaguesOut;
- (IBAction)leaguesAct:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *fixturesOut;
- (IBAction)fixturesAct:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *playerVsOut;
- (IBAction)playerVsAct:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *formPlayersOut;
- (IBAction)formPlayersAct:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *favouritesOut;
- (IBAction)favouritesAct:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *newsOut;
- (IBAction)newsAct:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *bettingOut;
- (IBAction)bettingAct:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *liveScoresOut;
- (IBAction)liveScoresAct:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *widgetOut;
- (IBAction)widgetAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *upgradeToPremiumOut;
- (IBAction)upgradeToPremium:(id)sender;

@end
