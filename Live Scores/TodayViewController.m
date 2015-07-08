//
//  TodayViewController.m
//  Live Scores
//
//  Created by Aaron Wilkinson on 16/10/2014.
//  Copyright (c) 2014 Createanet. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding> {
    NSArray *liveScoreData;
}

@end

@implementation TodayViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(pullLiveScores)
                                                     name:NSUserDefaultsDidChangeNotification
                                                   object:nil];
    }
    return self;
}

- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.preferredContentSize = CGSizeMake(0, 50);
    
    [self adjustSize];
    
}

-(void)adjustSize {
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    
    [self adjustSize];
    [self pullLiveScores];

    completionHandler(NCUpdateResultNewData);
}

- (void)pullLiveScores {
    
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.createanet.footballform.TodayExtensionSharingDefaults"];
    NSString *selectedCountryID = [sharedDefaults objectForKey:@"SharedDefaults:SelectedCountryID"];
    
    if (!selectedCountryID) {
        
        [_txtLabel setText:@"Please open Football Form to activate this widget"];
        [_txtLabel setHidden:NO];
        [_tableView setHidden:YES];
        
        self.preferredContentSize = CGSizeMake(0, 50);
        
        return;
    }
    
    if (liveScoreData.count==0) {
    
        [_txtLabel setText:@"Loading Live Scores..."];
        [_txtLabel setHidden:NO];
        [_tableView setHidden:YES];
        
        self.preferredContentSize = CGSizeMake(0, 50);
        
    }
    
    [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(performRequest) userInfo:nil repeats:NO];
    
}

-(void)performRequest {
    
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.createanet.footballform.TodayExtensionSharingDefaults"];
    NSString *selectedCountryID = [sharedDefaults objectForKey:@"SharedDefaults:SelectedCountryID"];
    
    if (selectedCountryID) {
        
        selectedCountryID = [selectedCountryID stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        NSString *urlString = [NSString stringWithFormat:@"http://footballform.createaclients.co.uk/api/v2/live_scores_api_country_id.php?type=GET_GAMES&league_id=%@", selectedCountryID];
        NSString* encodedUrl = [urlString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:encodedUrl]];
        request.HTTPMethod = @"POST";
        [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler: ^(NSURLResponse * response, NSData * data, NSError * error) {
            
            NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse*)response;
            
            if(httpResponse.statusCode == 200&&!error&&[data length]>0) {
                
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                
                NSString *responseString = json[@"response"];
                
                if ([responseString isEqualToString:@"Success"]) {
                    
                    liveScoreData = json[@"data"][@"match_data"];
                    
                    [self sortLeagueData];
                    
                    [_tableView reloadData];
                    
                    [_txtLabel setHidden:YES];
                    [_tableView setHidden:NO];
                    
                } else {
                    
                    [_txtLabel setText:json[@"message"]];
                    
                    [_txtLabel setHidden:NO];
                    [_tableView setHidden:YES];
                    
                    self.preferredContentSize = CGSizeMake(0, 50);

                }
                                
            } else {
                
                [_txtLabel setText:@"Please check your internet connection and try again"];

                [_txtLabel setHidden:NO];
                [_tableView setHidden:YES];
                
                self.preferredContentSize = CGSizeMake(0, 50);
                
            }
        }
         
     ];
        
    } else {
        
        [_txtLabel setText:@"Please open Football Form to activate this widget"];
        [_txtLabel setHidden:NO];
        [_tableView setHidden:YES];
        
        self.preferredContentSize = CGSizeMake(0, 50);
        
    }

}


-(void)sortLeagueData {
    
    leagueNames = [NSMutableArray new];
    
    for (NSDictionary *dicty in liveScoreData) {
        
        NSString *leagueName = dicty[@"league_name"];
        
        if (![leagueNames containsObject:leagueName]) [leagueNames addObject:leagueName];
        
    }
    
    //Here I am resorting the array so we can use tableview sections
    
    sortedData = [NSMutableArray new];
    
    int cumulativeTotal = 0;
    int finalCumulativeTotal = 0;
    int maxTotal = 500;
    
    for (NSString *leagueNombre in leagueNames) {
        
        cumulativeTotal = cumulativeTotal+22;
        
        if (cumulativeTotal<maxTotal) {
            finalCumulativeTotal = cumulativeTotal;
        }
        
        NSMutableArray *games = [NSMutableArray new];
        
        for (NSDictionary *game in liveScoreData) {
            
            NSString *lname = game[@"league_name"];
            
            if ([lname isEqualToString:leagueNombre]) {
                
                if (![games containsObject:game]) {
                    [games addObject:game];
                    
                    cumulativeTotal = cumulativeTotal+34;
                    
                    if (cumulativeTotal<maxTotal) {
                        finalCumulativeTotal = cumulativeTotal;
                    }
                }
                
            }
        }
        
        [sortedData addObject:@{leagueNombre : games}];
        
    }
    
    [_tableView setFrame:CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y, _tableView.frame.size.width, finalCumulativeTotal)];
    
    if (_tableView.frame.size.height>500) {
        [_tableView setFrame:CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y, _tableView.frame.size.width, 500)];
    }
    
    self.preferredContentSize = CGSizeMake(0, _tableView.frame.size.height);
    
    NSLog(@"%d", finalCumulativeTotal);
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [leagueNames count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [leagueNames objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSString *sectionTitle = [leagueNames objectAtIndex:section];
    NSArray *sectionAnimals = [sortedData[section] objectForKey:sectionTitle];
    return [sectionAnimals count];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, tableView.frame.size.width, 18)];
    [label setFont:[UIFont boldSystemFontOfSize:13]];
    [label setTextColor:[UIColor whiteColor]];
    
    NSString *string =[leagueNames objectAtIndex:section];
    [label setText:string];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor darkGrayColor]];
    
    return view;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        
    NSString *sectionTitle = [leagueNames objectAtIndex:indexPath.section];
    
    NSArray *sectionArray = [sortedData[indexPath.section] objectForKey:sectionTitle];
    
    NSDictionary *sectionData = sectionArray[indexPath.row];

    
    NSString *staType = sectionData[@"status_type"];
    
    if ([staType isEqualToString:@"live"] || [staType isEqualToString:@"fin"]) {
        
        NSString *link = [NSString stringWithFormat:@"footballform://live-scores/%@", sectionData[@"id"]];
        
        if (link) {
            NSExtensionContext *extensionContext = [self extensionContext];
            [extensionContext openURL:[NSURL URLWithString:link] completionHandler:nil];
        }
        
    } else {
        
        NSString *link = [NSString stringWithFormat:@"footballform://live-scores/no"];
        
        if (link) {
            NSExtensionContext *extensionContext = [self extensionContext];
            [extensionContext openURL:[NSURL URLWithString:link] completionHandler:nil];
        }
        
    }
    
}

/*- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [liveScoreData count];
}*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifer = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifer];
    }
    
    NSString *sectionTitle = [leagueNames objectAtIndex:indexPath.section];
    
    NSArray *sectionArray = [sortedData[indexPath.section] objectForKey:sectionTitle];
    
    NSDictionary *sectionData = sectionArray[indexPath.row];
    
    
    UILabel *teamHomeName = (UILabel *)[cell viewWithTag:101];
    UILabel *score = (UILabel *)[cell viewWithTag:102];
    UILabel *league = (UILabel *)[cell viewWithTag:103];
    UILabel *teamAwayName = (UILabel *)[cell viewWithTag:104];
    
    NSString *team_home_name = sectionData[@"team_home_name"];
    NSString *team_away_name = sectionData[@"team_away_name"];
    
    team_home_name = [team_home_name stringByReplacingOccurrencesOfString:@" (U21)" withString:@""];
    team_away_name = [team_away_name stringByReplacingOccurrencesOfString:@" (U21)" withString:@""];

    NSString *league_name = sectionData[@"league_name"];
    
    [teamHomeName setText:team_home_name];
    [teamAwayName setText:team_away_name];
    [league setText:league_name.uppercaseString];
    
    NSString *scoreText = sectionData[@"score"];
    NSString *statusType = sectionData[@"status_type"];
    NSString *startTime = sectionData[@"start_time"];
    
    if (scoreText.length==0) {
        scoreText = @"0-0";
    }
    
    if ([statusType isEqualToString:@"sched"]) {
        scoreText = startTime;
    }
    
    [score setText:scoreText];
    
    if ([statusType isEqualToString:@"fin"]) {
        [score setText:[NSString stringWithFormat:@"%@ FT", score.text]];
    }
    
    NSLog(@"%f", self.tableView.contentSize.width);
    
    return cell;
}

@end
