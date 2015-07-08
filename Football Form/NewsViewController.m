//
//  NewsViewController.m
//  Football Form
//
//  Created by Aaron Wilkinson on 23/01/2014.
//  Copyright (c) 2014 Createanet. All rights reserved.
//

#import "NewsViewController.h"
#import "Parser.h"
#import "FootballFormDB.h"

@interface NewsViewController ()

@end

@implementation NewsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    } else {
        // iOS 6
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
    
    [_tableView setSeparatorInset:UIEdgeInsetsZero];
    [_tableView setSeparatorColor:[UIColor clearColor]];
    //getrssfeedlink
    
    /*
    if (!IS_IPHONE5) {
        [_tableView setFrame:CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y, 480, _tableView.frame.size.height)];
        
        [choseFed setFrame:CGRectMake(([[UIScreen mainScreen] bounds].size.height-choseFed.frame.size.width)-15, choseFed.frame.origin.y, choseFed.frame.size.width, choseFed.frame.size.height)];
        [closebutty setFrame:CGRectMake(([[UIScreen mainScreen] bounds].size.height-closebutty.frame.size.width)-15, closebutty.frame.origin.y, closebutty.frame.size.width, closebutty.frame.size.height)];
        [_pickerView setFrame:CGRectMake(_pickerView.frame.origin.x, _pickerView.frame.origin.y, [[UIScreen mainScreen] bounds].size.height, _pickerView.frame.size.height)];
        [titleLeague setFrame:CGRectMake(137, titleLeague.frame.origin.y, titleLeague.frame.size.width, titleLeague.frame.size.height)];
    }
     */
    
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl setTintColor:[UIColor blueColor]];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    
   
    [self checkRotation];
    
    _newsCategoryCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, (_newsCategoryCollectionView.frame.size.width/2)+425);
    


}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    
    [self checkRotation];
    
}

-(void)checkRotation {
    
    [bannerView setFrame:CGRectMake(bannerView.frame.origin.x, self.view.frame.size.height-bannerView.frame.size.height, self.view.frame.size.width, bannerView.frame.size.height)];
    
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    
    items = nil;
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(loadData) userInfo:nil repeats:NO];
    
    [UIView animateWithDuration:0.7 animations:^{
        [_entirePickerView setAlpha:0.0];
    }];

}


//UIPickerView delegate methods
- (void)pickerView:(UIPickerView *)pV didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    leagueId = [[sportDataURL objectAtIndex:row] objectForKey:@"id"];
    
    leagueName = [[sportDataURL objectAtIndex:row] objectForKey:@"name"];
    
    leagueURL = [[sportDataURL objectAtIndex:row] objectForKey:@"url"];
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [sportDataURL count];
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [[sportDataURL objectAtIndex:row] objectForKey:@"name"];
}


- (BOOL)prefersStatusBarHidden {
    
    return YES;
}


-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(void)viewWillAppear:(BOOL)animated {
    
    sportDataURL = [[FootballFormDB sharedInstance]getRSSFeedLinks];

    [self setUpTabBar];
    
    [_entirePickerView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [_entirePickerView setAlpha:0.0];
    
}

-(void)viewDidAppear:(BOOL)animated {
    
    if (sportDataURL.count > 0) {
        
        leagueId = [[sportDataURL objectAtIndex:0] objectForKey:@"id"];
        leagueName = [[sportDataURL objectAtIndex:0] objectForKey:@"name"];
        leagueURL = [[sportDataURL objectAtIndex:0] objectForKey:@"url"];
        
        NSString *openedFromWidget = [[NSUserDefaults standardUserDefaults]objectForKey:@"FootballForm:OpenURL"];
        
        if (openedFromWidget) {
            
            if ([openedFromWidget isEqualToString:@"footballform://news/premier-league"]) {
                
                leagueId = [[sportDataURL objectAtIndex:1] objectForKey:@"id"];
                leagueName = [[sportDataURL objectAtIndex:1] objectForKey:@"name"];
                leagueURL = [[sportDataURL objectAtIndex:1] objectForKey:@"url"];
                
                [_newsCategoryCollectionView setContentOffset:CGPointMake(213, 0)];
                
            }
        }
    
        if (items == nil) {
            
            HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [HUD setMode:MBProgressHUDModeIndeterminate];
            [HUD setLabelText:@"Loading News"];
            [HUD setDetailsLabelText:@"Please wait..."];
            
            [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(loadData) userInfo:nil repeats:NO];
            
        } else {
            
            [HUD removeFromSuperview];
            [self.tableView reloadData];
            
        }
            
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Sorry, there was an issue getting the RSS feed links. Please redownload the football database and try again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"FootballForm:OpenURL"];
    [[NSUserDefaults standardUserDefaults]synchronize];

}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    
        return [sportDataURL count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionViewy cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell *cell = (UICollectionViewCell *)[collectionViewy dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    UILabel *sportsNewsName = (UILabel *)[cell viewWithTag:101];
    [sportsNewsName setText:[[sportDataURL objectAtIndex:indexPath.row] objectForKey:@"name"]];
    
    int fractionalPage = _newsCategoryCollectionView.contentOffset.x / 201;
    
    if (fractionalPage>=indexPath.row) {
        
        if (fractionalPage>=[sportDataURL count]) {
            fractionalPage=(int)[sportDataURL count]-1;
        }
        
        if (![selectedLe isEqualToString:[[sportDataURL objectAtIndex:fractionalPage] objectForKey:@"id"]]) {
            selectedLe = [[sportDataURL objectAtIndex:fractionalPage] objectForKey:@"id"];
            
            items = nil;
            
            leagueId = [[sportDataURL objectAtIndex:fractionalPage] objectForKey:@"id"];
            leagueName = [[sportDataURL objectAtIndex:fractionalPage] objectForKey:@"name"];
            leagueURL = [[sportDataURL objectAtIndex:fractionalPage] objectForKey:@"url"];
            
            [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(loadData) userInfo:nil repeats:NO];
            
        }
        
        [sportsNewsName setTextColor:[UIColor whiteColor]];
        
    } else {
        
        [sportsNewsName setTextColor:[UIColor colorWithRed:160/255.0f green:178/255.0f blue:192/255.0f alpha:1]];
        
    }

    return cell;
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView==_newsCategoryCollectionView) {
        
        if (!scrollView.decelerating) {
            [_newsCategoryCollectionView reloadData];
        }
        
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView==_newsCategoryCollectionView) {
        [UIView animateWithDuration:0.5 animations:^{
            CGFloat pageWidth = 201;
            int fractionalPage = _newsCategoryCollectionView.contentOffset.x / pageWidth;
            
            if (fractionalPage>=[sportDataURL count]) {
                fractionalPage=(int)[sportDataURL count]-1;
            }
            
            [_newsCategoryCollectionView setContentOffset:CGPointMake(fractionalPage*213, 0)];
            
        }];
    }
    
}


- (void)loadData {
    
    [titleLeague setText:[NSString stringWithFormat:@"%@ Feed", leagueName]];
	if (items == nil) {
		
		Parser *rssParser = [[Parser alloc] init];
		[rssParser parseRssFeed:leagueURL withDelegate:self];
        
	} else {
        [HUD removeFromSuperview];
        
		[self.tableView reloadData];
        [refreshControl endRefreshing];
	}
    
}

- (void)receivedItems:(NSArray *)theItems {
	items = theItems;
	[self.tableView reloadData];
    
    [HUD removeFromSuperview];
    [refreshControl endRefreshing];
    
}



//UITableView delegate methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [[NSUserDefaults standardUserDefaults]setObject:[items objectAtIndex:indexPath.row] forKey:@"newsStoryToShow"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [self performSegueWithIdentifier:@"newsDet" sender:self];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //Dont forget to change the cell identifier in the storyboard/xib file
    static NSString *CellIdentifer = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifer];
    }
    
    if (indexPath.row % 2) {
        [cell setBackgroundColor:[UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:1]];
    } else {
        [cell setBackgroundColor:[UIColor whiteColor]];
    }
        
    UILabel *label = (UILabel *)[cell viewWithTag:101];
    label.text = [[items objectAtIndex:indexPath.row] objectForKey:@"title"];
    
    /*
    if (!IS_IPHONE5) {
        [label setFrame:CGRectMake(10, 5, 440, 29)];
    }
    */
    UILabel *date = (UILabel *)[cell viewWithTag:102];
    date.text = [[items objectAtIndex:indexPath.row] objectForKey:@"date"];
    
    date.text = [date.text stringByReplacingOccurrencesOfString:@" +0000" withString:@""];

    UIImageView *im = (UIImageView *)[cell viewWithTag:1997];
    [im setImageWithURL:[NSURL URLWithString:[[items objectAtIndex:indexPath.row] objectForKey:@"podcastLink"]]];

    
    return cell;
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

- (IBAction)closePicker:(id)sender {
    items = nil;
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HUD setMode:MBProgressHUDModeIndeterminate];
    [HUD setLabelText:@"Loading News"];
    [HUD setDetailsLabelText:@"Please wait..."];
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(loadData) userInfo:nil repeats:NO];

    
    [UIView animateWithDuration:0.7 animations:^{
        [_entirePickerView setAlpha:0.0];
    }];
}

- (IBAction)showPeek:(id)sender {
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    PKRevealController *revealController = (PKRevealController *) appDelegate.window.rootViewController;
    [revealController showViewController:revealController.leftViewController];
    
}

- (IBAction)chooseFeed:(id)sender {
    [UIView animateWithDuration:0.7 animations:^{
        [_entirePickerView setAlpha:1.0];
    }];
}

#pragma mark iAd Delegate Methods

// Method is called when the iAd is loaded.
-(void)bannerViewDidLoadAd:(ADBannerView *)banner {
    
    float tvHeight1 = self.view.frame.size.height-_tableView.frame.origin.y;
    
    [_tableView setFrame:CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y, _tableView.frame.size.width, tvHeight1-bannerView.frame.size.height)];
    [bannerView setFrame:CGRectMake(bannerView.frame.origin.x, self.view.frame.size.height-bannerView.frame.size.height, self.view.frame.size.width, bannerView.frame.size.height)];
    
    [UIView beginAnimations:nil context:nil];
    
    [UIView setAnimationDuration:1];
    
    [banner setAlpha:1];
    
    [UIView commitAnimations];
    
    hasGotAd=YES;
    
}

// Method is called when the iAd fails to load.
-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    
    float tvHeight1 = self.view.frame.size.height-_tableView.frame.origin.y;
    
    [_tableView setFrame:CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y, _tableView.frame.size.width, tvHeight1)];
    
    [UIView beginAnimations:nil context:nil];
    
    [UIView setAnimationDuration:1];
    
    [banner setAlpha:0];
    
    [UIView commitAnimations];
    
    hasGotAd=NO;
    
}

@end
