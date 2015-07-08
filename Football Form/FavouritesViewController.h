//
//  FavouritesViewController.h
//  Football Form
//
//  Created by Aaron Wilkinson on 28/11/2013.
//  Copyright (c) 2013 Createanet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavouritesViewController : UIViewController <UITabBarDelegate, UITabBarControllerDelegate> {
    NSMutableArray *leagueData;
    NSString *theTeamID;
    NSString *theLeagueID;
    __weak IBOutlet UILabel *noFavourites;
    __weak IBOutlet UIView *teamNameView;
    __weak IBOutlet UIScrollView *teamNameViewSV;
}
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)showPeek:(id)sender;
@end
