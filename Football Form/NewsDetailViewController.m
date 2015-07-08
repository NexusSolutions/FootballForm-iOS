//
//  NewsDetailViewController.m
//  Football Form
//
//  Created by Aaron Wilkinson on 27/01/2014.
//  Copyright (c) 2014 Createanet. All rights reserved.
//

#import "NewsDetailViewController.h"
#import "FootballFormDB.h"
#import <iAd/iAd.h>

@interface NewsDetailViewController ()

@end

@implementation NewsDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    // Then your code...
    
    [self checkRotation];
    
}
-(void)checkRotation {
    
    
    if (UIInterfaceOrientationIsPortrait([[UIDevice currentDevice] orientation])) {
        
        //[_image setHidden:YES];
        [theNewsTitle setFrame:CGRectMake(11, theNewsTitle.frame.origin.y, (self.view.frame.size.width)-22, theNewsTitle.frame.size.height)];
        [theNewsTitle setTextAlignment:NSTextAlignmentCenter];
        
        [UIView animateWithDuration:0.3 animations:^{
            
            [_image setFrame:CGRectMake(self.view.center.x-_image.frame.size.width/2, (theNewsTitle.frame.size.height+theNewsTitle.frame.origin.y)+10, _image.frame.size.width, _image.frame.size.height)];
            [_date setFrame:CGRectMake(_date.frame.origin.x, (_image.frame.size.height+_image.frame.origin.y)+7, _date.frame.size.width, _date.frame.size.height)];
            [_shareFullArtView setFrame:CGRectMake(_shareFullArtView.frame.origin.x, _date.frame.size.height+_date.frame.origin.y, _shareFullArtView.frame.size.width, _shareFullArtView.frame.size.height)];
            [_descriptionTV setFrame:CGRectMake(_descriptionTV.frame.origin.x, _shareFullArtView.frame.size.height+_shareFullArtView.frame.origin.y, _descriptionTV.frame.size.width, _descriptionTV.frame.size.height)];

        }];
        
    } else {
        [_image setHidden:NO];
        [theNewsTitle setFrame:CGRectMake(11, theNewsTitle.frame.origin.y, (self.view.frame.size.width-_image.frame.size.width)-14, theNewsTitle.frame.size.height)];
        [theNewsTitle setTextAlignment:NSTextAlignmentLeft];
        
        [UIView animateWithDuration:0.3 animations:^{
            
            [_image setFrame:CGRectMake((theNewsTitle.frame.size.width+theNewsTitle.frame.origin.x)+1, theNewsTitle.frame.origin.y, _image.frame.size.width, _image.frame.size.height)];
            [_date setFrame:CGRectMake(_date.frame.origin.x, (theNewsTitle.frame.size.height+theNewsTitle.frame.origin.y)+7, _date.frame.size.width, _date.frame.size.height)];
            [_shareFullArtView setFrame:CGRectMake(_shareFullArtView.frame.origin.x, _date.frame.size.height+_date.frame.origin.y, _shareFullArtView.frame.size.width, _shareFullArtView.frame.size.height)];
            [_descriptionTV setFrame:CGRectMake(_descriptionTV.frame.origin.x, (_image.frame.size.height+_image.frame.origin.y)+10, _descriptionTV.frame.size.width, _descriptionTV.frame.size.height)];

            float am = self.view.frame.size.height-_descriptionTV.frame.origin.y;
            [_descriptionTV setFrame:CGRectMake(_descriptionTV.frame.origin.x, _descriptionTV.frame.origin.y, _descriptionTV.frame.size.width, am)];

            
        }];


    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.canDisplayBannerAds = YES;

    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    } else {
        // iOS 6
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
    
    [self setUpTabBar];
    
    newsStory = [[NSUserDefaults standardUserDefaults]dictionaryForKey:@"newsStoryToShow"];
    
    [_date setText:[newsStory objectForKey:@"date"]];
    _date.text = [_date.text stringByReplacingOccurrencesOfString:@" +0000" withString:@""];
    
    [theNewsTitle setText:[newsStory objectForKey:@"title"]];
    [_descriptionTV setText:[newsStory objectForKey:@"summary"]];
    //[_image setImage:[UIImage imageNamed:[newsStory objectForKey:@"podcastLink"]]];
    
    NSString *podLink = [newsStory objectForKey:@"podcastLink"];
    podLink = [podLink stringByReplacingOccurrencesOfString:@"_thumb" withString:@""];
    _image.imageURL = [NSURL URLWithString:podLink];
    
    theNewsTitle.text = [theNewsTitle.text stringByReplacingOccurrencesOfString:@"\n\t\t\t" withString:@""];
    
    /*
    if (!IS_IPHONE5) {
        [theNewsTitle setFrame:CGRectMake(11, 49, 314, 58)];
        [_image setFrame:CGRectMake(337, 49, 136, 136)];
        [_description setFrame:CGRectMake(_description.frame.origin.x, _description.frame.origin.y, [[UIScreen mainScreen] bounds].size.height, _description.frame.size.height)];
    }
     */
    
    [self checkRotation];

    
}

-(void)viewDidAppear:(BOOL)animated {
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(checkRotation) userInfo:nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(checkRotation) userInfo:nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(checkRotation) userInfo:nil repeats:NO];

}

- (BOOL)prefersStatusBarHidden {
    
    return YES;
}


-(void)setUpTabBar {
    
    [self.tabBarController.tabBar setHidden:YES];
    [self.tabBarController.tabBar removeFromSuperview];
    
    UITabBarItem *fixtures = [[UITabBarItem alloc] initWithTitle:@"Fixtures" image:[UIImage imageNamed:@"tabicons1Fixtures.png"] tag:1];
    UITabBarItem *Leagues = [[UITabBarItem alloc] initWithTitle:@"Leagues" image:[UIImage imageNamed:@"tabicons2Leagues.png"] tag:2];
    UITabBarItem *playerVs = [[UITabBarItem alloc]initWithTitle:@"Player Vs" image:[UIImage imageNamed:@"tabicons3PlayerVs.png"] tag:3];
    UITabBarItem *formPlayers = [[UITabBarItem alloc]initWithTitle:@"Form Players" image:[UIImage imageNamed:@"tabicons4FormPlayers.png"] tag:4];
    UITabBarItem *statsExplorer = [[UITabBarItem alloc]initWithTitle:@"Live Scores" image:[UIImage imageNamed:@"tabicons5Stats.png"] tag:5];
    UITabBarItem *favourites = [[UITabBarItem alloc]initWithTitle:@"Favourites" image:[UIImage imageNamed:@"tabicons6Fav.png"] tag:6];
    UITabBarItem *compare = [[UITabBarItem alloc]initWithTitle:@"More" image:[UIImage imageNamed:@"tabicons7Compare.png"] tag:7];
    
    [_tabBar setItems:@[Leagues, fixtures, playerVs, formPlayers, statsExplorer, favourites, compare]animated:NO];
    
    [_tabBar setSelectedItem:compare];
    
}


-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    
    
    if (item.tag==1) {
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"FootballForm:GoToFixtures"
         object:self];
        
    } else if (item.tag==2) {
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"FootballForm:GoToLeagues"
         object:self];
        
    } else if (item.tag==3) {
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"FootballForm:GoPlayerVs"
         object:self];
        
    } else if (item.tag==4) {
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"FootballForm:GoToFormPlayers"
         object:self];
        
    } else if (item.tag==5) {
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"FootballForm:GoToLiveScores"
         object:self];
        
    } else if (item.tag==6) {
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"FootballForm:GoFavourites"
         object:self];
        
    } else if (item.tag==7) {
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        PKRevealController *revealController = (PKRevealController *) appDelegate.window.rootViewController;
        [revealController showViewController:revealController.leftViewController];
        
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    //[self.navigationController popToRootViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)share:(id)sender {
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HUD setMode:MBProgressHUDModeIndeterminate];
    [HUD setLabelText:@"Loading"];
    [HUD setDetailsLabelText:@"Please wait..."];
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(doShare) userInfo:nil repeats:NO];
    
    
}


-(void)doShare {
    NSString *link = [newsStory objectForKey:@"link"];
    [link stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    NSString *shareText = [NSString stringWithFormat:@"%@\nSent via Football Form iOS App", link];
    NSArray *itemsToShare = @[shareText];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll]; //or whichever you don't need
    [self presentViewController:activityVC animated:YES completion:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(hidehud) userInfo:nil repeats:NO];

}

-(void)hidehud {
    [HUD hide:YES];
    [HUD removeFromSuperview];
}


- (IBAction)viewFullArticle:(id)sender {
    
    
    
    NSString *link = [newsStory objectForKey:@"link"];
    
    NSString *param3 = nil;
    NSRange start3 = [link rangeOfString:@"h"];
    if (start3.location != NSNotFound)
    {
        param3 = [link substringFromIndex:start3.location + start3.length];
        NSRange end3 = [param3 rangeOfString:@" "];
        if (end3.location != NSNotFound)
        {
            param3 = [param3 substringToIndex:end3.location];
        }
    }
    
    param3 = [param3 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    
    
    NSURL *webURL =  [NSURL URLWithString:[NSString stringWithFormat:@"h%@",param3]];
    [[UIApplication sharedApplication] openURL: webURL];
}
@end
