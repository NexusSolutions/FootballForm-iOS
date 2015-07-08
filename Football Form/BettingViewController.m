//
//  BettingViewController.m
//  Football Form
//
//  Created by Aaron Wilkinson on 03/10/2014.
//  Copyright (c) 2014 Createanet. All rights reserved.
//

#import "BettingViewController.h"

@interface BettingViewController ()

@end

@implementation BettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [_spinner stopAnimating];
    [_spinner setHidden:YES];
    
    NSString *urlAddress = @"http://affiliatehub.skybet.com/processing/clickthrgh.asp?btag=a_15777b_1";
    
    //Create a URL object.
    NSURL *url = [NSURL URLWithString:urlAddress];
    
    //URL Requst Object
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    //Load the request in the UIWebView.
    [_webView loadRequest:requestObj];
    
}


-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [_spinner stopAnimating];
    [_spinner setHidden:YES];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Loading Betting" message:error.localizedDescription delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [_spinner stopAnimating];
    [_spinner setHidden:YES];
}

-(void)webViewDidStartLoad:(UIWebView *)webView {
    [_spinner startAnimating];
    [_spinner setHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)showPeek:(id)sender {
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    PKRevealController *revealController = (PKRevealController *) appDelegate.window.rootViewController;
    [revealController showViewController:revealController.leftViewController];
    
}
@end
