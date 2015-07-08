//
//  PKRevealInterface.m
//  Football Form
//
//  Created by Aaron Wilkinson on 16/04/2014.
//  Copyright (c) 2014 Createanet. All rights reserved.
//

#import "PKRevealInterface.h"
#import "AppDelegate.h"
#import "PKRevealController.h"
#import "FootballFormDB.h"
@interface PKRevealInterface ()

@end

@implementation PKRevealInterface

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
    // Do any additional setup after loading the view from its nib.
    
    //Listen for NSNotification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(goFixtures)
                                                 name:@"FootballForm:GoToFixtures"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(goToLeagues)
                                                 name:@"FootballForm:GoToLeagues"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(goPlayerVs)
                                                 name:@"FootballForm:GoPlayerVs"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(goFormPlayers)
                                                 name:@"FootballForm:GoToFormPlayers"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(goLiveScore)
                                                 name:@"FootballForm:GoToLiveScores"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(goFavourites)
                                                 name:@"FootballForm:GoFavourites"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(newsAct:)
                                                 name:@"FootballForm:GoNews"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeBetImage)
                                                 name:@"FootballForm:ChangeBettingImage"
                                               object:nil];

    
    shareSpinner.hidden=1;
    
}

-(void)viewDidDisappear:(BOOL)animated {
    stage=@"1";
    
    [countriesView setFrame:CGRectMake(-320, 0, countriesView.frame.size.width, countriesView.frame.size.height)];
}
-(void)viewDidAppear:(BOOL)animated {
    
    BOOL hasPurchasedUpgrade;
    
    NSString *onTrial = [[NSUserDefaults standardUserDefaults]objectForKey:@"FootballForm:CanAccessNoOfGamesInAppThanksToTrial"];
    
    if (!onTrial) {
        
        NSString *hasPaid = [[NSUserDefaults standardUserDefaults]objectForKey:@"hasBroughtInAppPurchase"];
        
        if (![hasPaid isEqualToString:@"YES"]) {
            hasPurchasedUpgrade = NO;
        } else {
            hasPurchasedUpgrade = YES;
        }
        
    } else {
        hasPurchasedUpgrade = YES;
    }

    hasPurchasedUpgrade = NO;
    
    if (hasPurchasedUpgrade) {
        [_scrollView setContentSize:CGSizeMake(0, 585+58+58)];
        [_upgradeToPremiumOut setHidden:YES];
    } else {
        [_scrollView setContentSize:CGSizeMake(0, 585+58+58+58)];
        [_upgradeToPremiumOut setHidden:NO];
    }
    
    [_scrollView setContentOffset:CGPointMake(0, 0)];
    
    stage=@"1";
    
    [countriesView setFrame:CGRectMake(-320, 0, countriesView.frame.size.width, countriesView.frame.size.height)];
    
    if ([countriesArray count]==0) {
        
        continents = [[FootballFormDB sharedInstance]getContinents];
        selectedCountry = [[NSUserDefaults standardUserDefaults]objectForKey:@"countryID"];
        selectedLeague = [[NSUserDefaults standardUserDefaults]objectForKey:@"leagueID"];
        NSString *leagueName = [[NSUserDefaults standardUserDefaults]objectForKey:@"leagueName"];
        NSString *countryName = [[NSUserDefaults standardUserDefaults]objectForKey:@"countryName"];

        selectedContinent = [[NSUserDefaults standardUserDefaults]objectForKey:@"continentName"];
        
        [_currentLeague setText:leagueName];
        [_currentCountry setText:countryName];
        
    }
    
    [countriesTV reloadData];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goToNews:(id)sender {
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    PKRevealController *revealController = (PKRevealController *) appDelegate.window.rootViewController;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *faqsNC = [storyboard instantiateViewControllerWithIdentifier:@"NewsNC"];
    [revealController setFrontViewController:faqsNC];
    [revealController showViewController:revealController.frontViewController animated:YES completion:nil];

}

- (IBAction)goToCountries:(id)sender {
    
    stage=@"1";

    [UIView animateWithDuration:0.5 animations:^{
        
        [countriesView setFrame:CGRectMake(0, 0, countriesView.frame.size.width, countriesView.frame.size.height)];

    }];
    
    
    [countriesTV reloadData];

}

- (IBAction)goToShare:(id)sender {
    
    shareSpinner.hidden=0;
    [shareSpinner startAnimating];
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(doShare) userInfo:nil repeats:NO];
    
}


-(void)doShare {
    
    NSString *shareText = [NSString stringWithFormat:@"Download Football Form App for FREE on iPhone, iPad & Android %@", @"https://itunes.apple.com/us/app/football-form/id741987587?ls=1&mt=8"];
    NSArray *itemsToShare = @[shareText];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll];
    [self presentViewController:activityVC animated:YES completion:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(hidehud) userInfo:nil repeats:NO];
    
}

-(void)hidehud {
    shareSpinner.hidden=1;
    [shareSpinner stopAnimating];

    
    
}


- (IBAction)goToBetting:(id)sender {
}

- (IBAction)goToRate:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id741987587"]];
}

- (IBAction)hideCountriesView:(id)sender {
    
    if ([stage isEqualToString:@"3"]) {
        
        stage = @"2";
        
        int amount = 0;
        int selected = 0;
        
        [countriesTV reloadData];

        
        for (NSDictionary *dict in countriesArray) {
            
            amount++;
            
            if ([[dict objectForKey:@"id"] isEqualToString:selectedCountry]) {
                selected = amount;
            }
        }
        
        int pieceSize = countriesTV.contentSize.height/[countriesArray count];
        float totalSize= (pieceSize*selected)-countriesTV.frame.size.height/2;
        
        
        [countriesTV scrollRectToVisible:CGRectMake(0, totalSize, countriesTV.frame.size.width, countriesTV.frame.size.height) animated:NO];

        
    } else if ([stage isEqualToString:@"2"]) {
        
        stage = @"1";
        
        [countriesTV reloadData];
        [countriesTV scrollRectToVisible:CGRectMake(0, 0, countriesTV.frame.size.width, countriesTV.frame.size.height) animated:NO];
        
    } else {
        
        [UIView animateWithDuration:0.5 animations:^{
            
            [countriesView setFrame:CGRectMake(-320, 0, countriesView.frame.size.width, countriesView.frame.size.height)];
            
        }];
        
    }
    
}


-(void)goFixtures {
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    PKRevealController *revealController = (PKRevealController *) appDelegate.window.rootViewController;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *faqsNC = [storyboard instantiateViewControllerWithIdentifier:@"FixturesNC"];
    [revealController setFrontViewController:faqsNC];
    [revealController showViewController:revealController.frontViewController animated:YES completion:nil];
    
}

-(void)goPlayerVs {
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    PKRevealController *revealController = (PKRevealController *) appDelegate.window.rootViewController;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *faqsNC = [storyboard instantiateViewControllerWithIdentifier:@"PlayerVsNC"];
    [revealController setFrontViewController:faqsNC];
    [revealController showViewController:revealController.frontViewController animated:YES completion:nil];
    
}

-(void)changeBetImage {
    
    [self resetImages];
    
    [_bettingOut setImage:[UIImage imageNamed:@"sideMenuBtnBetting.png"] forState:UIControlStateNormal];
}

-(void)goBetting {
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    PKRevealController *revealController = (PKRevealController *) appDelegate.window.rootViewController;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *faqsNC = [storyboard instantiateViewControllerWithIdentifier:@"BettingNC"];
    [revealController setFrontViewController:faqsNC];
    [revealController showViewController:revealController.frontViewController animated:YES completion:nil];
    
}

-(void)goFavourites {
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    PKRevealController *revealController = (PKRevealController *) appDelegate.window.rootViewController;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *faqsNC = [storyboard instantiateViewControllerWithIdentifier:@"FavouritesNC"];
    [revealController setFrontViewController:faqsNC];
    [revealController showViewController:revealController.frontViewController animated:YES completion:nil];
    
}

-(void)goLiveScore {
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    PKRevealController *revealController = (PKRevealController *) appDelegate.window.rootViewController;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *faqsNC = [storyboard instantiateViewControllerWithIdentifier:@"LiveScoresNC"];
    [revealController setFrontViewController:faqsNC];
    [revealController showViewController:revealController.frontViewController animated:YES completion:nil];

}

-(void)goFormPlayers {
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    PKRevealController *revealController = (PKRevealController *) appDelegate.window.rootViewController;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *faqsNC = [storyboard instantiateViewControllerWithIdentifier:@"FormPlayersNC"];
    [revealController setFrontViewController:faqsNC];
    [revealController showViewController:revealController.frontViewController animated:YES completion:nil];
    
}

-(void)goToLeagues {
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    PKRevealController *revealController = (PKRevealController *) appDelegate.window.rootViewController;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *faqsNC = [storyboard instantiateViewControllerWithIdentifier:@"LeaguesNC"];
    [revealController setFrontViewController:faqsNC];
    [revealController showViewController:revealController.frontViewController animated:YES completion:nil];

}

-(void)goToWidgetsHelp {
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    PKRevealController *revealController = (PKRevealController *) appDelegate.window.rootViewController;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *faqsNC = [storyboard instantiateViewControllerWithIdentifier:@"WidgetsNC"];
    [revealController setFrontViewController:faqsNC];
    [revealController showViewController:revealController.frontViewController animated:YES completion:nil];
    
}

#pragma mark UITableView Delegates
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if ([stage isEqualToString:@"1"]) {
        
        selectedContinent = [continents objectAtIndex:indexPath.row];
        [[NSUserDefaults standardUserDefaults]setObject:selectedContinent forKey:@"continentName"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        int amount = 0;
        int selected = 0;
        
        for (NSDictionary *dict in countriesArray) {
            
            amount++;
            
            if ([[dict objectForKey:@"id"] isEqualToString:selectedCountry]) {
                selected = amount;
            }
        }
        
        countriesArray = [[FootballFormDB sharedInstance]getCountries:selectedContinent];

        
        int pieceSize = countriesTV.contentSize.height/[countriesArray count];
        [countriesTV scrollRectToVisible:CGRectMake(0, (pieceSize*selected)-countriesTV.frame.size.height/2, countriesTV.frame.size.width, countriesTV.frame.size.height) animated:NO];

        stage=@"2";
        
        [countriesTV reloadData];
        
    } else if ([stage isEqualToString:@"2"]) {
        
        NSString *countryName = [[[countriesArray objectAtIndex:indexPath.row] objectForKey:@"name"] capitalizedString];
        
        selectedCountry = [[countriesArray objectAtIndex:indexPath.row] objectForKey:@"id"];
        
        NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.createanet.footballform.TodayExtensionSharingDefaults"];

        [[NSUserDefaults standardUserDefaults]setObject:selectedCountry forKey:@"countryID"];
        [[NSUserDefaults standardUserDefaults]setObject:countryName forKey:@"countryName"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        [sharedDefaults setObject:selectedCountry forKey:@"SharedDefaults:SelectedCountryID"];
        [sharedDefaults synchronize];
        
        [_currentCountry setText:countryName];

        [countriesTV scrollRectToVisible:CGRectMake(0, 0, countriesTV.frame.size.width, countriesTV.frame.size.height) animated:NO];
       
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        PKRevealController *revealController = (PKRevealController *) appDelegate.window.rootViewController;
        [revealController showViewController:revealController.frontViewController];
        
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"FootballForm:PKWillRefresh"
         object:self];
        
        
        
    } else {
        
        NSString *name = [[leaguesArray objectAtIndex:indexPath.row] objectForKey:@"name"];
        name = [name stringByReplacingOccurrencesOfString:@"Fa " withString:@"FA "];
        
        selectedLeague = [[leaguesArray objectAtIndex:indexPath.row] objectForKey:@"leagueID"];
        [[NSUserDefaults standardUserDefaults]setObject:selectedLeague forKey:@"leagueID"];
        [[NSUserDefaults standardUserDefaults]setObject:name forKey:@"leagueName"];
        
        [_currentLeague setText:name];


        [[NSUserDefaults standardUserDefaults]synchronize];
        
        [countriesTV reloadData];
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        PKRevealController *revealController = (PKRevealController *) appDelegate.window.rootViewController;
        [revealController showViewController:revealController.frontViewController];
        
        
        //Send NSNotification (local)
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"FootballForm:PKWillRefresh"
         object:self];
        
        
    }
    
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([stage isEqualToString:@"1"]) {
        
        return [continents count];
        
    } else if ([stage isEqualToString:@"2"]) {
        
        return [countriesArray count];

    } else {
        
        return [leaguesArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([stage isEqualToString:@"1"]) {
        
        if ([continents count]==0) {
            continents = [[FootballFormDB sharedInstance]getContinents];
        }
        
        
        NSString *continentId = [continents objectAtIndex:indexPath.row];
        NSString *CellIdentifer;
        
        if ([continentId isEqualToString:selectedContinent]) {
            
            CellIdentifer = @"Cell2";
            
        } else {
            
            CellIdentifer = @"Cell";
            
        }
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifer];
        }
        
        NSString *tvText = [continents objectAtIndex:indexPath.row];
        
        for (UIImageView *imv in cell.subviews) {
            if ([imv isKindOfClass:[UIImageView class]]) {
                [imv removeFromSuperview];
            }
        }
        
        UIImageView *tick = [[UIImageView alloc] initWithFrame:CGRectMake(220, 6+2.5, 25, 25)];
        [tick setImage:[UIImage imageNamed:@"tickboxOnTransWhite.png"]];
        [cell addSubview:tick];
        
        tick.hidden=1;
        
        if ([continentId isEqualToString:selectedContinent]) {
            tick.hidden=0;
        } else {
            tick.hidden=1;
        }
        
        
        cell.textLabel.text =  [tvText capitalizedString];
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        [cell.textLabel setMinimumScaleFactor:0.5];
        
        cell.backgroundColor=countriesTV.backgroundColor;
        cell.textLabel.textColor = [UIColor whiteColor];
        return cell;

        
        
    
    } else if ([stage isEqualToString:@"2"]) {
        
    NSString *countryId = [[countriesArray objectAtIndex:indexPath.row] objectForKey:@"id"];
    NSString *CellIdentifer;
    
    if ([countryId isEqualToString:selectedCountry]) {
        
        CellIdentifer = @"Celly2";
        
    } else {
        
        CellIdentifer = @"Celly";
        
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifer];
    }
    
    NSString *tvText = [[[countriesArray objectAtIndex:indexPath.row] objectForKey:@"name"] uppercaseString];
    tvText = [tvText stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"(%@)", [[[countriesArray objectAtIndex:indexPath.row] objectForKey:@"code"] uppercaseString]] withString:@""];
    
    for (UIImageView *imv in cell.subviews) {
        if ([imv isKindOfClass:[UIImageView class]]) {
            [imv removeFromSuperview];
        }
        
    }
    
    UIImageView *tick = [[UIImageView alloc] initWithFrame:CGRectMake(220, 6+2.5, 25, 25)];
    [tick setImage:[UIImage imageNamed:@"tickboxOnTransWhite.png"]];
    [cell addSubview:tick];

    tick.hidden=1;
    
    if ([countryId isEqualToString:selectedCountry]) {
        tick.hidden=0;
    } else {
        tick.hidden=1;
    }
        
        UIImageView *telab = (UIImageView *)[cell viewWithTag:19092];
        [telab removeFromSuperview];

        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 200, 25)];
        [textLabel setTag:19092];
        
        tvText = [tvText stringByReplacingOccurrencesOfString:@" (2015/2016)" withString:@""];
        tvText = [tvText stringByReplacingOccurrencesOfString:@" (2014/2015)" withString:@""];
        tvText = [tvText stringByReplacingOccurrencesOfString:@" (2013/2014)" withString:@""];
        
        tvText = [tvText stringByReplacingOccurrencesOfString:@" (15/16)" withString:@""];
        tvText = [tvText stringByReplacingOccurrencesOfString:@" (14/15)" withString:@""];
        tvText = [tvText stringByReplacingOccurrencesOfString:@" (13/14)" withString:@""];
        
        
        [textLabel setText:[NSString stringWithFormat:@"%@",[tvText capitalizedString]]];
        [textLabel setFont:[UIFont systemFontOfSize:15]];
        textLabel.textColor = [UIColor whiteColor];
        
        textLabel.adjustsFontSizeToFitWidth = YES;
        [textLabel setMinimumScaleFactor:0.5];
        [cell addSubview:textLabel];
    
        NSString *seasonID = [[countriesArray objectAtIndex:indexPath.row] objectForKey:@"seasonID"];
        
        UIImageView *selab = (UIImageView *)[cell viewWithTag:19091];
        [selab removeFromSuperview];
        
        UILabel *seasonLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 17, 200, 25)];
        [seasonLabel setTag:19091];
        
        if ([seasonID isEqualToString:@"233"]) {
            
            [seasonLabel setText:[NSString stringWithFormat:@"2013/2014"]];

        } else {
            [seasonLabel setText:[NSString stringWithFormat:@"2014/2015"]];

        }
        [seasonLabel setFont:[UIFont systemFontOfSize:10]];
        seasonLabel.textColor = [UIColor whiteColor];
        
        seasonLabel.adjustsFontSizeToFitWidth = YES;
        [seasonLabel setMinimumScaleFactor:0.5];
        [cell addSubview:seasonLabel];

        
        
        
        cell.backgroundColor=countriesTV.backgroundColor;
        
        
        UIImageView *imv = (UIImageView *)[cell viewWithTag:192];
        [imv removeFromSuperview];
                
        NSString *tvT = [tvText capitalizedString];
        
        tvT = [tvT stringByReplacingOccurrencesOfString:@" (2015/2016)" withString:@""];
        tvT = [tvT stringByReplacingOccurrencesOfString:@" (2014/2015)" withString:@""];
        tvT = [tvT stringByReplacingOccurrencesOfString:@" (2013/2014)" withString:@""];
        
        tvT = [tvT stringByReplacingOccurrencesOfString:@" (15/16)" withString:@""];
        tvT = [tvT stringByReplacingOccurrencesOfString:@" (14/15)" withString:@""];
        tvT = [tvT stringByReplacingOccurrencesOfString:@" (13/14)" withString:@""];

        tvT = [tvT stringByReplacingOccurrencesOfString:@" " withString:@"-"];
        
        UIImageView *country = [[UIImageView alloc] initWithFrame:CGRectMake(5, 6.5, 28, 28)];
        [country setTag:192];
        [country setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", tvT]]];
        [cell addSubview:country];
        
    return cell;
        
    } else {
        
        NSString *leagueId = [[leaguesArray objectAtIndex:indexPath.row] objectForKey:@"leagueID"];
        NSString *CellIdentifer;
        
        if ([leagueId isEqualToString:selectedLeague]) {
            
            CellIdentifer = @"Cell2";
            
        } else {
            
            CellIdentifer = @"Cell";
            
        }
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifer];
        }
        
        NSString *tvText = [[leaguesArray objectAtIndex:indexPath.row] objectForKey:@"name"];
        
        for (UIImageView *imv in cell.subviews) {
            if ([imv isKindOfClass:[UIImageView class]]) {
                [imv removeFromSuperview];
            }
        }
        
        UIImageView *tick = [[UIImageView alloc] initWithFrame:CGRectMake(220, 6+2.5, 25, 25)];
        [tick setImage:[UIImage imageNamed:@"tickboxOnTransWhite.png"]];
        [cell addSubview:tick];
        
        tick.hidden=1;
        
        if ([leagueId isEqualToString:selectedLeague]) {
            tick.hidden=0;
        } else {
            tick.hidden=1;
        }
        
        tvText = [tvText capitalizedString];
        
        tvText = [tvText stringByReplacingOccurrencesOfString:@"Fa " withString:@"FA "];

        cell.textLabel.text =  tvText;
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        [cell.textLabel setMinimumScaleFactor:0.5];
        
        cell.backgroundColor=countriesTV.backgroundColor;
        cell.textLabel.textColor = [UIColor whiteColor];
        return cell;
        
    }
}

/*
 - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
 */

-(void)resetImages {
    
    [_leaguesOut setImage:[UIImage imageNamed:@"sideMenuBtnLeaguesUnselected.png"] forState:UIControlStateNormal];
    [_fixturesOut setImage:[UIImage imageNamed:@"sideMenuBtnFixturesUnselected.png"] forState:UIControlStateNormal];
    [_playerVsOut setImage:[UIImage imageNamed:@"sideMenuBtnPlayerVsUnselected.png"] forState:UIControlStateNormal];
    [_formPlayersOut setImage:[UIImage imageNamed:@"sideMenuBtnFormPlayersUnselected.png"] forState:UIControlStateNormal];
    [_favouritesOut setImage:[UIImage imageNamed:@"sideMenuBtnFavouritesUnselected.png"] forState:UIControlStateNormal];
    [_newsOut setImage:[UIImage imageNamed:@"sideMenuBtn1Unselected.png"] forState:UIControlStateNormal];
    [_liveScoresOut setImage:[UIImage imageNamed:@"sideMenuBtnLiveScoresUnselected.png"] forState:UIControlStateNormal];
    [_bettingOut setImage:[UIImage imageNamed:@"sideMenuBtnBettingUnselected.png"] forState:UIControlStateNormal];


}

- (IBAction)leaguesAct:(id)sender {
    [self resetImages];
    [_leaguesOut setImage:[UIImage imageNamed:@"sideMenuBtnLeagues.png"] forState:UIControlStateNormal];
    [self goToLeagues];

}

- (IBAction)fixturesAct:(id)sender {
    [self resetImages];
    [_fixturesOut setImage:[UIImage imageNamed:@"sideMenuBtnFixtures.png"] forState:UIControlStateNormal];
    [self goFixtures];

}


- (IBAction)playerVsAct:(id)sender {
    [self resetImages];
    [_playerVsOut setImage:[UIImage imageNamed:@"sideMenuBtnPlayerVs.png"] forState:UIControlStateNormal];
    [self goPlayerVs];

}


- (IBAction)formPlayersAct:(id)sender {
    
    /*
    NSMutableArray *checkIfHaveData = [[FootballFormDB sharedInstance]getFormPlayers:selectedLeague limitBy:@"1"];

    if (checkIfHaveData.count <=0) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Form Players" message:@"Form players data is not available for this league." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        
    } else {
        
        [self resetImages];
        [_formPlayersOut setImage:[UIImage imageNamed:@"sideMenuBtnFormPlayers.png"] forState:UIControlStateNormal];
        [self goFormPlayers];
        
    }
     */
    
    
    [self resetImages];
    [_formPlayersOut setImage:[UIImage imageNamed:@"sideMenuBtnFormPlayers.png"] forState:UIControlStateNormal];
    [self goFormPlayers];


}


- (IBAction)favouritesAct:(id)sender {
    
    [self resetImages];
    [_favouritesOut setImage:[UIImage imageNamed:@"sideMenuBtnFavourites.png"] forState:UIControlStateNormal];
    [self goFavourites];

}


- (IBAction)newsAct:(id)sender {
    
    [self resetImages];
    [_newsOut setImage:[UIImage imageNamed:@"sideMenuBtn1.png"] forState:UIControlStateNormal];
    [self goToNews:nil];

}


- (IBAction)liveScoresAct:(id)sender {
    
    [self resetImages];
    [_liveScoresOut setImage:[UIImage imageNamed:@"sideMenuBtnLiveScores.png"] forState:UIControlStateNormal];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    PKRevealController *revealController = (PKRevealController *) appDelegate.window.rootViewController;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *faqsNC = [storyboard instantiateViewControllerWithIdentifier:@"LiveScoresNC"];
    [revealController setFrontViewController:faqsNC];
    [revealController showViewController:revealController.frontViewController animated:YES completion:nil];
    
}

- (IBAction)bettingAct:(id)sender {
    
    [self resetImages];
    [_bettingOut setImage:[UIImage imageNamed:@"sideMenuBtnBetting.png"] forState:UIControlStateNormal];
    [self goBetting];
    
}

- (IBAction)widgetAction:(id)sender {
    
    [self resetImages];
    [_widgetOut setImage:[UIImage imageNamed:@"sideMenuBtnWidgets.png"] forState:UIControlStateNormal];
    [self goToWidgetsHelp];

}

- (IBAction)upgradeToPremium:(id)sender {
    
    if ([SKPaymentQueue canMakePayments]) {
        
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [HUD setMode:MBProgressHUDModeIndeterminate];
        [HUD setDetailsLabelText:@"Loading..."];
        [HUD show:YES];//
        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(makeRequest) userInfo:nil repeats:NO];
        
        
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"In App Purchase" message:@"We are unable to take an In-App Purchase from this device. Please ensure that parental controls aren't enabled." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    
}




-(void)makeRequest {
    
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:@"FF150129012014"]];
    
    request.delegate = self;
    
    [request start];
    
}

-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    
    
    SKProduct *validProduct = nil;
    
    int count = [response.products count];
    
    
    
    if (count>0) {
        
        validProduct = [response.products objectAtIndex:0];
        
        
        
        SKPayment *payment = [SKPayment paymentWithProduct:validProduct];
        
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        
        
        [[SKPaymentQueue defaultQueue] addPayment:payment]; // <-- KA CHING!
        
        
        
        
    } else {
        
        UIAlertView *tmp = [[UIAlertView alloc]
                            
                            initWithTitle:@"Not Available"
                            
                            message:@"No products to purchase"
                            
                            delegate:self
                            
                            cancelButtonTitle:nil
                            
                            otherButtonTitles:@"Ok", nil];
        
        [tmp show];
        
        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(hideHud) userInfo:nil repeats:NO];
        
        
    }
    
    
    
}

-(void)hideHud {
    
    [HUD removeFromSuperview];
    
}

-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing:
                
                break;
                
            case SKPaymentTransactionStatePurchased:
                
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                
                [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"hasBroughtInAppPurchase"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                [self successfulPurchase:NO];
                
                [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(hideHud) userInfo:nil repeats:NO];
                
                break;
                
            case SKPaymentTransactionStateRestored:
                
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                
                [self successfulPurchase:YES];
                
                [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"hasBroughtInAppPurchase"];
                [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(hideHud) userInfo:nil repeats:NO];
                
                break;
                
            case SKPaymentTransactionStateFailed:
                
                if (transaction.error.code != SKErrorPaymentCancelled) {
                    
                    NSLog(@"FAILED %@", transaction.error);
                    
                    if (transaction.error.localizedDescription) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Transaction Failed" message:transaction.error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                        [alert show];
                    }
                    
                } else {
                    
                    NSLog(@"User canceled");
                    
                }
                
                [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(hideHud) userInfo:nil repeats:NO];
                
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                
                
                break;
                
            default:
                break;
        }
    }
}

-(void)successfulPurchase:(BOOL)wasRestored {
    
    [_scrollView setContentSize:CGSizeMake(0, 585+58+58)];
    [_upgradeToPremiumOut setHidden:YES];
    
    if (wasRestored) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Restore Successful" message:@"Thank you, you have now been upgraded to premium" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Purchase Successful" message:@"Thank you, you have now been upgraded to premium" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    
    
}

@end
