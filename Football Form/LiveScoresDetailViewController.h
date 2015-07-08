//
//  LiveScoresDetailViewController.h
//  Football Form
//
//  Created by Aaron Wilkinson on 06/05/2014.
//  Copyright (c) 2014 Createanet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LiveScoresDetailViewController : UIViewController {
    NSDictionary *matchData;
    NSMutableArray *scorers;
    NSMutableArray *cards;
    NSMutableArray *scores;
}
@property (strong, nonatomic) NSString *matchID;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *scorersView;
@property (weak, nonatomic) IBOutlet UIView *homeScorers;
@property (weak, nonatomic) IBOutlet UIView *awayScorers;
@property (weak, nonatomic) IBOutlet UIView *cardsView;
@property (weak, nonatomic) IBOutlet UIView *homeCards;
@property (weak, nonatomic) IBOutlet UIView *awayCards;

@property (weak, nonatomic) IBOutlet UILabel *homeTeamName;
@property (weak, nonatomic) IBOutlet UILabel *awayTeamName;
@property (weak, nonatomic) IBOutlet UILabel *score;
@property (weak, nonatomic) IBOutlet UILabel *htScore;

- (IBAction)back:(id)sender;

- (IBAction)refresh:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *refreshOut;
@end
