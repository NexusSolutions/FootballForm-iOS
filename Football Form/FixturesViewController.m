//
//  FixturesViewController.m
//  Football Form
//
//  Created by Aaron Wilkinson on 28/11/2013.
//  Copyright (c) 2013 Createanet. All rights reserved.
//

#import "FixturesViewController.h"
#import "FootballFormDB.h"
#import "API.h"
#import "StatsExplorerPredictorViewController.h"

@interface FixturesViewController ()

@end

@implementation FixturesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
    [bannerView setFrame:CGRectMake(bannerView.frame.origin.x, self.view.frame.size.height-bannerView.frame.size.height, self.view.frame.size.width, bannerView.frame.size.height)];
    float tvHeight = self.view.frame.size.height-_tableview.frame.origin.y;
    
    [entirePickerView setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];

    if(hasGotAd) {
        
        [_tableview setFrame:CGRectMake(_tableview.frame.origin.x, _tableview.frame.origin.y, _tableview.frame.size.width, tvHeight-bannerView.frame.size.height)];

    } else {
        
        [_tableview setFrame:CGRectMake(_tableview.frame.origin.x, _tableview.frame.origin.y, _tableview.frame.size.width, tvHeight)];
        
    }
}

#pragma mark iAd Delegate Methods

// Method is called when the iAd is loaded.
-(void)bannerViewDidLoadAd:(ADBannerView *)banner {
    
    float tvHeight = self.view.frame.size.height-_tableview.frame.origin.y;
    
    [_tableview setFrame:CGRectMake(_tableview.frame.origin.x, _tableview.frame.origin.y, _tableview.frame.size.width, tvHeight-bannerView.frame.size.height)];
    
    [bannerView setFrame:CGRectMake(bannerView.frame.origin.x, self.view.frame.size.height-bannerView.frame.size.height, self.view.frame.size.width, bannerView.frame.size.height)];
    
    [UIView beginAnimations:nil context:nil];
    
    [UIView setAnimationDuration:1];
    
    [banner setAlpha:1];
    
    [UIView commitAnimations];
    
    hasGotAd=YES;
    
}

 
// Method is called when the iAd fails to load.
-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    
    float tvHeight = self.view.frame.size.height-_tableview.frame.origin.y;

    [_tableview setFrame:CGRectMake(_tableview.frame.origin.x, _tableview.frame.origin.y, _tableview.frame.size.width, tvHeight)];

    
    [UIView beginAnimations:nil context:nil];
    
    [UIView setAnimationDuration:1];
    
    [banner setAlpha:0];
    
    
    [UIView commitAnimations];
    
    hasGotAd=NO;
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [leaguesArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionViewy cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell;
    
    cell = (UICollectionViewCell *)[collectionViewy dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    UILabel *leagueName = (UILabel *)[cell viewWithTag:101];
    [leagueName setText:[[leaguesArray objectAtIndex:indexPath.row] objectForKey:@"name"]];
    
    //int fractionalPage = leaguesCollectionView.contentOffset.x / kSetCellSize;
    
    int fractionalPag = (leaguesCollectionView.contentSize.width / leaguesArray.count)-5;
    
    int fractionalPage = leaguesCollectionView.contentOffset.x / fractionalPag;

    [leagueName setTextColor:[UIColor colorWithRed:160/255.0f green:178/255.0f blue:192/255.0f alpha:1]];

    
    if (fractionalPage>=indexPath.row) {
        
        if (fractionalPage>=[leaguesArray count]) {
            fractionalPage=(int)[leaguesArray count]-1;
        }
        
        if (![selectedLeagueID isEqualToString:[[leaguesArray objectAtIndex:fractionalPage] objectForKey:@"leagueID"]]) {
            
            selectedLeagueID = [[leaguesArray objectAtIndex:fractionalPage] objectForKey:@"leagueID"];
            selectedLeague = [[leaguesArray objectAtIndex:fractionalPage] objectForKey:@"name"];
            
            //selectedLeagueID = selectedLeague;
            //[self getFixtureDataWithFixID];
            
            if (selectedLeagueID) [[NSUserDefaults standardUserDefaults]setObject:selectedLeagueID forKey:@"FootballForm:LeagueToCarry:LeagueID"];
            
            [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(getFixtureDataWithFixID) userInfo:nil repeats:NO];
            
            [[NSUserDefaults standardUserDefaults]setObject:selectedLeagueID forKey:@"leagueID"];
            [[NSUserDefaults standardUserDefaults]setObject:leagueName.text forKey:@"leagueName"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
        }
        
        
        [leagueName setTextColor:[UIColor whiteColor]];
        
    } else {
        
        [leagueName setTextColor:[UIColor colorWithRed:160/255.0f green:178/255.0f blue:192/255.0f alpha:1]];
        
    }
    
    return cell;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView==leaguesCollectionView) {
        [UIView animateWithDuration:0.5 animations:^{
            //CGFloat pageWidth = kSetCellSize;
            //int fractionalPage = round(scrollView.contentOffset.x / pageWidth);
            
            int fractionalPag = (leaguesCollectionView.contentSize.width/leaguesArray.count)-5;
            int fractionalPage = leaguesCollectionView.contentOffset.x / fractionalPag;
            
            if (fractionalPage>=[leaguesArray count]) {
                fractionalPage=(int)[leaguesArray count]-1;
            }
            
            [leaguesCollectionView setContentOffset:CGPointMake(fractionalPage*213, 0)];
            
        }completion:^(BOOL finished) {
            
            hasReloaded = YES;
            
            [leaguesCollectionView reloadData];
            
            [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(resetReloaded) userInfo:nil repeats:NO];

        }];
    }
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView==leaguesCollectionView) {
        /*
        if (!scrollView.decelerating) {
            
            if (!hasReloaded) {
                hasReloaded = YES;
                
                [leaguesCollectionView reloadData];

                [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(resetReloaded) userInfo:nil repeats:NO];
            }
            
        }
         */
        
        CGFloat scrollSpeed = scrollView.contentOffset.x - previousScrollViewYOffset;
        previousScrollViewYOffset = scrollView.contentOffset.x;
        
        
        if (scrollSpeed >= 0.0 && scrollSpeed <1.5) {
            
            if (!hasReloaded) {
                hasReloaded = YES;
                [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(resetReloaded) userInfo:nil repeats:NO];
                [leaguesCollectionView reloadData];
            }
            
        }
    }
}

-(void)resetReloaded {
    hasReloaded = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [noDataView setHidden:YES];
    
    leaguesCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, (leaguesCollectionView.frame.size.width/2)+425);
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    } else {
        // iOS 6
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
    
    /*
    if (!IS_IPHONE5) {
        [navBarButtonView setFrame:CGRectMake(navBarButtonView.frame.origin.x-88, navBarButtonView.frame.origin.y, navBarButtonView.frame.size.width, navBarButtonView.frame.size.height)];
        [footballIcon setFrame:CGRectMake(footballIcon.frame.origin.x-70, footballIcon.frame.origin.y, footballIcon.frame.size.width, footballIcon.frame.size.height)];
        [_whatIsChosen setFrame:CGRectMake(_whatIsChosen.frame.origin.x-58,_whatIsChosen.frame.origin.y, _whatIsChosen.frame.size.width, _whatIsChosen.frame.size.height)];
        
    }
     */
    
    //[_pickerWheel setFrame:CGRectMake(_pickerWheel.frame.origin.x, _pickerWheel.frame.origin.y, [[UIScreen mainScreen]bounds].size.height, _pickerWheel.frame.size.height)];
    
    //Listen for NSNotification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(noti)
                                                 name:@"FootballForm:PKWillRefresh"
                                               object:nil];

    
}

-(void)noti {
    
    [leaguesCollectionView setContentOffset:CGPointMake(0, 0)];
    
    fixtureData=nil;

    NSString *lfc = [[NSUserDefaults standardUserDefaults]objectForKey:@"countryID"];
    
    if (!lfc) {
        lfc = @"40011";
    }
    
    [leaguesCollectionView setContentOffset:CGPointMake(0, 0)];

    leaguesArray = [[FootballFormDB sharedInstance]getLeaguesForCountryFixtures:lfc];
    [leaguesCollectionView reloadData];

    if (leaguesArray.count==0) {
        
        [noDataView setFrame:CGRectMake(noDataView.frame.origin.x, 44, noDataView.frame.size.width, noDataView.frame.size.height)];
        [noDataView setHidden:NO];
        [selectTheDayView setHidden:YES];
        
    } else {
        
        [noDataView setHidden:YES];
        selectedLeagueID = [[leaguesArray objectAtIndex:0] objectForKey:@"leagueID"];
        selectedLeague = [[leaguesArray objectAtIndex:0] objectForKey:@"name"];
        
        [[NSUserDefaults standardUserDefaults]setObject:selectedLeagueID forKey:@"FootballForm:LeagueToCarry:LeagueID"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        daysArray = [[FootballFormDB sharedInstance]getLastAvailableGamesPerLeague:selectedLeagueID];

        [selectTheDayView setHidden:NO];
        
        [self getFixtureDataWithFixID];
    }

    
    //[self viewWillAppear:YES];
}

-(NSString *) addSuffixToNumber:(int) number
{
    NSString *suffix;
    int ones = number % 10;
    int temp = floor(number/10.0);
    int tens = temp%10;
    
    if (tens ==1) {
        suffix = @"th";
    } else if (ones ==1){
        suffix = @"st";
    } else if (ones ==2){
        suffix = @"nd";
    } else if (ones ==3){
        suffix = @"rd";
    } else {
        suffix = @"th";
    }
    
    NSString *completeAsString = [NSString stringWithFormat:@"%d%@",number,suffix];
    return completeAsString;
}

- (BOOL)prefersStatusBarHidden {
    
        return YES;
}


-(void)viewWillAppear:(BOOL)animated {
    
    _noMatches.hidden=1;
    
    [self setUpTabBar];
    
    dayArray = @[@"Today", @"Tomorrow", @"Next 3 Games", @"Next 5 Games", @"Next 10 Games", @"Yesterday", @"Previous 3 Games", @"Previous 5 Games", @"Previous 10 Games"];
    
    [entirePickerView setAlpha:0.0];
    [entirePickerView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    if (fixtureData==nil) {

        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(actuallyLoad) userInfo:nil repeats:NO];
        
    }
    
    
}

-(void)actuallyLoad {
    
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"shouldUseSavedFixDet"] isEqualToString:@"YES"]) {
        
        NSDictionary *day = [[NSUserDefaults standardUserDefaults]objectForKey:@"selDay"];
        NSString *leid = [[NSUserDefaults standardUserDefaults]objectForKey:@"selLeagId"];
        NSString *lename = [[NSUserDefaults standardUserDefaults]objectForKey:@"selLeag"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"shouldUseSavedFixDet"];
        
        fixtureData = [NSMutableArray new];
        leagueData = [[FootballFormDB sharedInstance]getLeagues];
        //I know this is erroring, but it is working and do not want to change the structure of selectedDay
        selectedDay =  day;
        selectedLeague = lename;
        selectedLeagueID = leid;
        
        [[NSUserDefaults standardUserDefaults]setObject:selectedLeagueID forKey:@"FootballForm:LeagueToCarry:LeagueID"];
        [[NSUserDefaults standardUserDefaults]synchronize];

        daysArray = [[FootballFormDB sharedInstance]getLastAvailableGamesPerLeague:selectedLeagueID];
        
        
        
        fixtureData =[[FootballFormDB sharedInstance]getFixturesForDate:[day objectForKey:@"date"] andFixture:selectedLeagueID initialFID:nil];
        
        [_whatIsChosen setText:[NSString stringWithFormat:@"%@ - %@", [day objectForKey:@"dateName"], selectedLeague]];
        
        [_tableview reloadData];
    
    } else {
        
        NSString *lfc = [[NSUserDefaults standardUserDefaults]objectForKey:@"countryID"];
        
        if (!lfc) {
            lfc = @"40011";
        }
        
        leaguesArray = [[FootballFormDB sharedInstance]getLeaguesForCountryFixtures:lfc];
        [leaguesCollectionView reloadData];
        
        int indexx = [self workOutCarriedLeague];
        
        [leaguesCollectionView setContentOffset:CGPointMake(indexx*213, 0)];
        
        if (leaguesArray.count==0) {
            
            [noDataView setFrame:CGRectMake(noDataView.frame.origin.x, 44, noDataView.frame.size.width, noDataView.frame.size.height)];
            [noDataView setHidden:NO];
            
            [selectTheDayView setHidden:YES];
            
        } else {
            
            [noDataView setHidden:YES];
            
            selectedLeagueID = [[leaguesArray objectAtIndex:indexx] objectForKey:@"leagueID"];
            
            [[NSUserDefaults standardUserDefaults]setObject:selectedLeagueID forKey:@"FootballForm:LeagueToCarry:LeagueID"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            selectedLeague = [[leaguesArray objectAtIndex:indexx] objectForKey:@"name"];
            [selectTheDayView setHidden:NO];
            
            daysArray = [[FootballFormDB sharedInstance]getLastAvailableGamesPerLeague:selectedLeagueID];

            [self getFixtureDataWithFixID];
            
        }
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


- (IBAction)downloadFile:(id)sender {
    
    NSURL *url = [NSURL URLWithString:@"http://footballform.createaclients.co.uk/football_form_database.db"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    NSString *fullPath = [NSTemporaryDirectory() stringByAppendingPathComponent:[url lastPathComponent]];
    [[NSUserDefaults standardUserDefaults]setObject:fullPath forKey:@"pathDatabaseIsSavedIn"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [operation setOutputStream:[NSOutputStream outputStreamToFileAtPath:fullPath append:NO]];
    
    /*
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    HUD.delegate = self;
    HUD.labelText = @"Updating";
    */
    

    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HUD setMode:MBProgressHUDModeAnnularDeterminate];
    [HUD setLabelText:@"Downloading Data"];
    [HUD setDetailsLabelText:@"Please wait..."];
    [HUD setProgress:0.0];
    [HUD show:YES];
    
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        //NSLog(@"bytesRead: %u, totalBytesRead: %lld, totalBytesExpectedToRead: %lld", bytesRead, totalBytesRead, totalBytesExpectedToRead);
        
        HUD.progress = (float)totalBytesRead / totalBytesExpectedToRead;

        
    }];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //NSLog(@"RES: %@", [[[operation response] allHeaderFields] description]);
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
        NSError *error;
        NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:fullPath error:&error];
        
        if (error) {
            NSLog(@"ERR: %@", [error description]);
        } else {
            NSNumber *fileSizeNumber = [fileAttributes objectForKey:NSFileSize];
            long long fileSize = [fileSizeNumber longLongValue];
            
            NSLog(@"the filesize %lld", fileSize);
            
            [self getFixtureData];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"There was a problem download the latest football stats.\n\n%@",[error localizedDescription]] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
    [operation start];
}

-(void)getFixtureDataWithFixID {
    
    fixtureData = [NSMutableArray new];
    
    daysArray = [[FootballFormDB sharedInstance]getLastAvailableGamesPerLeague:selectedLeagueID];
    isCupGame = NO;
    
    [_selectDayButton setHidden:NO];
    [_selectDayButton setTitle:@"Select Day" forState:UIControlStateNormal];
    
    
    if ([daysArray count]==0) {
        
        [selectTheDayView setHidden:YES];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Fixtures" message:@"There is no fixture data available." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        
        [_selectDayButton setHidden:YES];
        [_whatIsChosen setText:[NSString stringWithFormat:@"No results available for %@", selectedLeague]];
        
        return;
    }
    
    [selectTheDayView setHidden:NO];
    
    [_selectDayButton setHidden:NO];
    [_selectDayButton setTitle:@"Select Day" forState:UIControlStateNormal];
    

    selectedDay = [daysArray objectAtIndex:([self workOutDateClosestToToday])];
    
    NSLog(@"%@", selectedDay);
    
    NSDictionary *diction = [[NSDictionary alloc]initWithObjectsAndKeys:selectedDay, @"sel", nil];
    
    fixtureData =[[FootballFormDB sharedInstance]getFixturesForDateNew:[[diction objectForKey:@"sel"] objectForKey:@"date"] andFixture:selectedLeagueID];
    
    NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:selectedDay, @"sel", nil];
    
    [[NSUserDefaults standardUserDefaults]setObject:selectedDay forKey:@"selDay"];
    [[NSUserDefaults standardUserDefaults]setObject:selectedLeagueID forKey:@"selLeagId"];
    [[NSUserDefaults standardUserDefaults]setObject:selectedLeague forKey:@"selLeag"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [_whatIsChosen setText:[NSString stringWithFormat:@"%@ - %@", [[dict objectForKey:@"sel"] objectForKey:@"dateName"], selectedLeague]];
    
    [_pickerWheel reloadAllComponents];
    
    [_tableview reloadData];
}

-(int)workOutDateClosestToToday {

    NSMutableArray *secondsArray = [NSMutableArray new];
    
    NSDateFormatter *outputDateFormatter = [[NSDateFormatter alloc] init];
    [outputDateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *today  = [outputDateFormatter stringFromDate:[NSDate date]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *todayDate = [[NSDate alloc] init];
    todayDate = [dateFormatter dateFromString:today];
    
    for (NSDictionary *dict in daysArray) {
         NSString *date = dict[@"date"];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *fixtureDate = [[NSDate alloc] init];
        fixtureDate = [dateFormatter dateFromString:date];
        
        NSTimeInterval diff = [fixtureDate timeIntervalSinceDate:todayDate];
        [secondsArray addObject:[NSString stringWithFormat:@"%f", diff]];
    }
    
    int index = daysArray.count-1;
    int increment = 0;
    int lastValue;
    
    NSArray* reversed = [[secondsArray reverseObjectEnumerator] allObjects];

    for (NSString *seconds in reversed) {
        
        int secs = seconds.intValue;
        
        if(secs==0) {
            index=increment;
        }
        
        if (increment==0) {
            lastValue = secs;
        }
        
        if (lastValue<0&&secs>0) {
            
            //if (lastValue < secs) {
               // index=increment-1;
            //} else {
                index=increment;
            //}
            break;
        }
        
        lastValue = secs;
        
        increment++;
    }
    
    NSArray* daysAr = [[daysArray reverseObjectEnumerator] allObjects];

    NSLog(@"INDEX %d %@", index, daysAr[index]);
    
    int actualIndex = 0;
    int incrementt = 0;
    NSString *dat = daysAr[index][@"date"];
    
    for (NSDictionary *dict in daysArray) {
        NSString *da = dict[@"date"];
        
        if ([da isEqualToString:dat]) {
            actualIndex=incrementt;
        }
        
        incrementt++;
    }
    
    return actualIndex;

}

-(double)workOutFirstNumberGreaterThanZero:(NSMutableArray *)agesArray {
    
    int returnValue = 0;
    
    for (NSDictionary *dict in agesArray) {
        
        NSString *difference = dict[@"difference"];
        
        if (difference.length>0) {
            
            double currentDiff = [difference doubleValue];
            
            if (currentDiff >=0) {
                return returnValue;
            }
        }
        
        returnValue++;
    }
    
    return 0;
}

-(void)getFixtureData {
    
    fixtureData = [NSMutableArray new];
    leagueData = [[FootballFormDB sharedInstance]getLeagues];
    
    selectedLeagueID = [[NSUserDefaults standardUserDefaults]objectForKey:@"leagueID"];
    
    selectedLeague = [[NSUserDefaults standardUserDefaults]objectForKey:@"leagueName"];
    initialLID = selectedLeagueID;
    
    daysArray = [[FootballFormDB sharedInstance]getLastAvailableGamesPerLeague:selectedLeagueID];
    isCupGame = NO;
    
    [_selectDayButton setHidden:NO];
    [_selectDayButton setTitle:@"Select Day" forState:UIControlStateNormal];
    
    /*
    if ([daysArray count]==0) {
        
        subLData = [[FootballFormDB sharedInstance]getSubLeagues];
        
        if ([subLData count]==0) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Fixtures" message:@"There is no fixture data available." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            
            [_selectDayButton setHidden:YES];

            
            return;
            
        } else {
            
            [_selectDayButton setHidden:NO];
            [_selectDayButton setTitle:@"Select Stage" forState:UIControlStateNormal];

            
            isCupGame = YES;
            
            NSString *selectedLeague2 = [[subLData objectAtIndex:0] objectForKey:@"name"];
            selectedLeagueID = [[subLData objectAtIndex:0] objectForKey:@"id"];
            
            fixtureData =[[FootballFormDB sharedInstance]getFixturesForDate:nil andFixture:selectedLeagueID initialFID:initialLID];
            
            [_whatIsChosen setText:[NSString stringWithFormat:@"%@ - %@", selectedLeague, selectedLeague2]];
            

        }
        
    } else {
        
        [_selectDayButton setHidden:NO];
        [_selectDayButton setTitle:@"Select Day" forState:UIControlStateNormal];
        
        selectedDay = [daysArray objectAtIndex:0];
        
        NSDictionary *diction = [[NSDictionary alloc]initWithObjectsAndKeys:selectedDay, @"sel", nil];

        fixtureData =[[FootballFormDB sharedInstance]getFixturesForDate:[[diction objectForKey:@"sel"] objectForKey:@"date"] andFixture:selectedLeagueID initialFID:initialLID];
        
        NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:selectedDay, @"sel", nil];
        
        [[NSUserDefaults standardUserDefaults]setObject:selectedDay forKey:@"selDay"];
        [[NSUserDefaults standardUserDefaults]setObject:selectedLeagueID forKey:@"selLeagId"];
        [[NSUserDefaults standardUserDefaults]setObject:selectedLeague forKey:@"selLeag"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        [_whatIsChosen setText:[NSString stringWithFormat:@"%@ - %@", [[dict objectForKey:@"sel"] objectForKey:@"dateName"], selectedLeague]];
        
    }
     */
    
    
     if ([daysArray count]==0) {
         
         [noDataView setFrame:CGRectMake(noDataView.frame.origin.x, 44, noDataView.frame.size.width, noDataView.frame.size.height)];
         [noDataView setHidden:NO];

         
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Fixtures" message:@"There is no fixture data available." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
         [alert show];
         
         [_selectDayButton setHidden:YES];
         
         [_whatIsChosen setText:[NSString stringWithFormat:@"No results available for %@", selectedLeague]];
         
         return;
     }
    
    [noDataView setHidden:YES];
    
    [_selectDayButton setHidden:NO];
    [_selectDayButton setTitle:@"Select Day" forState:UIControlStateNormal];
    
    /*
    selectedDay = [daysArray objectAtIndex:0];
    
    NSDictionary *diction = [[NSDictionary alloc]initWithObjectsAndKeys:selectedDay, @"sel", nil];
    */
    
    int ind = 0;
    if (daysArray.count>5) {
        ind = (int)[daysArray count]/2;
    }
    
    selectedDay = [daysArray objectAtIndex:(ind)];
    
    NSDictionary *diction = [[NSDictionary alloc]initWithObjectsAndKeys:selectedDay, @"sel", nil];

    
    fixtureData =[[FootballFormDB sharedInstance]getFixturesForDateNew:[[diction objectForKey:@"sel"] objectForKey:@"date"] andFixture:initialLID];
    
    NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:selectedDay, @"sel", nil];
    
    [[NSUserDefaults standardUserDefaults]setObject:selectedDay forKey:@"selDay"];
    [[NSUserDefaults standardUserDefaults]setObject:selectedLeagueID forKey:@"selLeagId"];
    [[NSUserDefaults standardUserDefaults]setObject:selectedLeague forKey:@"selLeag"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [_whatIsChosen setText:[NSString stringWithFormat:@"%@ - %@", [[dict objectForKey:@"sel"] objectForKey:@"dateName"], selectedLeague]];

    
    
    [_pickerWheel reloadAllComponents];
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
    
    
    [_tabBar setSelectedItem:fixtures];
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    
    
    if (item.tag==1) {
        /*
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"FootballForm:GoToFixtures"
         object:self];
        */
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

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // typically you need know which item the user has selected.
    // this method allows you to keep track of the selection
    
    /*
    [[NSUserDefaults standardUserDefaults]setObject:[[fixtureData objectAtIndex:indexPath.row]objectForKey:@"fixture_date"] forKey:@"fixtureDateCarry"];
    [[NSUserDefaults standardUserDefaults]setObject:[[fixtureData objectAtIndex:indexPath.row]objectForKey:@"team_home_name"] forKey:@"homeTeamCarry"];
    [[NSUserDefaults standardUserDefaults]setObject:[[fixtureData objectAtIndex:indexPath.row]objectForKey:@"team_away_name"] forKey:@"awayTeamCarry"];
    [[NSUserDefaults standardUserDefaults]setObject:[[fixtureData objectAtIndex:indexPath.row]objectForKey:@"team_away_id"] forKey:@"awayTeamIDCarry"];
    [[NSUserDefaults standardUserDefaults]setObject:[[fixtureData objectAtIndex:indexPath.row]objectForKey:@"team_home_id"] forKey:@"homeTeamIDCarry"];

    [self performSegueWithIdentifier:@"FixtureDetails" sender:self];
     */
    
    [[NSUserDefaults standardUserDefaults]setObject:[[fixtureData objectAtIndex:indexPath.row] objectForKey:@"team_home_id"] forKey:@"statsExplorerTeamOneID"];
    [[NSUserDefaults standardUserDefaults]setObject:[[fixtureData objectAtIndex:indexPath.row] objectForKey:@"team_away_id"] forKey:@"statsExplorerTeamTwoID"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [self performSegueWithIdentifier:@"FixturesToStatsEx" sender:self];

    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"FixturesToStatsEx"]) {
        StatsExplorerPredictorViewController *statex = segue.destinationViewController;
        [statex setStatsLeagueID:selectedLeagueID];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    [tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    if ([fixtureData count]==0) {
        _noMatches.hidden=0;
    } else {
        _noMatches.hidden=1;
    }
    
    return [fixtureData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifer = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifer];
    }

    
    if (indexPath.row % 2) {
        cell.backgroundColor = [UIColor colorWithRed:0.901961 green:0.901961 blue:0.901961 alpha:1];
    } else {
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    //101 is home, 102 is away
    
    if (fixtureData != nil) {
            
        UILabel *homeTeam = (UILabel *)[cell viewWithTag:101];
        [homeTeam setText:[[[fixtureData objectAtIndex:indexPath.row]objectForKey:@"team_home_name"] capitalizedString]];
        homeTeam.minimumScaleFactor = 0.3;
        homeTeam.adjustsFontSizeToFitWidth = YES;
        
        
        UILabel *awayTeam = (UILabel *)[cell viewWithTag:102];
        [awayTeam setText:[[[fixtureData objectAtIndex:indexPath.row]objectForKey:@"team_away_name"] capitalizedString]];
        awayTeam.minimumScaleFactor = 0.3;
        awayTeam.adjustsFontSizeToFitWidth = YES;
        
        homeTeam.text = [homeTeam.text stringByReplacingOccurrencesOfString:@" Fc" withString:@" FC"];
        awayTeam.text = [awayTeam.text stringByReplacingOccurrencesOfString:@" Fc" withString:@" FC"];

        
        UILabel *gameTime = (UILabel *)[cell viewWithTag:103];
        NSString *date = [[fixtureData objectAtIndex:indexPath.row]objectForKey:@"start_time"];
        
        NSString *fixtureDate = [[fixtureData objectAtIndex:indexPath.row]objectForKey:@"fixture_date"];
        NSString *status = [[fixtureData objectAtIndex:indexPath.row]objectForKey:@"teamStatus"];
        NSString *teamHomeScore = [[fixtureData objectAtIndex:indexPath.row]objectForKey:@"team_home_score"];
        NSString *teamAwayScore = [[fixtureData objectAtIndex:indexPath.row]objectForKey:@"team_away_score"];

        UILabel *score = (UILabel *)[cell viewWithTag:150];
        
        UIImageView *vsIcon = (UIImageView *)[cell viewWithTag:191];

        if ([status isEqualToString:@"Fin"]||[status isEqualToString:@"fin"]||[status isEqualToString:@"1 HF"]||[status isEqualToString:@"2 HF"]) {
            [score setText:[NSString stringWithFormat:@"%@ - %@", teamHomeScore, teamAwayScore]];
            
            [score setHidden:NO];
            [vsIcon setHidden:YES];

        } else {
            
            [score setHidden:YES];
            [vsIcon setHidden:NO];
            
        }
        
        if (fixtureDate!=nil) {
            
            fixtureDate = [self convertTheDate:fixtureDate currentFormat:@"yyyy-MM-dd" wantedFormat:@"dd MMM yyyy"];
            [gameTime setText:[NSString stringWithFormat:@"%@ %@", fixtureDate, date]];
            
        } else {
            
            [gameTime setText:date];
            
        }

        
        UIImageView *hombg = (UIImageView *)[cell viewWithTag:10911];
        
        /*
        if (!IS_IPHONE5) {
            
                [vsIcon setFrame:CGRectMake(272-50, homeTeam.frame.origin.y, vsIcon.frame.size.width, vsIcon.frame.size.height)];
                [gameTime setFrame:CGRectMake(237-50, gameTime.frame.origin.y, gameTime.frame.size.width, gameTime.frame.size.height)];
            
                [hombg setFrame:CGRectMake(10, 12, 209, 28)];
            
                //[awaybg setFrame:CGRectMake(348, 12, 209, 28)];
                [awayTeam setFrame:CGRectMake(278, awayTeam.frame.origin.y, awayTeam.frame.size.width, awayTeam.frame.size.height)];
                [homeTeam setFrame:CGRectMake(27, homeTeam.frame.origin.y, homeTeam.frame.size.width, homeTeam.frame.size.height)];
            
        }
         */
    }
    
    return cell;
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
- (void)pickerView:(UIPickerView *)pV didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    NSLog(@"%@", selectedLeagueID);
    
    selectedDay = [daysArray objectAtIndex:row];
    
    if (!isCupGame) {
        
        if ([whatPickerViewShouldShow isEqualToString:@"DAY"]) {
            
            if ([daysArray count]==0) {
               
                return;
            }
            
            selectedDay = [daysArray objectAtIndex:row];
            
        } else {
            
            selectedLeague = [[leagueData objectAtIndex:row]objectForKey:@"name"];
            selectedLeagueID = [[leagueData objectAtIndex:row]objectForKey:@"leagueID"];
            [_selectDayButton setTitle:@"Select Day" forState:UIControlStateNormal];
            
        }
        
        
        /*NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:selectedDay, @"sel", nil];
        [_whatIsChosen setText:[NSString stringWithFormat:@"%@ - %@", [[dict objectForKey:@"sel"] objectForKey:@"dateName"], selectedLeague]];
        [self updateFixtures];*/
        
    } else {
        
        selectedLeagueID = [[subLData objectAtIndex:row] objectForKey:@"id"];
        isCupGame = YES;
        
        NSString *selectedLeague2 = [[subLData objectAtIndex:row] objectForKey:@"name"];
        fixtureData =[[FootballFormDB sharedInstance]getFixturesForDate:nil andFixture:selectedLeagueID initialFID:nil];
        [_whatIsChosen setText:[NSString stringWithFormat:@"%@ - %@", selectedLeague, selectedLeague2]];
        [_tableview reloadData];
            
            
            
        
    }

}




- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (isCupGame) {
        
       return [subLData count];
        
    } else {
        
        if ([whatPickerViewShouldShow isEqualToString:@"DAY"]) {
            return [daysArray count];
        } else {
            return [leagueData count];
        }
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (isCupGame) {
        
        return [[subLData objectAtIndex:row] objectForKey:@"name"];
        
    } else {

        if ([whatPickerViewShouldShow isEqualToString:@"DAY"]) {
            
        return [[daysArray objectAtIndex:row]objectForKey:@"dateName"];
            
        } else {
            
        return [[leagueData objectAtIndex:row]objectForKey:@"name"];
            
        }
        
    }
    
    return nil;
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];

}

- (IBAction)selectDay:(id)sender {
    
    if (!isCupGame) {
        
        [_pickerviewTitle setText:@"Select Day"];
        whatPickerViewShouldShow = @"DAY";
        [_pickerWheel reloadAllComponents];
        
        
        [_pickerWheel selectRow:0 inComponent:0 animated:NO];
        
        for(int i=0; i < [daysArray count]; i++) {
            
            NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:selectedDay, @"sel", nil];
            
            if ([[[daysArray objectAtIndex:i] objectForKey:@"date"]isEqualToString:[[dict objectForKey:@"sel"] objectForKey:@"date"]]) {
                [_pickerWheel selectRow:i inComponent:0 animated:NO];
            }
            
        }
        
    } else {
        
        [_pickerviewTitle setText:@"Select Stage"];
        [_pickerWheel reloadAllComponents];
        
    }

    
    [UIView animateWithDuration:0.5 animations:^{
        [entirePickerView setAlpha:1.0];
    }];
    
}

- (IBAction)selectLeague:(id)sender {
    
    whatPickerViewShouldShow = @"LEAGUE";
    [_pickerviewTitle setText:@"Select League"];
    [_pickerWheel reloadAllComponents];
    
    [_pickerWheel selectRow:0 inComponent:0 animated:NO];
    
    for(int i=0; i < [leagueData count]; i++) {
        
        if ([[[leagueData objectAtIndex:i]objectForKey:@"name"]isEqualToString:selectedLeague]) {
            [_pickerWheel selectRow:i inComponent:0 animated:NO];
        }
    }

    
    [UIView animateWithDuration:0.5 animations:^{
        [entirePickerView setAlpha:1.0];
    }];
}

- (IBAction)hidePickerView:(id)sender {
    
    NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:selectedDay, @"sel", nil];
    [_whatIsChosen setText:[NSString stringWithFormat:@"%@ - %@", [[dict objectForKey:@"sel"] objectForKey:@"dateName"], selectedLeague]];
    [self updateFixtures];
    
    [[NSUserDefaults standardUserDefaults]setObject:selectedDay forKey:@"selDay"];
    [[NSUserDefaults standardUserDefaults]setObject:selectedLeagueID forKey:@"selLeagId"];
    [[NSUserDefaults standardUserDefaults]setObject:selectedLeague forKey:@"selLeag"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [UIView animateWithDuration:0.5 animations:^{
        [entirePickerView setAlpha:0.0];
    }];
    
    if ([whatPickerViewShouldShow isEqualToString:@"DAY"]) {
        
        if (selectedDay ==nil) {
            
            if ([daysArray count]==0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Fixtures" message:@"There is no fixture data for the ranges selected!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
                return;
            }
            
            selectedDay = [daysArray objectAtIndex:0];
            [_selectDayButton setTitle:@"Select Day" forState:UIControlStateNormal];
        }
        
        
        [self updateFixtures];
        
    } else if ([whatPickerViewShouldShow isEqualToString:@"LEAGUE"]) {
        
        if (selectedLeague ==nil) {
            selectedLeague = [[leagueData objectAtIndex:0]objectForKey:@"name"];
            selectedLeagueID = [[leagueData objectAtIndex:0]objectForKey:@"leagueID"];
            
            [_selectLeagueButton setTitle:@"Select League" forState:UIControlStateNormal];
        }
        
        daysArray = [[FootballFormDB sharedInstance]getLastAvailableGamesPerLeague:selectedLeagueID];
        selectedDay = [daysArray objectAtIndex:0];
        
        [self updateFixtures];
        
    }
    
}


-(void)updateFixtures {
    
    NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:selectedDay, @"sel", nil];
    
    fixtureData = [NSMutableArray new];
    //fixtureData =[[FootballFormDB sharedInstance]getFixturesForDate:[[dict objectForKey:@"sel"] objectForKey:@"date"] andFixture:selectedLeagueID initialFID:nil];
    
    if (!selectedLeagueID) {
    
        selectedLeagueID = [[NSUserDefaults standardUserDefaults]objectForKey:@"leagueID"];
        
    }

    fixtureData = [[FootballFormDB sharedInstance]getFixturesForDateNew:[[dict objectForKey:@"sel"] objectForKey:@"date"] andFixture:selectedLeagueID];
    [_tableview reloadData];
    
    [_whatIsChosen setText:[NSString stringWithFormat:@"%@ - %@", [[dict objectForKey:@"sel"] objectForKey:@"dateName"], selectedLeague]];

    
    return;

    
    if ([selectedDay isEqualToString:@"Today"]) {
        
        NSDateFormatter *outputDateFormatter = [[NSDateFormatter alloc] init];
        [outputDateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *today  = [outputDateFormatter stringFromDate:[NSDate date]];
        
        fixtureData = [NSMutableArray new];
        fixtureData =[[FootballFormDB sharedInstance]getFixturesForDate:today andFixture:selectedLeagueID initialFID:nil];
        [_tableview reloadData];
        
    } else if ([selectedDay isEqualToString:@"Tomorrow"]) {
        
    NSDate *tomorrow = [NSDate dateWithTimeInterval:(24*60*60) sinceDate:[NSDate date]];
    
    NSDateFormatter *outputDateFormatter = [[NSDateFormatter alloc] init];
    [outputDateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *tomoz  = [outputDateFormatter stringFromDate:tomorrow];
    
    fixtureData = [NSMutableArray new];
    fixtureData =[[FootballFormDB sharedInstance]getFixturesForDate:tomoz andFixture:selectedLeagueID initialFID:nil];
    [_tableview reloadData];
        
    } else if ([selectedDay isEqualToString:@"Yesterday"]) {
        
        NSDate *yesterday = [NSDate dateWithTimeIntervalSinceNow: -(60.0f*60.0f*24.0f)];
        
        NSDateFormatter *outputDateFormatter = [[NSDateFormatter alloc] init];
        [outputDateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *yester  = [outputDateFormatter stringFromDate:yesterday];

        fixtureData = [NSMutableArray new];
        fixtureData =[[FootballFormDB sharedInstance]getFixturesForDate:yester andFixture:selectedLeagueID initialFID:nil];
        [_tableview reloadData];
        
    } else if ([selectedDay isEqualToString:@"Next 3 Games"]) {
        
        NSDateFormatter *outputDateFormatter = [[NSDateFormatter alloc] init];
        [outputDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *tod  = [outputDateFormatter stringFromDate:[NSDate date]];
        
        fixtureData = [NSMutableArray new];
        fixtureData =[[FootballFormDB sharedInstance]getFutureFixtureForGame:@"3" todaysDate:tod withFixtureID:selectedLeagueID];
        [_tableview reloadData];
        
    } else if ([selectedDay isEqualToString:@"Next 5 Games"]) {
        
        NSDateFormatter *outputDateFormatter = [[NSDateFormatter alloc] init];
        [outputDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *tod  = [outputDateFormatter stringFromDate:[NSDate date]];
        
        fixtureData = [NSMutableArray new];
        fixtureData =[[FootballFormDB sharedInstance]getFutureFixtureForGame:@"5" todaysDate:tod withFixtureID:selectedLeagueID];
        [_tableview reloadData];
        
    } else if ([selectedDay isEqualToString:@"Next 10 Games"]) {
        
        NSDateFormatter *outputDateFormatter = [[NSDateFormatter alloc] init];
        [outputDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *tod  = [outputDateFormatter stringFromDate:[NSDate date]];
        
        fixtureData = [NSMutableArray new];
        fixtureData =[[FootballFormDB sharedInstance]getFutureFixtureForGame:@"10" todaysDate:tod withFixtureID:selectedLeagueID];
        [_tableview reloadData];
        
    } else if ([selectedDay isEqualToString:@"Previous 3 Games"]) {
        
        NSDateFormatter *outputDateFormatter = [[NSDateFormatter alloc] init];
        [outputDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *tod  = [outputDateFormatter stringFromDate:[NSDate date]];
        
        fixtureData = [NSMutableArray new];
        fixtureData =[[FootballFormDB sharedInstance]getPastFixtureForGame:@"3" todaysDate:tod withFixtureID:selectedLeagueID];
        [_tableview reloadData];
        
    } else if ([selectedDay isEqualToString:@"Previous 5 Games"]) {
        
        NSDateFormatter *outputDateFormatter = [[NSDateFormatter alloc] init];
        [outputDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *tod  = [outputDateFormatter stringFromDate:[NSDate date]];
        
        fixtureData = [NSMutableArray new];
        fixtureData =[[FootballFormDB sharedInstance]getPastFixtureForGame:@"5" todaysDate:tod withFixtureID:selectedLeagueID];
        [_tableview reloadData];
        
    } else if ([selectedDay isEqualToString:@"Previous 10 Games"]) {
        
        NSDateFormatter *outputDateFormatter = [[NSDateFormatter alloc] init];
        [outputDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *tod  = [outputDateFormatter stringFromDate:[NSDate date]];
        
        fixtureData = [NSMutableArray new];
        fixtureData =[[FootballFormDB sharedInstance]getPastFixtureForGame:@"10" todaysDate:tod withFixtureID:selectedLeagueID];
        [_tableview reloadData];
        
    }
}

- (IBAction)invokePeek:(id)sender {
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    PKRevealController *revealController = (PKRevealController *) appDelegate.window.rootViewController;
    [revealController showViewController:revealController.leftViewController];

    
}
@end
