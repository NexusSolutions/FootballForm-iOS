//
//  TodayViewController.m
//  Premier League News
//
//  Created by Aaron Wilkinson on 16/10/2014.
//  Copyright (c) 2014 Createanet. All rights reserved.
//

#import "TodayViewController.h"
#import "ParserWidget.h"
#import <NotificationCenter/NotificationCenter.h>
#import "AsyncImageView.h"

@interface TodayViewController () <NCWidgetProviding> {
    NSArray *items;
}

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //[self loadData];
    
}

- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)loadData {
    
    NSLog(@"Load Data");
        
    ParserWidget *rssParser = [[ParserWidget alloc] init];
    [rssParser parseRssFeed:@"http://www.goal.com/en-gb/feeds/news?id=2896&fmt=rss&ICID=SP" withDelegate:self];
    
}

- (void)receivedItems:(NSArray *)theItems {
    
    if (theItems.count>0) {
        
        items = theItems;
        [self.tableView reloadData];
        
        [self hideTxtLabel];
        
    } else {
        
        [self showTxtLabel];
        
        [self rssErrored:@"Something went wrong, please reload notification centre to try again."];
        
    }
}

- (void)rssErrored:(NSString *)error {
    
    [self showTxtLabel];
    
    [_txtLabel setText:error];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *link = items[indexPath.row][@"link"];
    
    if (link) {
        NSExtensionContext *extensionContext = [self extensionContext];
        [extensionContext openURL:[NSURL URLWithString:link] completionHandler:nil];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifer = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifer];
    }
    
    UILabel *label = (UILabel *)[cell viewWithTag:101];
    label.text = [[items objectAtIndex:indexPath.row] objectForKey:@"title"];
    
    UILabel *date = (UILabel *)[cell viewWithTag:103];
    NSString *dateString = [[items objectAtIndex:indexPath.row] objectForKey:@"date"];
    dateString = [dateString stringByReplacingOccurrencesOfString:@" +0000" withString:@""];
    NSString *newStr = [dateString substringToIndex:[dateString length]-3];
    
    UIImageView *footballImage = (UIImageView *)[cell viewWithTag:102];
    [footballImage setImageURL:[NSURL URLWithString:[[items objectAtIndex:indexPath.row] objectForKey:@"podcastLink"]]];
    
    date.text=newStr;
    
    [label setFrame:CGRectMake(label.frame.origin.x, label.frame.origin.y, _tableView.frame.size.width-label.frame.origin.x-7, label.frame.size.height)];
    
    UIImageView *seperator = (UIImageView *)[cell viewWithTag:104];
    
    [seperator setHidden:NO];
    
    if (indexPath.row==3) {
        //[seperator setHidden:YES];
    }
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    
    [_txtLabel setText:@"Loading News Stories..."];
    
    if (items.count==0) {
        [self showTxtLabel];
    }
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(loadData) userInfo:nil repeats:NO];
    
    completionHandler(NCUpdateResultNewData);
}

-(void)showTxtLabel {
    
    [_txtLabel setHidden:NO];
    [_tableView setHidden:YES];
    
    self.preferredContentSize = CGSizeMake(0, 332);
    
}

-(void)hideTxtLabel {
    
    [_txtLabel setHidden:YES];
    [_tableView setHidden:NO];
    
    self.preferredContentSize = CGSizeMake(0, 332);
    
}

- (IBAction)viewMoreArticles:(id)sender {
    
    NSString *link = @"footballform://news/premier-league";
    
    if (link) {
        NSExtensionContext *extensionContext = [self extensionContext];
        [extensionContext openURL:[NSURL URLWithString:link] completionHandler:nil];
    }
    
}


@end
