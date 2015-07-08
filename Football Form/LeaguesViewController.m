//
//  LeaguesViewController.m
//  Football Form
//
//  Created by Aaron Wilkinson on 28/11/2013.
//  Copyright (c) 2013 Createanet. All rights reserved.
//

#import "LeaguesViewController.h"
#import "FootballFormDB.h"
#import <QuartzCore/QuartzCore.h>
#import <iAd/iAd.h>
@interface LeaguesViewController ()

@end

@implementation LeaguesViewController

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
    
    //was 206
    if (UIInterfaceOrientationIsPortrait([[UIDevice currentDevice] orientation])) {
        
        [teamNameView setFrame:CGRectMake(0, 93, 161, teamNameView.frame.size.height)];
        
        [UIView animateWithDuration:0.3 animations:^{
            [leagueTitle setAlpha:0.0];
        }];

    } else {
        
        [teamNameView setFrame:CGRectMake(0, 93, 161, teamNameView.frame.size.height)];
        
        [UIView animateWithDuration:0.3 animations:^{
            [leagueTitle setAlpha:1.0];
        }];

    }
    
    //[leagueTitle setFont:[UIFont systemFontOfSize:17]];
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    if (isFilteringByGroups) return [groupsArray count];
    
    return [leaguesArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionViewy cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell;
    
    if (!isFilteringByGroups) {
        
        cell = (UICollectionViewCell *)[collectionViewy dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
        
        UILabel *leagueName = (UILabel *)[cell viewWithTag:101];
        [leagueName setText:[[leaguesArray objectAtIndex:indexPath.row] objectForKey:@"name"]];
        
        int fractionalPage = leaguesCollectionView.contentOffset.x / kSetCellSize;
        
        if (fractionalPage>=indexPath.row) {
            
            if (fractionalPage>=[leaguesArray count]) {
                fractionalPage=(int)[leaguesArray count]-1;
            }
            
            if (![selectedLeague isEqualToString:[[leaguesArray objectAtIndex:fractionalPage] objectForKey:@"leagueID"]]) {
                
                isFilteredLooses = NO;
                isFilteredDraws = NO;
                isFilteredPlayed = NO;
                isFilteredWins = NO;
                isFilteredGoalsFor = NO;
                isFilteredGoalsAgainst = NO;
                isFilteredGoalDifference = NO;

                selectedLeague = [[leaguesArray objectAtIndex:fractionalPage] objectForKey:@"leagueID"];
                
                whereIWasGroup = 0;
                
                [self getGroups];
                
                groupText = @"";
                
                if (groupsArray.count>0) {
                    groupText = groupsArray[0];
                }
                
                if (selectedLeague) [[NSUserDefaults standardUserDefaults]setObject:selectedLeague forKey:@"FootballForm:LeagueToCarry:LeagueID"];
                
                [[NSUserDefaults standardUserDefaults]setObject:selectedLeague forKey:@"leagueID"];
                [[NSUserDefaults standardUserDefaults]setObject:leagueName.text forKey:@"leagueName"];
                
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                [segControl setSelectedSegmentIndex:0];
                
                leagueData =  [[FootballFormDB sharedInstance] getLeagueTable:selectedLeague groupText:groupText];
                
                [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(buildTheCells) userInfo:nil repeats:NO];
                
            }
            
            [leagueName setTextColor:[UIColor whiteColor]];
            
        } else {
            
            [leagueName setTextColor:[UIColor colorWithRed:160/255.0f green:178/255.0f blue:192/255.0f alpha:1]];
            
        }

    } else {
        
        cell = (UICollectionViewCell *)[collectionViewy dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
        
        UILabel *leagueName = (UILabel *)[cell viewWithTag:101];
        [leagueName setText:[groupsArray objectAtIndex:indexPath.row]];
        
        int fractionalPage = leaguesCollectionView.contentOffset.x / kSetCellSize;
        
        if (fractionalPage>=indexPath.row) {
            
            if (fractionalPage>=[groupsArray count]) {
                fractionalPage=(int)[groupsArray count]-1;
            }
            
            if (![groupText isEqualToString:[groupsArray objectAtIndex:fractionalPage]]) {
                
                isFilteredLooses = NO;
                isFilteredDraws = NO;
                isFilteredPlayed = NO;
                isFilteredWins = NO;
                isFilteredGoalsFor = NO;
                isFilteredGoalsAgainst = NO;
                isFilteredGoalDifference = NO;
                
                [self getGroups];
                
                groupText = @"";
                
                if (groupsArray.count>0) {
                    groupText = groupsArray[indexPath.row];
                }
                
                
                [segControl setSelectedSegmentIndex:0];
                leagueData =  [[FootballFormDB sharedInstance] getLeagueTable:selectedLeague groupText:groupText];
                
                [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(buildTheCells) userInfo:nil repeats:NO];
                
            }
            
            [leagueName setTextColor:[UIColor whiteColor]];
            
        } else {
            
            [leagueName setTextColor:[UIColor colorWithRed:160/255.0f green:178/255.0f blue:192/255.0f alpha:1]];
            
        }

    }
    
    
    return cell;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (isFilteringByGroups) {
        
        if (scrollView==leaguesCollectionView) {
            
            [UIView animateWithDuration:0.5 animations:^{
                CGFloat pageWidth = kSetCellSize;
                int fractionalPage = round(scrollView.contentOffset.x / pageWidth);
                
                if (fractionalPage>=[groupsArray count]) {
                    fractionalPage=(int)[groupsArray count]-1;
                }
                
                [leaguesCollectionView setContentOffset:CGPointMake(fractionalPage*213, 0)];
                
            }completion:^(BOOL finished) {
                [leaguesCollectionView reloadData];
                
            }];
        }

        
    } else {
        
        if (scrollView==leaguesCollectionView) {
            [UIView animateWithDuration:0.5 animations:^{
                CGFloat pageWidth = kSetCellSize;
                int fractionalPage = round(scrollView.contentOffset.x / pageWidth);
                
                if (fractionalPage>=[leaguesArray count]) {
                    fractionalPage=(int)[leaguesArray count]-1;
                }
                
                [leaguesCollectionView setContentOffset:CGPointMake(fractionalPage*213, 0)];
                
            }completion:^(BOOL finished) {
                [leaguesCollectionView reloadData];
                
            }];
        }
    }
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [_widgetView.layer setCornerRadius:3.0];
    
    whereIWasGroup = 0;
    whereIWasLeagueTable = 0;
    
	// Do any additional setup after loading the view.
    
    
    leaguesCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, (leaguesCollectionView.frame.size.width/2)+425);
    
    [entirePickerview setAlpha:0.0];
    [entirePickerview setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.height, 320)];
    [pickerView setFrame:CGRectMake(pickerView.frame.origin.x, pickerView.frame.origin.y, [[UIScreen mainScreen] bounds].size.height, pickerView.frame.size.height)];

    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {

        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
        
    } else {

        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
    
    if (IS_IPHONE5) {
        
        [selLegV setFrame:CGRectMake(425, selLegV.frame.origin.y, selLegV.frame.size.width, selLegV.frame.size.height)];
        //[leagueTitle setFrame:CGRectMake(185, 13, 233, 21)];

    } else {
        
        [selLegV setFrame:CGRectMake(345, selLegV.frame.origin.y, selLegV.frame.size.width, selLegV.frame.size.height)];
        //[leagueTitle setFrame:CGRectMake(170, 13, 180, 21)];
        [closeButOut setFrame:CGRectMake(479-100, closeButOut.frame.origin.y, closeButOut.frame.size.width, closeButOut.frame.size.height)];
    }
    
    overlayy = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 568, 320)];
    //[overlayy setImage:[UIImage imageNamed:@"iphone5splashscreenrotate.png"]];
    
    [self.view addSubview:overlayy];
    overlayy.hidden=1;
    
    //Listen for NSNotification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(viewWillAppear:)
                                                 name:@"FootballForm:PKWillRefresh"
                                               object:nil];
    
    [_widgetScroll setContentSize:_widgetContentView.frame.size];

}

-(void)viewDidDisappear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"FootballForm:PKWillRefresh" object:nil];
    
}

- (BOOL)prefersStatusBarHidden {
    
    return YES;
}

-(void)viewDidAppear:(BOOL)animated {
    
    if (UIInterfaceOrientationIsPortrait([[UIDevice currentDevice] orientation])) {
        
        [UIView animateWithDuration:0.3 animations:^{
            [leagueTitle setAlpha:0.0];
        }];
        
    } else {
        
        [UIView animateWithDuration:0.3 animations:^{
            [leagueTitle setAlpha:1.0];
        }];
        
    }
    
    if (self.view.frame.size.height==568) {
        [leagueTitle setAlpha:0.0];
    }
    
    if (self.view.frame.size.height==480) {
        [leagueTitle setAlpha:0.0];
    }
    
    [teamNameView setFrame:CGRectMake(0, 93, 206, teamNameView.frame.size.height)];

}

-(NSString *)convertTheDate:(NSString *)theDate currentFormat:(NSString *)currentFormat wantedFormat:(NSString *)wantedFormat {
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:currentFormat];
    NSDate *myDate = [df dateFromString: theDate];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:wantedFormat];
    NSString *dateToReturn = [formatter stringFromDate:myDate];
    
    return dateToReturn;
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"FootballForm:DateExpiringNoOfGamesInApp"]==nil) {
        
        NSDate *date = [NSDate date];
        int daysToAdd = 31;
        NSDate *expiryDate = [date dateByAddingTimeInterval:60*60*24*daysToAdd];
        
        NSString *expiryDateString = [self convertTheDate:[expiryDate description] currentFormat:@"yyyy-MM-dd HH:mm:ss zzz" wantedFormat:@"yyyy-MM-dd HH:mm"];
        
        if (expiryDateString) {
            [[NSUserDefaults standardUserDefaults]setObject:expiryDateString forKey:@"FootballForm:DateExpiringNoOfGamesInApp"];
            [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"FootballForm:CanAccessNoOfGamesInAppThanksToTrial"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
        
    } else {
        
        NSString *expDate = [[NSUserDefaults standardUserDefaults]objectForKey:@"FootballForm:DateExpiringNoOfGamesInApp"];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSDate *dateFromString = [[NSDate alloc] init];
        dateFromString = [dateFormatter dateFromString:expDate];
        
        NSDateComponents *components;
        NSInteger days;
        
        components = [[NSCalendar currentCalendar] components: NSDayCalendarUnit
                                                     fromDate: [NSDate date] toDate: dateFromString options: 0];
        days = [components day];
        
        if (days<=0) {
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"FootballForm:CanAccessNoOfGamesInAppThanksToTrial"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
        
        NSLog(@"%ld DAYS LEFT", (long)days);
        
    }
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"FootballForm:OpenURL"]!=nil) {
        
        NSString *savedURL  = [[NSUserDefaults standardUserDefaults]objectForKey:@"FootballForm:OpenURL"];
        if ([savedURL rangeOfString:@"live-scores"].location == NSNotFound) {
            
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"FootballForm:GoNews"
             object:self];
            
        } else {
            
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"FootballForm:GoToLiveScores"
             object:self];
            
        }
        
        return;
    }
    
    [leaguesCollectionView setContentOffset:CGPointMake(0, 0)];
    
    selectedCountry = [[NSUserDefaults standardUserDefaults]objectForKey:@"countryID"];
    selectedLeague = [[NSUserDefaults standardUserDefaults]objectForKey:@"leagueID"];
    NSString *selectedContinent = [[NSUserDefaults standardUserDefaults]objectForKey:@"continentName"];
    NSString *selectedCountryName;
    
    if (selectedContinent==nil) {
        selectedContinent = @"Europe";
        [[NSUserDefaults standardUserDefaults]setObject:selectedContinent forKey:@"continentName"];
        
    }
    
    //If we have no country then we need to default to England. We perform a loop to get the id
    if (selectedCountry ==nil) {
        
        NSMutableArray *countriesArray = [[FootballFormDB sharedInstance]getCountries:selectedContinent];
        NSString *tempId;
        NSString *tempName;
        for (NSDictionary *dict in countriesArray) {
            
            NSString *name = [dict objectForKey:@"name"];
            NSString *idd = [dict objectForKey:@"id"];
            
            if ([name isEqualToString:@"ENGLAND"]) {
                tempId = idd;
                tempName = [name capitalizedString];
            }
        }
        
        if (tempId==nil) {
            
            //What else do we do here...
            selectedCountry = @"40011";
            selectedCountryName = @"England";
            
        } else {
            
            selectedCountry = tempId;
            selectedCountryName = tempName;
            
        }
        
        [[NSUserDefaults standardUserDefaults]setObject:selectedCountry forKey:@"countryID"];
        [[NSUserDefaults standardUserDefaults]setObject:selectedCountryName forKey:@"countryName"];
        
    }
    
    //If we have no league, we need to get the premier league. We perform a loop to get the id
    if (selectedLeague ==nil) {
        
        NSString *tempId;
        
        for (NSDictionary *dict in leaguesArray) {
            
            NSString *name = [dict objectForKey:@"name"];
            NSString *idd = [dict objectForKey:@"leagueID"];
            
            if ([name isEqualToString:@"Premier League"]) {
                tempId = idd;
            }
        }
        
        if (tempId==nil) {
            
            //What else do we do here...
            selectedLeague = @"41354";
            
        } else {
            
            selectedLeague = tempId;
            
        }
        
        [[NSUserDefaults standardUserDefaults]setObject:@"Premier League" forKey:@"leagueName"];
        [[NSUserDefaults standardUserDefaults]setObject:selectedLeague forKey:@"leagueID"];
        
    }
    
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.createanet.footballform.TodayExtensionSharingDefaults"];
    NSString *selectedCountryID = [sharedDefaults objectForKey:@"SharedDefaults:SelectedCountryID"];
    
    if (!selectedCountryID&&selectedCountry) {
        [sharedDefaults setObject:selectedCountry forKey:@"SharedDefaults:SelectedCountryID"];
        [sharedDefaults synchronize];
    }
    
    [self setUpTabBar];
    [teamNameViewSV setShowsVerticalScrollIndicator:NO];
    [_scrollView setShowsHorizontalScrollIndicator:NO];
    
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"hasSeenWidget"]==nil) {
        
        [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"hasSeenWidget"];
        [[NSUserDefaults standardUserDefaults]synchronize];

        
        [_entireWidgetView setAlpha:1.0];
        self.canDisplayBannerAds = NO;
        
    } else {
        [_entireWidgetView setAlpha:0.0];
        self.canDisplayBannerAds = YES;
    }
    
    BOOL shouldDownloadDB = YES;

    if (shouldDownloadDB) {
    
        NSString *databasePath = [[NSUserDefaults standardUserDefaults]objectForKey:@"pathDatabaseIsSavedIn"];
        
        if (databasePath==nil) {
            
            [self downloadFile:nil];
            
        } else {
            
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSString *dbPath = databasePath;
            BOOL success = [fileManager fileExistsAtPath:dbPath];
            
            if (success) {
                
                [self doWhatShouldBeInViewWillAppear];
                
            } else {
                
                [self downloadFile:nil];
                
            }
        }
        
    } else {
        
        [self doWhatShouldBeInViewWillAppear];

    }
}

-(int)workOutCarriedLeague {
    
    NSString *carriedLeagueID = [[NSUserDefaults standardUserDefaults]objectForKey:@"FootballForm:LeagueToCarry:LeagueID"];
    
    int index = 0;
    
    if (carriedLeagueID) {
        
        for (NSDictionary *leagueNameData in leaguesArray) {
            
            NSString *leagueIDDict = leagueNameData[@"leagueID"];
            if ([leagueIDDict isEqualToString:carriedLeagueID]) {
                return index;
            }
            
            index++;
            
        }
    }
    
    return 0;
    
}


-(void)doWhatShouldBeInViewWillAppear {
    
    leaguesArray = [[FootballFormDB sharedInstance]getLeaguesForLeaguesVC:selectedCountry];
    
    if ([leaguesArray count]==0) {
        leagueData = [NSMutableArray new];
        [noDataView setFrame:CGRectMake(noDataView.frame.origin.x, 44, noDataView.frame.size.width, noDataView.frame.size.height)];
        [noDataView setHidden:NO];
        [segControl setHidden:YES];
        return;
    }
    
    [noDataView setHidden:YES];
    [segControl setHidden:NO];

    int indexx = [self workOutCarriedLeague];
    
    [leaguesCollectionView setContentOffset:CGPointMake(indexx*213, 0)];
    
    selectedLeague = leaguesArray[indexx][@"leagueID"];
    
    [leaguesCollectionView reloadData];
    
    [_scrollView setContentOffset:CGPointMake(0, 0)];
    [teamNameViewSV setContentOffset:CGPointMake(0, 0)];

    [self.view bringSubviewToFront:overlayy];
    
    overlayy.hidden=0;
    
    type = @"ALL";
    
    [self getGroups];
    
    if (groupsArray.count>0) {
        groupText = groupsArray[0];
    }
    
    leagueData =  [[FootballFormDB sharedInstance] getLeagueTable:selectedLeague groupText:groupText];
    
    if ([leagueData count]==0) {
        
        for (UIView *views in _scrollView.subviews) {
            [views removeFromSuperview];
        }
        
        for (UIView *views in teamNameViewSV.subviews) {
            [views removeFromSuperview];
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Leagues" message:@"Sorry, there is no data available for this league." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        //[alert setTag:1992];
        [alert show];
        return;
    }
    
    //[leagueTitle setText:[[NSUserDefaults standardUserDefaults]objectForKey:@"leagueName"]];
    
    leagueTitle.minimumScaleFactor = 0.3;
    leagueTitle.adjustsFontSizeToFitWidth = YES;
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(buildTheCells) userInfo:nil repeats:NO];
    
    if (shouldPromptToPurchaseInApp) {
        shouldPromptToPurchaseInApp = NO;
        [self inAppStuff];
    }
}

-(void)getGroups {
    
    groupsArray = [[FootballFormDB sharedInstance]getGroups:selectedLeague];
    
    if (groupsArray.count>0) {
        [_groupToggleBtn setHidden:NO];
    } else {
        [_groupToggleBtn setHidden:YES];
    }
    
    NSLog(@"%@", groupsArray);
}


- (IBAction)downloadFile:(id)sender {
    
    
    NSMutableArray *mutAr = [[FootballFormDB sharedInstance] getFavouritesInLeagueTableForTempSaving];
    
    if (mutAr.count==0) {
        mutAr = [[NSUserDefaults standardUserDefaults]mutableArrayValueForKey:@"FootballForm:FavouriteTeams"];
    }
    
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    UIImageView *overlay = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 1000, 1000)];
    [overlay setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:overlay];
    
    NSURL *url = [NSURL URLWithString:@"http://footballform.createaclients.co.uk/football_form_database_new.db.zip"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[url lastPathComponent]];
    
    [operation setOutputStream:[NSOutputStream outputStreamToFileAtPath:fullPath append:NO]];
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HUD setMode:MBProgressHUDModeAnnularDeterminate];
    [HUD setLabelText:@"Downloading Data"];
    [HUD setDetailsLabelText:@"Please wait..."];
    [HUD setProgress:0.0];
    [HUD show:YES];
    
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        
        HUD.progress = (float)totalBytesRead / totalBytesExpectedToRead;
        
    }];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [overlay removeFromSuperview];
        
        
        NSError *error;
        NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:fullPath error:&error];
        
        if (error) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"There was a problem download the latest football stats.\n\n%@",[error localizedDescription]] delegate:self cancelButtonTitle:@"Try Again" otherButtonTitles:nil, nil];
            [alert show];
            [alert setTag:129];
            
        } else {
            
            NSNumber *fileSizeNumber = [fileAttributes objectForKey:NSFileSize];
            long long fileSize = [fileSizeNumber longLongValue];
            
            /*
            [[NSUserDefaults standardUserDefaults]setObject:fullPath forKey:@"pathDatabaseIsSavedIn"];
            */
            
            NSDateFormatter *outputDateFormatter = [[NSDateFormatter alloc] init];
            [outputDateFormatter setDateFormat:@"dd-MM-yyyy HH:mm"];
            NSString *todayDate  = [outputDateFormatter stringFromDate:[NSDate date]];
            
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"shouldShowUpdateModal"];
            [[NSUserDefaults standardUserDefaults]setObject:todayDate forKey:@"databaseDownloaded"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
            NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/database"];

            
            if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
                [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
            
            NSString *zipPath = fullPath;
            NSString *destinationPath = dataPath;
            [SSZipArchive unzipFileAtPath:zipPath toDestination:destinationPath];

            [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@/football_form_database_new.db",destinationPath] forKey:@"pathDatabaseIsSavedIn"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            if ([mutAr count]>0) {
                for (NSDictionary *theid in mutAr) {
                    [[FootballFormDB sharedInstance]updateFavouritesWithLeague:@"Y" teamName:[theid objectForKey:@"row_id"] lid:[theid objectForKey:@"league_id"]];
                }
            }

            [self doWhatShouldBeInViewWillAppear];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"There was a problem download the latest football stats.\n\n%@",[error localizedDescription]] delegate:self cancelButtonTitle:@"Try Again" otherButtonTitles:nil, nil];
        [alert show];
        [alert setTag:129];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [overlay removeFromSuperview];
    }];
    
    [operation start];
}

-(void)buildTheCells {
    
    for (UIView *views in _scrollView.subviews) {
        [views removeFromSuperview];
    }
    
    for (UIView *views in teamNameViewSV.subviews) {
        [views removeFromSuperview];
    }
    
    int x = 0;
    int y = 0;
    int index = 0;
    
    
    [_scrollView setContentSize:CGSizeMake(750, ([leagueData count]*36)-4)];
    
    [teamNameViewSV setContentSize:CGSizeMake(191, _scrollView.contentSize.height)];
    
    [teamNameView setFrame:CGRectMake(teamNameView.frame.origin.x, teamNameView.frame.origin.y, 161, teamNameView.frame.size.height)];
    
    [teamNameViewSV setFrame:CGRectMake(teamNameViewSV.frame.origin.x, teamNameViewSV.frame.origin.y, 161, teamNameViewSV.frame.size.height)];
    
    for (NSDictionary *positionDict in leagueData) {
        
        //Time to build the view
        UIView *cellView = [[UIView alloc]initWithFrame:CGRectMake(-72, y, 1052+33, 36)];
        UIView *cellViewForTeam = [[UIView alloc]initWithFrame:CGRectMake(x, y, 160, 36)];
        
        if (index % 2) {
            [cellView setBackgroundColor:[UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:1]];
            [cellViewForTeam setBackgroundColor:[UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:1]];
        } else {
            [cellView setBackgroundColor:[UIColor whiteColor]];
            [cellViewForTeam setBackgroundColor:[UIColor whiteColor]];
        }
        
        [cellView setFrame:CGRectMake(cellView.frame.origin.x, cellView.frame.origin.y, cellView.frame.size.width, 36)];
        
        [_scrollView addSubview:cellView];
        [teamNameViewSV addSubview:cellViewForTeam];
        //UPDATE THE FIELDS HERE SSH
        
        /*UIImageView *slatThree = [[UIImageView alloc]initWithFrame:CGRectMake(339-25, -58, 1, 250)];
        [slatThree setBackgroundColor:[UIColor lightGrayColor]];
        [cellView addSubview:slatThree];
        
        UIImageView *slatFour = [[UIImageView alloc]initWithFrame:CGRectMake(360, -58, 1, 250)];
        [slatFour setBackgroundColor:[UIColor lightGrayColor]];
        [cellView addSubview:slatFour];
        
        UIImageView *slatFive = [[UIImageView alloc]initWithFrame:CGRectMake(475+9, -58, 1, 250)];
        [slatFive setBackgroundColor:[UIColor lightGrayColor]];
        [cellView addSubview:slatFive];
        
        UIImageView *slatSix = [[UIImageView alloc]initWithFrame:CGRectMake(536+4, -58, 1, 250)];
        [slatSix setBackgroundColor:[UIColor lightGrayColor]];
        [cellView addSubview:slatSix];
        
        UIImageView *slatSeven = [[UIImageView alloc]initWithFrame:CGRectMake(597, -58, 1, 250)];
        [slatSeven setBackgroundColor:[UIColor lightGrayColor]];
        [cellView addSubview:slatSeven];
        
        UIImageView *slatEight = [[UIImageView alloc]initWithFrame:CGRectMake(652, -58, 1, 250)];
        [slatEight setBackgroundColor:[UIColor lightGrayColor]];
        [cellView addSubview:slatEight];
        
        UIImageView *slatNine = [[UIImageView alloc]initWithFrame:CGRectMake(711, -58, 1, 250)];
        [slatNine setBackgroundColor:[UIColor lightGrayColor]];
        [cellView addSubview:slatNine];
        
        UIImageView *slatTen = [[UIImageView alloc]initWithFrame:CGRectMake(774, -58, 1, 250)];
        [slatTen setBackgroundColor:[UIColor lightGrayColor]];
        [cellView addSubview:slatTen];
        
        UIImageView *slatEleven = [[UIImageView alloc]initWithFrame:CGRectMake(932, -58, 1, 250)];
        [slatEleven setBackgroundColor:[UIColor lightGrayColor]];
        [cellView addSubview:slatEleven];*/
        
        //Now build everything else
        UILabel *position = [[UILabel alloc]initWithFrame:CGRectMake(2, 7, 30, 21)];
        [position setText:[NSString stringWithFormat:@"%d", index+1]];
        [position setTextColor:[UIColor colorWithRed:23/255.0f green:64/255.0f blue:105/255.0f alpha:1.0]];
        [position setTextAlignment:NSTextAlignmentCenter];
        [position setFont:[UIFont italicSystemFontOfSize:14]];
        [position setAdjustsFontSizeToFitWidth:YES];
        [position setMinimumScaleFactor:0.3];
        [cellViewForTeam addSubview:position];
        
        
        NSString *tn = [[positionDict objectForKey:@"team_name"] capitalizedString];
        
        tn = [tn stringByReplacingOccurrencesOfString:@"Fc" withString:@"FC"];
        tn = [tn stringByReplacingOccurrencesOfString:@"Afc" withString:@"AFC"];
        
        int xy = 80-27-13;
        
        UILabel *teamName = [[UILabel alloc]initWithFrame:CGRectMake(xy, 8, cellViewForTeam.frame.size.width-xy, 21)];
        [teamName setFont:[UIFont systemFontOfSize:14]];
        [teamName setText:[NSString stringWithFormat:@"%@", tn]];
        [cellViewForTeam addSubview:teamName];
        teamName.minimumScaleFactor = 0.3;
        teamName.adjustsFontSizeToFitWidth = YES;
        
        UIImageView *imView = [[UIImageView alloc]initWithFrame:CGRectMake(73, 12, 30, 30)];
        
        NSString *logName = [positionDict objectForKey:@"logoID"];
        logName = [logName stringByReplacingOccurrencesOfString:@"NULL" withString:@"default"];
        [imView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", logName]]];

        [cellViewForTeam addSubview:imView];
        
        UILabel *gamesPlayed = [[UILabel alloc]initWithFrame:CGRectMake(278, 7, 29, 21)];
        [gamesPlayed setFont:[UIFont systemFontOfSize:14]];
        [gamesPlayed setText:[NSString stringWithFormat:@"%@", [positionDict objectForKey:@"total_played_amount"]]];
        [gamesPlayed setTextAlignment:NSTextAlignmentCenter];
        [cellView addSubview:gamesPlayed];
        gamesPlayed.minimumScaleFactor = 0.3;
        gamesPlayed.adjustsFontSizeToFitWidth = YES;
        
        UILabel *gamesWon = [[UILabel alloc]initWithFrame:CGRectMake(384-64, 7, 33, 21)];
        [gamesWon setFont:[UIFont systemFontOfSize:14]];
        [gamesWon setText:[NSString stringWithFormat:@"%@", [positionDict objectForKey:@"total_win"]]];
        [gamesWon setTextAlignment:NSTextAlignmentCenter];
        [cellView addSubview:gamesWon];
        gamesWon.minimumScaleFactor = 0.3;
        gamesWon.adjustsFontSizeToFitWidth = YES;
        
        UILabel *gamesDrawn = [[UILabel alloc]initWithFrame:CGRectMake(443-77, 7, 29, 21)];
        [gamesDrawn setFont:[UIFont systemFontOfSize:14]];
        [gamesDrawn setText:[NSString stringWithFormat:@"%@", [positionDict objectForKey:@"total_draw"]]];
        [gamesDrawn setTextAlignment:NSTextAlignmentCenter];
        [cellView addSubview:gamesDrawn];
        gamesDrawn.minimumScaleFactor = 0.3;
        gamesDrawn.adjustsFontSizeToFitWidth = YES;
        
        UILabel *gamesLost = [[UILabel alloc]initWithFrame:CGRectMake(499-92, 7, 29, 21)];
        [gamesLost setFont:[UIFont systemFontOfSize:14]];
        [gamesLost setText:[NSString stringWithFormat:@"%@", [positionDict objectForKey:@"total_lose"]]];
        [gamesLost setTextAlignment:NSTextAlignmentCenter];
        [cellView addSubview:gamesLost];
        gamesLost.minimumScaleFactor = 0.3;
        gamesLost.adjustsFontSizeToFitWidth = YES;
        
        UIButton *setAsFavouriteButton = [[UIButton alloc]initWithFrame:CGRectMake(938-150, 4, 27, 27)];
        [setAsFavouriteButton setBackgroundColor:[UIColor clearColor]];
                
        if ([[positionDict objectForKey:@"is_favourite"] isEqualToString:@"Y"]) {
            
            [setAsFavouriteButton setBackgroundImage:[UIImage imageNamed:@"iconStarFilled.png"] forState:UIControlStateNormal];
            [setAsFavouriteButton addTarget:self action:@selector(removeFromFavourites:) forControlEvents:UIControlEventTouchUpInside];
            
        } else {
            
            [setAsFavouriteButton setBackgroundImage:[UIImage imageNamed:@"iconStarEmpty.png"] forState:UIControlStateNormal];
            [setAsFavouriteButton addTarget:self action:@selector(addToFavourites:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        
        [setAsFavouriteButton setTag:index];
        [cellView addSubview:setAsFavouriteButton];
        
        //Now sort out Goals For (F) and Goals Against (A)
        
        UILabel *goalsForLabel = [[UILabel alloc]initWithFrame:CGRectMake(556-106, 7, 29, 21)];
        [goalsForLabel setFont:[UIFont systemFontOfSize:14]];
        [goalsForLabel setText:[NSString stringWithFormat:@"%@", [positionDict objectForKey:@"total_goals_for"]]];
        [goalsForLabel setTextAlignment:NSTextAlignmentCenter];
        [cellView addSubview:goalsForLabel];
        goalsForLabel.minimumScaleFactor = 0.3;
        goalsForLabel.adjustsFontSizeToFitWidth = YES;
        
        
        UILabel *goalsAgainstLabel = [[UILabel alloc]initWithFrame:CGRectMake(613-120, 7, 29, 21)];
        [goalsAgainstLabel setFont:[UIFont systemFontOfSize:14]];
        [goalsAgainstLabel setText:[NSString stringWithFormat:@"%@", [positionDict objectForKey:@"total_goals_against"]]];
        [goalsAgainstLabel setTextAlignment:NSTextAlignmentCenter];
        [cellView addSubview:goalsAgainstLabel];
        goalsAgainstLabel.minimumScaleFactor = 0.3;
        goalsAgainstLabel.adjustsFontSizeToFitWidth = YES;
        
        
        UILabel *goalDiff = [[UILabel alloc]initWithFrame:CGRectMake(667-130, 7, 32, 21)];
        [goalDiff setFont:[UIFont systemFontOfSize:14]];
        [goalDiff setText:[NSString stringWithFormat:@"%@", [positionDict objectForKey:@"goal_difference"]]];
        [goalDiff setTextAlignment:NSTextAlignmentCenter];
        [cellView addSubview:goalDiff];
        goalDiff.minimumScaleFactor = 0.3;
        goalDiff.adjustsFontSizeToFitWidth = YES;
        
        
        UILabel *points = [[UILabel alloc]initWithFrame:CGRectMake(725-145, 7, 40, 21)];
        [points setFont:[UIFont systemFontOfSize:14]];
        [points setText:[NSString stringWithFormat:@"%@", [positionDict objectForKey:@"total_points"]]];
        [points setTextAlignment:NSTextAlignmentCenter];
        [cellView addSubview:points];
        points.minimumScaleFactor = 0.3;
        points.adjustsFontSizeToFitWidth = YES;
        
        //Recently this is making things real slow
        [self buildFiveBoxes:cellView teamID:[positionDict objectForKey:@"team_id"] index:index leagueID:[positionDict objectForKey:@"league_id"]];

        index = index +1;
        y = y +36;
        
    }
    
    UIImageView *slatOne = [[UIImageView alloc]initWithFrame:CGRectMake(45-10, 0, 1, 900)];
    [slatOne setBackgroundColor:[UIColor lightGrayColor]];
    [teamNameView addSubview:slatOne];
    
    UIImageView *slat2 = [[UIImageView alloc]initWithFrame:CGRectMake(160, 0, 1, 900)];
    [slat2 setBackgroundColor:[UIColor lightGrayColor]];
    [teamNameView addSubview:slat2];
    
    [self hh];
}

-(void)hh {
    
    overlayy.hidden=1;
    
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [HUD removeFromSuperview];
    
    
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"shouldShowUpdateModal"]isEqualToString:@"YES"]) {
        
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"shouldShowUpdateModal"];
        [self refresh:nil];
        
    }

}
-(void)addToFavourites:(UIButton *)sender {
    
   // [[FootballFormDB sharedInstance]updateFavourites:@"Y" teamName:[[leagueData objectAtIndex:sender.tag]objectForKey:@"team_id"]];
    
    [[FootballFormDB sharedInstance]updateFavouritesWithLeague:@"Y" teamName:[[leagueData objectAtIndex:sender.tag]objectForKey:@"team_id"] lid:[[leagueData objectAtIndex:sender.tag]objectForKey:@"league_id"]];
    
    [[API sharedAPI]setCurrentViewController:self];
    [API addTeamForPushNotifications:[NSString stringWithFormat:@"%@", [[leagueData objectAtIndex:sender.tag]objectForKey:@"team_id"]] complete:^(NSDictionary *userData) {
        
        
    } failed:^(id JSON) {

    }];
    
    [sender setBackgroundImage:[UIImage imageNamed:@"iconStarFilled.png"] forState:UIControlStateNormal];
    [sender removeTarget:self action:@selector(addToFavourites:) forControlEvents:UIControlEventTouchUpInside];
    [sender addTarget:self action:@selector(removeFromFavourites:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)removeFromFavourites:(UIButton *)sender {
    
    [[FootballFormDB sharedInstance]updateFavouritesWithLeague:@"N" teamName:[[leagueData objectAtIndex:sender.tag]objectForKey:@"team_id"] lid:[[leagueData objectAtIndex:sender.tag]objectForKey:@"league_id"]];

    [sender setBackgroundImage:[UIImage imageNamed:@"iconStarEmpty.png"] forState:UIControlStateNormal];
    [sender removeTarget:self action:@selector(removeFromFavourites:) forControlEvents:UIControlEventTouchUpInside];
    [sender addTarget:self action:@selector(addToFavourites:) forControlEvents:UIControlEventTouchUpInside];

    //[[FootballFormDB sharedInstance]updateFavourites:@"N" teamName:[[leagueData objectAtIndex:sender.tag]objectForKey:@"team_id"]];
    
    [[FootballFormDB sharedInstance]updateFavouritesWithLeague:@"N" teamName:[[leagueData objectAtIndex:sender.tag]objectForKey:@"team_id"] lid:[[leagueData objectAtIndex:sender.tag]objectForKey:@"league_id"]];

    
}

-(void)buildFiveBoxes:(UIView *)view teamID:(NSString *)teamID index:(int)index leagueID:(NSString *)leagueID {
    
    NSMutableArray *winLooseDrawArray = [[FootballFormDB sharedInstance]getLast5GameWinsLoosesDraw:teamID leagueID:leagueID];
    
    //Lets do a check to see how many data points we have and show the correct data reliant on that
    
    if ([winLooseDrawArray count]==5) {
        
        //Button One
        UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(786-155, 6, 23, 23)];
        but.layer.cornerRadius = but.frame.size.width/2;
        
        if ([[[winLooseDrawArray objectAtIndex:0] objectForKey:@"wonLostDrew"]isEqualToString:@"WON"]) {
            [but setBackgroundColor:[UIColor colorWithRed:0.486275 green:0.741176 blue:0.290196 alpha:1]];
        } else if ([[[winLooseDrawArray objectAtIndex:0]objectForKey:@"wonLostDrew"]isEqualToString:@"LOST"]) {
            [but setBackgroundColor:[UIColor colorWithRed:0.894118 green:0.043137 blue:0.094118 alpha:1]];
        } else if ([[[winLooseDrawArray objectAtIndex:0]objectForKey:@"wonLostDrew"]isEqualToString:@"DRAW"]) {
            [but setBackgroundColor:[UIColor colorWithRed:0.956863 green:0.807843 blue:0.180392 alpha:1]];
        }
        
        [but addTarget:self action:@selector(showGameResultsModal:) forControlEvents:UIControlEventTouchUpInside];
        [but setTag:[[[winLooseDrawArray objectAtIndex:0]objectForKey:@"matchID"] intValue]];
        
        [view addSubview:but];
        
        //Button 2
        UIButton *but2 = [[UIButton alloc]initWithFrame:CGRectMake(815-155, 6, 23, 23)];
        but2.layer.cornerRadius = but2.frame.size.width/2;
        
        if ([[[winLooseDrawArray objectAtIndex:1]objectForKey:@"wonLostDrew"]isEqualToString:@"WON"]) {
            [but2 setBackgroundColor:[UIColor colorWithRed:0.486275 green:0.741176 blue:0.290196 alpha:1]];
            
        } else if ([[[winLooseDrawArray objectAtIndex:1]objectForKey:@"wonLostDrew"]isEqualToString:@"LOST"]) {
            [but2 setBackgroundColor:[UIColor colorWithRed:0.894118 green:0.043137 blue:0.094118 alpha:1]];
        } else if ([[[winLooseDrawArray objectAtIndex:1]objectForKey:@"wonLostDrew"]isEqualToString:@"DRAW"]) {
            [but2 setBackgroundColor:[UIColor colorWithRed:0.956863 green:0.807843 blue:0.180392 alpha:1]];
        }
        
        [but2 addTarget:self action:@selector(showGameResultsModal:) forControlEvents:UIControlEventTouchUpInside];
        [but2 setTag:[[[winLooseDrawArray objectAtIndex:1]objectForKey:@"matchID"] intValue]];
        
        [view addSubview:but2];
        
        //Button 3
        UIButton *but3 = [[UIButton alloc]initWithFrame:CGRectMake(844-155, 6, 23, 23)];
        but3.layer.cornerRadius = but3.frame.size.width/2;
        if ([[[winLooseDrawArray objectAtIndex:2]objectForKey:@"wonLostDrew"]isEqualToString:@"WON"]) {
            [but3 setBackgroundColor:[UIColor colorWithRed:0.486275 green:0.741176 blue:0.290196 alpha:1]];
            
        } else if ([[[winLooseDrawArray objectAtIndex:2]objectForKey:@"wonLostDrew"]isEqualToString:@"LOST"]) {
            [but3 setBackgroundColor:[UIColor colorWithRed:0.894118 green:0.043137 blue:0.094118 alpha:1]];
        } else if ([[[winLooseDrawArray objectAtIndex:2]objectForKey:@"wonLostDrew"]isEqualToString:@"DRAW"]) {
            [but3 setBackgroundColor:[UIColor colorWithRed:0.956863 green:0.807843 blue:0.180392 alpha:1]];
        }
        
        [but3 addTarget:self action:@selector(showGameResultsModal:) forControlEvents:UIControlEventTouchUpInside];
        [but3 setTag:[[[winLooseDrawArray objectAtIndex:2]objectForKey:@"matchID"] intValue]];
        
        
        [view addSubview:but3];
        
        //Button 4
        UIButton *but4 = [[UIButton alloc]initWithFrame:CGRectMake(873-155, 6, 23, 23)];
        but4.layer.cornerRadius = but4.frame.size.width/2;
        if ([[[winLooseDrawArray objectAtIndex:3]objectForKey:@"wonLostDrew"]isEqualToString:@"WON"]) {
            [but4 setBackgroundColor:[UIColor colorWithRed:0.486275 green:0.741176 blue:0.290196 alpha:1]];
            
        } else if ([[[winLooseDrawArray objectAtIndex:3]objectForKey:@"wonLostDrew"]isEqualToString:@"LOST"]) {
            [but4 setBackgroundColor:[UIColor colorWithRed:0.894118 green:0.043137 blue:0.094118 alpha:1]];
        } else if ([[[winLooseDrawArray objectAtIndex:3]objectForKey:@"wonLostDrew"]isEqualToString:@"DRAW"]) {
            [but4 setBackgroundColor:[UIColor colorWithRed:0.956863 green:0.807843 blue:0.180392 alpha:1]];
        }
        
        [but4 addTarget:self action:@selector(showGameResultsModal:) forControlEvents:UIControlEventTouchUpInside];
        [but4 setTag:[[[winLooseDrawArray objectAtIndex:3]objectForKey:@"matchID"] intValue]];
        
        [view addSubview:but4];
        
        UIButton *but5 = [[UIButton alloc]initWithFrame:CGRectMake(902-155, 6, 23, 23)];
        but5.layer.cornerRadius = but5.frame.size.width/2;
        if ([[[winLooseDrawArray objectAtIndex:4]objectForKey:@"wonLostDrew"]isEqualToString:@"WON"]) {
            [but5 setBackgroundColor:[UIColor colorWithRed:0.486275 green:0.741176 blue:0.290196 alpha:1]];
            
        } else if ([[[winLooseDrawArray objectAtIndex:4]objectForKey:@"wonLostDrew"]isEqualToString:@"LOST"]) {
            [but5 setBackgroundColor:[UIColor colorWithRed:0.894118 green:0.043137 blue:0.094118 alpha:1]];
        } else if ([[[winLooseDrawArray objectAtIndex:4]objectForKey:@"wonLostDrew"]isEqualToString:@"DRAW"]) {
            [but5 setBackgroundColor:[UIColor colorWithRed:0.956863 green:0.807843 blue:0.180392 alpha:1]];
        }
        
        [but5 addTarget:self action:@selector(showGameResultsModal:) forControlEvents:UIControlEventTouchUpInside];
        [but5 setTag:[[[winLooseDrawArray objectAtIndex:4]objectForKey:@"matchID"] intValue]];

        [view addSubview:but5];
        
    } else if ([winLooseDrawArray count]==4) {
        
        //Button One
        UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(786-155, 6, 23, 23)];
        but.layer.cornerRadius = but.frame.size.width/2;
        if ([[[winLooseDrawArray objectAtIndex:0]objectForKey:@"wonLostDrew"]isEqualToString:@"WON"]) {
            [but setBackgroundColor:[UIColor colorWithRed:0.486275 green:0.741176 blue:0.290196 alpha:1]];
            
        } else if ([[[winLooseDrawArray objectAtIndex:0]objectForKey:@"wonLostDrew"]isEqualToString:@"LOST"]) {
            [but setBackgroundColor:[UIColor colorWithRed:0.894118 green:0.043137 blue:0.094118 alpha:1]];
        } else if ([[[winLooseDrawArray objectAtIndex:0]objectForKey:@"wonLostDrew"]isEqualToString:@"DRAW"]) {
            [but setBackgroundColor:[UIColor colorWithRed:0.956863 green:0.807843 blue:0.180392 alpha:1]];
        }
        
        [but addTarget:self action:@selector(showGameResultsModal:) forControlEvents:UIControlEventTouchUpInside];
        [but setTag:[[[winLooseDrawArray objectAtIndex:0]objectForKey:@"matchID"] intValue]];
        
        [view addSubview:but];
        
        //Button 2
        UIButton *but2 = [[UIButton alloc]initWithFrame:CGRectMake(815-155, 6, 23, 23)];
        but2.layer.cornerRadius = but2.frame.size.width/2;
        
        if ([[[winLooseDrawArray objectAtIndex:1]objectForKey:@"wonLostDrew"]isEqualToString:@"WON"]) {
            [but2 setBackgroundColor:[UIColor colorWithRed:0.486275 green:0.741176 blue:0.290196 alpha:1]];
            
        } else if ([[[winLooseDrawArray objectAtIndex:1]objectForKey:@"wonLostDrew"]isEqualToString:@"LOST"]) {
            [but2 setBackgroundColor:[UIColor colorWithRed:0.894118 green:0.043137 blue:0.094118 alpha:1]];
        } else if ([[[winLooseDrawArray objectAtIndex:1]objectForKey:@"wonLostDrew"]isEqualToString:@"DRAW"]) {
            [but2 setBackgroundColor:[UIColor colorWithRed:0.956863 green:0.807843 blue:0.180392 alpha:1]];
        }
        
        [but2 addTarget:self action:@selector(showGameResultsModal:) forControlEvents:UIControlEventTouchUpInside];
        [but2 setTag:[[[winLooseDrawArray objectAtIndex:1]objectForKey:@"matchID"] intValue]];
        
        [view addSubview:but2];
        
        //Button 3
        UIButton *but3 = [[UIButton alloc]initWithFrame:CGRectMake(844-155, 6, 23, 23)];
        but3.layer.cornerRadius = but3.frame.size.width/2;
        if ([[[winLooseDrawArray objectAtIndex:2]objectForKey:@"wonLostDrew"]isEqualToString:@"WON"]) {
            [but3 setBackgroundColor:[UIColor colorWithRed:0.486275 green:0.741176 blue:0.290196 alpha:1]];
            
        } else if ([[[winLooseDrawArray objectAtIndex:2]objectForKey:@"wonLostDrew"]isEqualToString:@"LOST"]) {
            [but3 setBackgroundColor:[UIColor colorWithRed:0.894118 green:0.043137 blue:0.094118 alpha:1]];
        } else if ([[[winLooseDrawArray objectAtIndex:2]objectForKey:@"wonLostDrew"]isEqualToString:@"DRAW"]) {
            [but3 setBackgroundColor:[UIColor colorWithRed:0.956863 green:0.807843 blue:0.180392 alpha:1]];
        }
        
        [but3 addTarget:self action:@selector(showGameResultsModal:) forControlEvents:UIControlEventTouchUpInside];
        [but3 setTag:[[[winLooseDrawArray objectAtIndex:2]objectForKey:@"matchID"] intValue]];
        
        [view addSubview:but3];
        
        //Button 4
        UIButton *but4 = [[UIButton alloc]initWithFrame:CGRectMake(873-155, 6, 23, 23)];
        but4.layer.cornerRadius = but4.frame.size.width/2;
        if ([[[winLooseDrawArray objectAtIndex:3]objectForKey:@"wonLostDrew"]isEqualToString:@"WON"]) {
            [but4 setBackgroundColor:[UIColor colorWithRed:0.486275 green:0.741176 blue:0.290196 alpha:1]];
            
        } else if ([[[winLooseDrawArray objectAtIndex:3]objectForKey:@"wonLostDrew"]isEqualToString:@"LOST"]) {
            [but4 setBackgroundColor:[UIColor colorWithRed:0.894118 green:0.043137 blue:0.094118 alpha:1]];
        } else if ([[[winLooseDrawArray objectAtIndex:3]objectForKey:@"wonLostDrew"]isEqualToString:@"DRAW"]) {
            [but4 setBackgroundColor:[UIColor colorWithRed:0.956863 green:0.807843 blue:0.180392 alpha:1]];
        }
        
        [but4 addTarget:self action:@selector(showGameResultsModal:) forControlEvents:UIControlEventTouchUpInside];
        [but4 setTag:[[[winLooseDrawArray objectAtIndex:3]objectForKey:@"matchID"] intValue]];
        
        [view addSubview:but4];
        
    } else if ([winLooseDrawArray count]==3) {
        
        //Button One
        UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(786-155, 6, 23, 23)];
        but.layer.cornerRadius = but.frame.size.width/2;
        if ([[[winLooseDrawArray objectAtIndex:0]objectForKey:@"wonLostDrew"]isEqualToString:@"WON"]) {
            [but setBackgroundColor:[UIColor colorWithRed:0.486275 green:0.741176 blue:0.290196 alpha:1]];
            
        } else if ([[[winLooseDrawArray objectAtIndex:0]objectForKey:@"wonLostDrew"]isEqualToString:@"LOST"]) {
            [but setBackgroundColor:[UIColor colorWithRed:0.894118 green:0.043137 blue:0.094118 alpha:1]];
        } else if ([[[winLooseDrawArray objectAtIndex:0]objectForKey:@"wonLostDrew"]isEqualToString:@"DRAW"]) {
            [but setBackgroundColor:[UIColor colorWithRed:0.956863 green:0.807843 blue:0.180392 alpha:1]];
        }
        
        [but addTarget:self action:@selector(showGameResultsModal:) forControlEvents:UIControlEventTouchUpInside];
        [but setTag:[[[winLooseDrawArray objectAtIndex:0]objectForKey:@"matchID"] intValue]];
        
        [view addSubview:but];
        
        //Button 2
        UIButton *but2 = [[UIButton alloc]initWithFrame:CGRectMake(815-155, 6, 23, 23)];
        but2.layer.cornerRadius = but2.frame.size.width/2;
        if ([[[winLooseDrawArray objectAtIndex:1]objectForKey:@"wonLostDrew"]isEqualToString:@"WON"]) {
            [but2 setBackgroundColor:[UIColor colorWithRed:0.486275 green:0.741176 blue:0.290196 alpha:1]];
            
        } else if ([[[winLooseDrawArray objectAtIndex:1]objectForKey:@"wonLostDrew"]isEqualToString:@"LOST"]) {
            [but2 setBackgroundColor:[UIColor colorWithRed:0.894118 green:0.043137 blue:0.094118 alpha:1]];
        } else if ([[[winLooseDrawArray objectAtIndex:1]objectForKey:@"wonLostDrew"]isEqualToString:@"DRAW"]) {
            [but2 setBackgroundColor:[UIColor colorWithRed:0.956863 green:0.807843 blue:0.180392 alpha:1]];
        }
        
        [but2 addTarget:self action:@selector(showGameResultsModal:) forControlEvents:UIControlEventTouchUpInside];
        [but2 setTag:[[[winLooseDrawArray objectAtIndex:1]objectForKey:@"matchID"] intValue]];
        [view addSubview:but2];
        
        //Button 3
        UIButton *but3 = [[UIButton alloc]initWithFrame:CGRectMake(844-155, 6, 23, 23)];
        but3.layer.cornerRadius = but3.frame.size.width/2;
        if ([[[winLooseDrawArray objectAtIndex:2]objectForKey:@"wonLostDrew"]isEqualToString:@"WON"]) {
            [but3 setBackgroundColor:[UIColor colorWithRed:0.486275 green:0.741176 blue:0.290196 alpha:1]];
            
        } else if ([[[winLooseDrawArray objectAtIndex:2]objectForKey:@"wonLostDrew"]isEqualToString:@"LOST"]) {
            [but3 setBackgroundColor:[UIColor colorWithRed:0.894118 green:0.043137 blue:0.094118 alpha:1]];
        } else if ([[[winLooseDrawArray objectAtIndex:2]objectForKey:@"wonLostDrew"]isEqualToString:@"DRAW"]) {
            [but3 setBackgroundColor:[UIColor colorWithRed:0.956863 green:0.807843 blue:0.180392 alpha:1]];
        }
        
        [but3 addTarget:self action:@selector(showGameResultsModal:) forControlEvents:UIControlEventTouchUpInside];
        [but3 setTag:[[[winLooseDrawArray objectAtIndex:2]objectForKey:@"matchID"] intValue]];
        
        [view addSubview:but3];
        
    } else if ([winLooseDrawArray count]==2) {
        
        //Button One
        UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(786-155, 6, 23, 23)];
        but.layer.cornerRadius = but.frame.size.width/2;
        if ([[[winLooseDrawArray objectAtIndex:0]objectForKey:@"wonLostDrew"]isEqualToString:@"WON"]) {
            [but setBackgroundColor:[UIColor colorWithRed:0.486275 green:0.741176 blue:0.290196 alpha:1]];
            
        } else if ([[[winLooseDrawArray objectAtIndex:0]objectForKey:@"wonLostDrew"]isEqualToString:@"LOST"]) {
            [but setBackgroundColor:[UIColor colorWithRed:0.894118 green:0.043137 blue:0.094118 alpha:1]];
        } else if ([[[winLooseDrawArray objectAtIndex:0]objectForKey:@"wonLostDrew"]isEqualToString:@"DRAW"]) {
            [but setBackgroundColor:[UIColor colorWithRed:0.956863 green:0.807843 blue:0.180392 alpha:1]];
        }
        [but addTarget:self action:@selector(showGameResultsModal:) forControlEvents:UIControlEventTouchUpInside];
        [but setTag:[[[winLooseDrawArray objectAtIndex:0]objectForKey:@"matchID"] intValue]];
        [view addSubview:but];
        
        //Button 2
        UIButton *but2 = [[UIButton alloc]initWithFrame:CGRectMake(815-155, 6, 23, 23)];
        but2.layer.cornerRadius = but2.frame.size.width/2;
        if ([[[winLooseDrawArray objectAtIndex:1]objectForKey:@"wonLostDrew"]isEqualToString:@"WON"]) {
            [but2 setBackgroundColor:[UIColor colorWithRed:0.486275 green:0.741176 blue:0.290196 alpha:1]];
            
        } else if ([[[winLooseDrawArray objectAtIndex:1]objectForKey:@"wonLostDrew"]isEqualToString:@"LOST"]) {
            [but2 setBackgroundColor:[UIColor colorWithRed:0.894118 green:0.043137 blue:0.094118 alpha:1]];
        } else if ([[[winLooseDrawArray objectAtIndex:1]objectForKey:@"wonLostDrew"]isEqualToString:@"DRAW"]) {
            [but2 setBackgroundColor:[UIColor colorWithRed:0.956863 green:0.807843 blue:0.180392 alpha:1]];
        }
        
        [but2 addTarget:self action:@selector(showGameResultsModal:) forControlEvents:UIControlEventTouchUpInside];
        [but2 setTag:[[[winLooseDrawArray objectAtIndex:1]objectForKey:@"matchID"] intValue]];
        [view addSubview:but2];
        
    } else if ([winLooseDrawArray count]==1) {
        
        //Button One
        UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(786-155, 6, 23, 23)];
        but.layer.cornerRadius = but.frame.size.width/2;
        if ([[[winLooseDrawArray objectAtIndex:0]objectForKey:@"wonLostDrew"]isEqualToString:@"WON"]) {
            [but setBackgroundColor:[UIColor colorWithRed:0.486275 green:0.741176 blue:0.290196 alpha:1]];
            
        } else if ([[[winLooseDrawArray objectAtIndex:0]objectForKey:@"wonLostDrew"]isEqualToString:@"LOST"]) {
            [but setBackgroundColor:[UIColor colorWithRed:0.894118 green:0.043137 blue:0.094118 alpha:1]];
        } else if ([[[winLooseDrawArray objectAtIndex:0]objectForKey:@"wonLostDrew"]isEqualToString:@"DRAW"]) {
            [but setBackgroundColor:[UIColor colorWithRed:0.956863 green:0.807843 blue:0.180392 alpha:1]];
        }
        [but addTarget:self action:@selector(showGameResultsModal:) forControlEvents:UIControlEventTouchUpInside];
        [but setTag:[[[winLooseDrawArray objectAtIndex:0]objectForKey:@"matchID"] intValue]];
        
        [view addSubview:but];
        
    }
}


-(void)showGameResultsModal:(UIButton *)sender {
    
    NSMutableArray *mutArray =[[FootballFormDB sharedInstance]getFixtureDataFromFixtureID:[NSString stringWithFormat:@"%ld", (long)sender.tag]];
    
    NSString *teamHomeName = [[mutArray objectAtIndex:0] objectForKey:@"teamHomeName"];
    NSString *teamAwayName = [[mutArray objectAtIndex:0] objectForKey:@"teamAwayName"];
    
    teamHomeName = [teamHomeName capitalizedString];
    teamAwayName = [teamAwayName capitalizedString];
    
    teamAwayName = [teamAwayName stringByReplacingOccurrencesOfString:@" Fc" withString:@" FC"];
    teamHomeName = [teamHomeName stringByReplacingOccurrencesOfString:@" Fc" withString:@" FC"];

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@ v %@",teamHomeName, teamAwayName] message:[NSString stringWithFormat:@"%@ - %@",[[mutArray objectAtIndex:0] objectForKey:@"teamHomeScore"], [[mutArray objectAtIndex:0] objectForKey:@"teamAwayScore"]] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];

}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView==leaguesCollectionView) {
        
        CGFloat scrollSpeed = scrollView.contentOffset.x - previousScrollViewYOffset;
        previousScrollViewYOffset = scrollView.contentOffset.x;
        
        if (scrollSpeed >= 0.5 && scrollSpeed <1.5) {
            
            if (!hasReloaded) {
                hasReloaded = YES;
                [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(resetReloaded) userInfo:nil repeats:NO];
                [leaguesCollectionView reloadData];
            }
        }
        
    }
    
    if (scrollView==_scrollView) {
        _titleView.frame=CGRectMake((-_scrollView.contentOffset.x)-36, _titleView.frame.origin.y, _titleView.frame.size.width+36, _titleView.frame.size.height);
        teamNameViewSV.contentOffset=CGPointMake(teamNameViewSV.contentOffset.x, _scrollView.contentOffset.y);
    }
    if (scrollView==teamNameViewSV) {
        _scrollView.contentOffset = CGPointMake(_scrollView.contentOffset.x, teamNameViewSV.contentOffset.y);
    }
    
}

-(void)resetReloaded {
    hasReloaded = NO;
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
    [_tabBar setSelectedItem:Leagues];
    
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    
    
    if (item.tag==1) {
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"FootballForm:GoToFixtures"
         object:self];
        
    } else if (item.tag==2) {
        /*
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"FootballForm:GoToLeagues"
         object:self];
        */
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

}

- (IBAction)groupToggleAction:(id)sender {
    
    if (!isFilteringByGroups) {
        isFilteringByGroups = YES;
        whereIWasLeagueTable = leaguesCollectionView.contentOffset.x;
        [leaguesCollectionView setContentOffset:CGPointMake(whereIWasGroup, 0)];

    } else {
        isFilteringByGroups = NO;
        whereIWasGroup = leaguesCollectionView.contentOffset.x;
        [leaguesCollectionView setContentOffset:CGPointMake(whereIWasLeagueTable, 0)];

    }
    
    [leaguesCollectionView reloadData];
    
}

- (IBAction)invokePeek:(id)sender {
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    PKRevealController *revealController = (PKRevealController *) appDelegate.window.rootViewController;
    [revealController showViewController:revealController.leftViewController];
    
}

- (IBAction)refresh:(id)sender {
    
    NSString *hasAsked = [[NSUserDefaults standardUserDefaults]objectForKey:@"FootballForm:HasAsked"];
    
    if (!hasAsked) {
        
        NSString *hasPaid = [[NSUserDefaults standardUserDefaults]objectForKey:@"hasBroughtInAppPurchase"];
        
        if (![hasPaid isEqualToString:@"YES"]) {
        
            NSString *openCount = [[NSUserDefaults standardUserDefaults] objectForKey:@"FootballForm:OpenCount"];
            
            if (!openCount) {
                openCount = @"1";
            } else {
                openCount = [NSString stringWithFormat:@"%d", openCount.intValue+1];
            }
            
            if ([openCount isEqualToString:@"3"]) {
                shouldPromptToPurchaseInApp = YES;
                [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"FootballForm:HasAsked"];
            }
            
            [[NSUserDefaults standardUserDefaults]setObject:openCount forKey:@"FootballForm:OpenCount"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
        }
    }
    
    NSString *dbDownloaed = [[NSUserDefaults standardUserDefaults]objectForKey:@"databaseDownloaded"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm"];
    
    NSDate *dateDownloaded = [[NSDate alloc] init];
    dateDownloaded = [dateFormatter dateFromString:dbDownloaed];
    
    
    dbDownloaed = [dbDownloaed stringByReplacingOccurrencesOfString:@" " withString:@" at "];
    
    NSDateFormatter *outputDateFormatter = [[NSDateFormatter alloc] init];
    [outputDateFormatter setDateFormat:@"dd-MM-yyyy HH:mm"];
    NSString *todayDate  = [outputDateFormatter stringFromDate:[NSDate date]];
    
    
    NSDate *now = [[NSDate alloc] init];
    now = [dateFormatter dateFromString:todayDate];
    
    unsigned flags = NSMinuteCalendarUnit;
    NSDateComponents *difference = [[NSCalendar currentCalendar] components:flags fromDate:dateDownloaded toDate:now options:0];
    
    int minuteDiff = [difference minute];

    if (dateDownloaded==nil||now==nil) {
        
        UIAlertView *alertV = [[UIAlertView alloc]
                               initWithTitle:@"Update" message:[NSString stringWithFormat:@"Would you like to refresh the football data now? Last refreshed on %@", dbDownloaed] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Cancel", @"Update", nil];
        [alertV setTag:1091];
        [alertV show];
        
    } else if (minuteDiff > 30) {
        
        UIAlertView *alertV = [[UIAlertView alloc]
                               initWithTitle:@"Update" message:[NSString stringWithFormat:@"Would you like to refresh the football data now? Last refreshed on %@", dbDownloaed] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Cancel", @"Update", nil];
        [alertV setTag:1091];
        [alertV show];
        
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag==101101) {
        
        if (buttonIndex == 1) {
            [self makeInAppPurchase];
        }
        
    } else if (alertView.tag==1992) {
        
        [self invokePeek:nil];
        
    } else if (alertView.tag==1091) {
        
        if (buttonIndex == 1) {
        
            [self downloadFile:nil];
        
        } else {
            
            if (shouldPromptToPurchaseInApp) {
                shouldPromptToPurchaseInApp = NO;
                [self inAppStuff];
            }
        }
        
    } else if (alertView.tag==129) {
        
        [self downloadFile:nil];
        
    }
}

-(void)makeInAppPurchase {
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HUD setMode:MBProgressHUDModeIndeterminate];
    [HUD setDetailsLabelText:@"Loading..."];
    [HUD show:YES];
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(makeRequest) userInfo:nil repeats:NO];

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
                
                [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(hideHud) userInfo:nil repeats:NO];
                
                break;
                
            case SKPaymentTransactionStateRestored:
                
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                
                [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"hasBroughtInAppPurchase"];
                [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(hideHud) userInfo:nil repeats:NO];
                
                break;
                
            case SKPaymentTransactionStateFailed:
                
                if (transaction.error.code != SKErrorPaymentCancelled) {
                    NSLog(@"Error payment cancelled");
                } else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"In App Purchase" message:@"There was a problem with your purchase. Please try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [alert show];
                }
                
                [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(hideHud) userInfo:nil repeats:NO];
                
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                
                
                break;
                
            default:
                break;
        }
    }
}


-(void)inAppStuff {
    
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"In App Purchase" message:@"Get the best out of Football Form by purchasing the ability to view a larger range of previous stats!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"No Thanks", @"Purchase!", nil];
        [alert setTag:101101];
        [alert show];
    
}

-(void)refreshData {
    
}

- (IBAction)segChanged:(id)sender {
    if (segControl.selectedSegmentIndex==0) {
        
        type = @"ALL";
        
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [HUD setLabelText:@"Loading"];
        [HUD setDetailsLabelText:@"Please wait..."];
        [HUD show:YES];
        
        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(clall) userInfo:nil repeats:NO];

    } else if (segControl.selectedSegmentIndex==1) {
        
        type = @"HOME";
        [self clearHomeFilter];
        
    } else if (segControl.selectedSegmentIndex==2) {
        
        type = @"AWAY";
        [self clearAwayFilter];
        
    }
}

-(void)clall {
    
    leagueData =  [[FootballFormDB sharedInstance] getLeagueTable:selectedLeague groupText:groupText];
    [self buildTheCells];
    
}

- (IBAction)hidePickerView:(id)sender {
    
    [UIView animateWithDuration:0.7 animations:^{
        [entirePickerview setAlpha:0.0];
    }];
    
}

- (IBAction)showPicker:(id)sender {
    
    [pickerView reloadAllComponents];
    
    int index = 0;
    
    for (NSDictionary *dict in leagueDivisionData) {
        
        if ([[dict objectForKey:@"name"]isEqualToString:leagueTitle.text]) {
            
            [pickerView selectRow:index inComponent:0 animated:NO];
            selectedLeague = [dict objectForKey:@"leagueID"];

        }
        
        index++;
    }
    
    [UIView animateWithDuration:0.7 animations:^{
        [entirePickerview setAlpha:1.0];
    }];
}

- (IBAction)filterByGamesPlayed:(id)sender {
    
    //HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //[HUD setLabelText:@"Loading"];
    //[HUD setDetailsLabelText:@"Please wait..."];
    //[HUD show:YES];
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(gamPl) userInfo:nil repeats:NO];


}

-(void)gamPl {
    
    if ([type isEqualToString:@"ALL"]) {
        
        leagueData = [NSMutableArray new];
        
        if (isFilteredPlayed) {
            
            [self clearFilter:nil];
            
        } else {
            
            leagueData =  [[FootballFormDB sharedInstance] getLeagueTableFilterByGamesPlayed:selectedLeague groupText:groupText];
            
            if (leagueData != nil) {
                
                [self buildTheCells];
                isFilteredPlayed = YES;
                
            }
            
        }
        
    }  else if ([type isEqualToString:@"HOME"]) {
        
        if (isFilteredByHomePlayed) {
            
            [self clearHomeFilter];
            
        } else {
            
            //Do league stuff here
            
            [self clearHomeFilter];
            isFilteredByHomePlayed = YES;
            
            NSArray * sorted2 = [leagueData sortedArrayUsingComparator: ^(id first, id second) {
                return - [([(NSDictionary *)first objectForKey:@"total_played_amount"]) compare:([(NSDictionary *)second objectForKey:@"total_played_amount"]) options: NSNumericSearch];
                
            }];
            
            leagueData = [sorted2 copy];
            
            [self buildTheCells];
            
        }
        
    } else if ([type isEqualToString:@"AWAY"]) {
        
        if (isFilteredByAwayPlayed) {
            [self clearAwayFilter];
        } else {
            //do league stuff here
            
            [self clearAwayFilter];
            isFilteredByAwayPlayed = YES;
            
            NSArray * sorted2 = [leagueData sortedArrayUsingComparator: ^(id first, id second) {
                return - [([(NSDictionary *)first objectForKey:@"total_played_amount"]) compare:([(NSDictionary *)second objectForKey:@"total_played_amount"]) options: NSNumericSearch];
                
            }];
            
            leagueData = [sorted2 copy];
            
            [self buildTheCells];
        }
        
    }
    
}

- (IBAction)filterByGamesLost:(id)sender {
    
    //HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //[HUD setLabelText:@"Loading"];
    //[HUD setDetailsLabelText:@"Please wait..."];
    //[HUD show:YES];
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(filGLL) userInfo:nil repeats:NO];
    
}

-(void)filGLL {
    
    if ([type isEqualToString:@"ALL"]) {
        
        leagueData = [NSMutableArray new];
        
        if (isFilteredLooses) {
            
            [self clearFilter:nil];
            
        } else {
            
            leagueData =  [[FootballFormDB sharedInstance] getLeagueTableFilterByGamesLost:selectedLeague groupText:groupText];
            
            if (leagueData != nil) {
                
                [self buildTheCells];
                isFilteredLooses = YES;
                
            }
            
        }
        
    } else if ([type isEqualToString:@"HOME"]) {
        
        if (isFilteredByHomeLooses) {
            [self clearHomeFilter];
        } else {
            //do league stuff here
            isFilteredByHomeLooses = YES;
            
            leagueData = [[FootballFormDB sharedInstance]getLeagueTableHome:selectedLeague orderBy:@"home_lose" groupText:groupText];
            [self buildTheCells];
            
        }
        
        
    } else if ([type isEqualToString:@"AWAY"]) {
        
        if (isFilteredByAwayLooses) {
            [self clearAwayFilter];
        } else {
            //do league stuff here
            isFilteredByAwayLooses = YES;
            
            leagueData = [[FootballFormDB sharedInstance]getLeagueTableAway:selectedLeague orderBy:@"away_lose" groupText:groupText];
            [self buildTheCells];
            
        }
        
    }

}


- (IBAction)filterByWins:(id)sender {
    
    //HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //[HUD setLabelText:@"Loading"];
    //[HUD setDetailsLabelText:@"Please wait..."];
   // [HUD show:YES];
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(filWi) userInfo:nil repeats:NO];
    
}


-(void)filWi {
    
    if ([type isEqualToString:@"ALL"]) {
        
        leagueData = [NSMutableArray new];
        
        if (isFilteredWins) {
            
            [self clearFilter:nil];
            
        } else {
            
            leagueData =  [[FootballFormDB sharedInstance] getLeagueTableFilterByWinner:selectedLeague groupText:groupText];
            
            if (leagueData != nil) {
                
                [self buildTheCells];
                isFilteredWins = YES;
            }
        }
        
    }else if ([type isEqualToString:@"HOME"]) {
        
        if (isFilteredByHomeWins) {
            [self clearHomeFilter];
        } else {
            //do league stuff here
            isFilteredByHomeWins = YES;
            
            leagueData = [[FootballFormDB sharedInstance]getLeagueTableHome:selectedLeague orderBy:@"home_win" groupText:groupText];
            [self buildTheCells];
            
        }
        
        
    } else if ([type isEqualToString:@"AWAY"]) {
        
        if (isFilteredByAwayWins) {
            [self clearAwayFilter];
        } else {
            //do league stuff here
            isFilteredByAwayWins = YES;
            
            leagueData = [[FootballFormDB sharedInstance]getLeagueTableAway:selectedLeague orderBy:@"away_win" groupText:groupText];
            [self buildTheCells];
            
        }
        
    }
}

- (IBAction)filterByDraws:(id)sender {
    
    //HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //[HUD setLabelText:@"Loading"];
    //[HUD setDetailsLabelText:@"Please wait..."];
    //[HUD show:YES];
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(filDr) userInfo:nil repeats:NO];
    
    

}


-(void)filDr {
    
    if ([type isEqualToString:@"ALL"]) {
        
        
        leagueData = [NSMutableArray new];
        
        if (isFilteredDraws) {
            
            [self clearFilter:nil];
            
        } else {
            
            leagueData =  [[FootballFormDB sharedInstance] getLeagueTableFilterByDraw:selectedLeague groupText:groupText];
            
            
            if (leagueData != nil) {
                
                [self buildTheCells];
                isFilteredDraws = YES;
                
            }
            
        }
        
    }else if ([type isEqualToString:@"HOME"]) {
        
        if (isFilteredByHomeDraws) {
            [self clearHomeFilter];
        } else {
            //do league stuff here
            isFilteredByHomeDraws = YES;
            
            leagueData = [[FootballFormDB sharedInstance]getLeagueTableHome:selectedLeague orderBy:@"home_draw" groupText:groupText];
            [self buildTheCells];
            
        }
        
        
    } else if ([type isEqualToString:@"AWAY"]) {
        
        if (isFilteredByAwayDraws) {
            [self clearAwayFilter];
        } else {
            //do league stuff here
            isFilteredByAwayDraws = YES;
            
            leagueData = [[FootballFormDB sharedInstance]getLeagueTableAway:selectedLeague orderBy:@"away_draw" groupText:groupText];
            [self buildTheCells];
            
        }
        
    }

    
}

- (IBAction)filterByLosses:(id)sender {
    
    //HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //[HUD setLabelText:@"Loading"];
    //[HUD setDetailsLabelText:@"Please wait..."];
    //[HUD show:YES];
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(filLos) userInfo:nil repeats:NO];
    

}


-(void)filLos {
    
    if ([type isEqualToString:@"ALL"]) {
        
        leagueData = [NSMutableArray new];
        
        if (isFilteredLooses) {
            
            leagueData =  [[FootballFormDB sharedInstance] getLeagueTable:selectedLeague groupText:groupText];
            
            if (leagueData != nil) {
                
                [self buildTheCells];
                isFilteredLooses = NO;
                
            }
            
            
        } else {
            
            leagueData =  [[FootballFormDB sharedInstance] getLeagueTableFilterByGamesLost:selectedLeague groupText:groupText];
            
            if (leagueData != nil) {
                
                [self buildTheCells];
                isFilteredLooses = YES;
                
            }
            
        }
        
    }else if ([type isEqualToString:@"HOME"]) {
        
        if (isFilteredByHomeLooses) {
            [self clearHomeFilter];
        } else {
            //do league stuff here
            isFilteredByHomeLooses = YES;
            
            leagueData = [[FootballFormDB sharedInstance]getLeagueTableHome:selectedLeague orderBy:@"home_lose" groupText:groupText];
            [self buildTheCells];
            
        }
        
    } else if ([type isEqualToString:@"AWAY"]) {
        
        if (isFilteredByAwayLooses) {
            [self clearAwayFilter];
        } else {
            //do league stuff here
            isFilteredByAwayLooses = YES;
            
            leagueData = [[FootballFormDB sharedInstance]getLeagueTableAway:selectedLeague orderBy:@"away_lose" groupText:groupText];
            [self buildTheCells];
            
        }
    }
}

- (IBAction)filterByGoalsFor:(id)sender {
    
    //HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //[HUD setLabelText:@"Loading"];
    //[HUD setDetailsLabelText:@"Please wait..."];
    //[HUD show:YES];
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(filGF) userInfo:nil repeats:NO];
    
}


-(void)filGF {
    if ([type isEqualToString:@"ALL"]) {
        
        
        leagueData = [NSMutableArray new];
        
        if (isFilteredGoalsFor) {
            
            [self clearFilter:nil];
            
        } else {
            
            leagueData =  [[FootballFormDB sharedInstance] getLeagueTableFilterByGoalsFor:selectedLeague groupText:groupText];
            
            if (leagueData != nil) {
                
                [self buildTheCells];
                isFilteredGoalsFor = YES;
                
            }
            
        }
    }else if ([type isEqualToString:@"HOME"]) {
        
        if (isFilteredByHomeGoalsFor) {
            [self clearHomeFilter];
        } else {
            //do league stuff here
            isFilteredByHomeGoalsFor = YES;
            
            leagueData = [[FootballFormDB sharedInstance]getLeagueTableHome:selectedLeague orderBy:@"home_total_goals_for" groupText:groupText];
            [self buildTheCells];
            
        }
        
        
    } else if ([type isEqualToString:@"AWAY"]) {
        
        if (isFilteredByAwayGoalsFor) {
            [self clearAwayFilter];
        } else {
            //do league stuff here
            isFilteredByAwayGoalsFor = YES;
            
            leagueData = [[FootballFormDB sharedInstance]getLeagueTableAway:selectedLeague orderBy:@"away_total_goals_for" groupText:groupText];
            [self buildTheCells];
            
        }
        
    }

}

- (IBAction)filterByGoalsAgainst:(id)sender {
    
    //HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //[HUD setLabelText:@"Loading"];
    //[HUD setDetailsLabelText:@"Please wait..."];
    //[HUD show:YES];
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(filterGA) userInfo:nil repeats:NO];
    
}


-(void)filterGA {
    
    if ([type isEqualToString:@"ALL"]) {
        
        
        leagueData = [NSMutableArray new];
        
        if (isFilteredGoalsAgainst) {
            
            [self clearFilter:nil];
            
        } else {
            
            leagueData =  [[FootballFormDB sharedInstance] getLeagueTableFilterByGoalsAgainst:selectedLeague groupText:groupText];
            
            if (leagueData != nil) {
                
                [self buildTheCells];
                isFilteredGoalsAgainst = YES;
                
            }
        }
        
    }else if ([type isEqualToString:@"HOME"]) {
        
        if (isFilteredByHomeGoalsAgainst) {
            [self clearHomeFilter];
        } else {
            //do league stuff here
            isFilteredByHomeGoalsAgainst = YES;
            
            leagueData = [[FootballFormDB sharedInstance]getLeagueTableHome:selectedLeague orderBy:@"home_total_goals_against" groupText:groupText];
            [self buildTheCells];
            
        }
        
    } else if ([type isEqualToString:@"AWAY"]) {
        
        if (isFilteredByAwayGoalsAgainst) {
            [self clearAwayFilter];
        } else {
            //do league stuff here
            isFilteredByAwayGoalsAgainst = YES;
            
            leagueData = [[FootballFormDB sharedInstance]getLeagueTableAway:selectedLeague orderBy:@"away_total_goals_against" groupText:groupText];
            [self buildTheCells];
            
        }
        
    }

    
}

- (IBAction)filterByGoalDifference:(id)sender {
    
    //HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //[HUD setLabelText:@"Loading"];
    //[HUD setDetailsLabelText:@"Please wait..."];
    //[HUD show:YES];
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(filterGD) userInfo:nil repeats:NO];
    
}

-(void)filterGD {
    
    if ([type isEqualToString:@"ALL"]) {
        
        leagueData = [NSMutableArray new];
        
        if (isFilteredGoalDifference) {
            
            [self clearFilter:nil];
            
        } else {
            
            leagueData =  [[FootballFormDB sharedInstance] getLeagueTableFilterByGoalsDifference:selectedLeague groupText:groupText];
            
            if (leagueData != nil) {
                
                [self buildTheCells];
                isFilteredGoalDifference = YES;
                
            }
            
        }
        
    } else if ([type isEqualToString:@"HOME"]) {
        
        if (isFilteredByHomeGoalsDifference) {
            [self clearHomeFilter];
        } else {
            //do league stuff here
            
            [self clearHomeFilter];
            isFilteredByHomeGoalsDifference = YES;
            
            NSArray * sorted2 = [leagueData sortedArrayUsingComparator: ^(id first, id second) {
                return - [([(NSDictionary *)first objectForKey:@"goal_difference"]) compare:([(NSDictionary *)second objectForKey:@"goal_difference"]) options: NSNumericSearch];
                
            }];
            
            leagueData = [sorted2 copy];
            
            [self buildTheCells];
            
        }
        
        
    } else if ([type isEqualToString:@"AWAY"]) {
        
        if (isFilteredByAwayGoalsDifference) {
            [self clearAwayFilter];
        } else {
            //do league stuff here
            
            [self clearAwayFilter];
            isFilteredByAwayGoalsDifference = YES;
            
            NSArray * sorted2 = [leagueData sortedArrayUsingComparator: ^(id first, id second) {
                return - [([(NSDictionary *)first objectForKey:@"goal_difference"]) compare:([(NSDictionary *)second objectForKey:@"goal_difference"]) options: NSNumericSearch];
                
            }];
            
            leagueData = [sorted2 copy];
            
            [self buildTheCells];
            
        }
        
    }

    
}

-(void)clearAwayFilter {
    
    isFilteredByAwayPlayed = NO;
    isFilteredByAwayWins = NO;
    isFilteredByAwayDraws = NO;
    isFilteredByAwayLooses = NO;
    isFilteredByAwayGoalsFor = NO;
    isFilteredByAwayGoalsAgainst = NO;
    isFilteredByAwayGoalsDifference = NO;
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HUD setLabelText:@"Loading"];
    [HUD setDetailsLabelText:@"Please wait..."];
    [HUD show:YES];
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(ll) userInfo:nil repeats:NO];

}

-(void)ll {
    
    leagueData = [[FootballFormDB sharedInstance]getLeagueTableAway:selectedLeague orderBy:@"team_away_points" groupText:groupText];
    [self buildTheCells];
    
}

-(void)clearHomeFilter {
    
    isFilteredByHomePlayed = NO;
    isFilteredByHomeWins = NO;
    isFilteredByHomeDraws = NO;
    isFilteredByHomeLooses = NO;
    isFilteredByHomeGoalsFor = NO;
    isFilteredByHomeGoalsAgainst = NO;
    isFilteredByHomeGoalsDifference = NO;
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HUD setLabelText:@"Loading"];
    [HUD setDetailsLabelText:@"Please wait..."];
    [HUD show:YES];
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(hf) userInfo:nil repeats:NO];

    
}

-(void)hf {
    
    leagueData = [[FootballFormDB sharedInstance]getLeagueTableHome:selectedLeague orderBy:@"team_home_points" groupText:groupText];
    [self buildTheCells];
    
}

- (IBAction)clearFilter:(id)sender {
    /*
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HUD setLabelText:@"Loading"];
    [HUD setDetailsLabelText:@"Please wait..."];
    [HUD show:YES];
     */
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(cl) userInfo:nil repeats:NO];

}


-(void)cl {
    
    if ([type isEqualToString:@"ALL"]) {
        
        leagueData = [NSMutableArray new];
        leagueData =  [[FootballFormDB sharedInstance] getLeagueTable:selectedLeague groupText:groupText];
        
        if (leagueData != nil) {
            
            isFilteredLooses = NO;
            isFilteredDraws = NO;
            isFilteredPlayed = NO;
            isFilteredWins = NO;
            isFilteredGoalsFor = NO;
            isFilteredGoalsAgainst = NO;
            isFilteredGoalDifference = NO;
            
            [self buildTheCells];
            
        }
        
    } else if ([type isEqualToString:@"HOME"]) {
        
        [self clearHomeFilter];
        
    } else if ([type isEqualToString:@"AWAY"]) {
        
        [self clearAwayFilter];
        
    }
    
}

#pragma mark Pickerview Delegate Methods
//UIPickerView delegate methods
- (void)pickerView:(UIPickerView *)pV didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    leagueData = [NSMutableArray new];

    selectedLeague =  [[leagueDivisionData objectAtIndex:row]objectForKey:@"leagueID"];
    
    [leagueTitle setText:[[leagueDivisionData objectAtIndex:row]objectForKey:@"name"]];
    leagueTitle.minimumScaleFactor = 0.3;
    leagueTitle.adjustsFontSizeToFitWidth = YES;
    
    [[NSUserDefaults standardUserDefaults]setObject:selectedLeague forKey:@"selLegIdLeagues"];
    [[NSUserDefaults standardUserDefaults]setObject:leagueTitle.text forKey:@"selLegNameLeagues"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    leagueData =  [[FootballFormDB sharedInstance] getLeagueTable:selectedLeague groupText:groupText];
    
    [self buildTheCells];
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [leagueDivisionData count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [[leagueDivisionData objectAtIndex:row]objectForKey:@"name"];
}

- (IBAction)closeWidgetView:(id)sender {
    
    [UIView animateWithDuration:0.4 animations:^{
        [_entireWidgetView setAlpha:0.0];
    }];
    
    self.canDisplayBannerAds = YES;
    
}
@end