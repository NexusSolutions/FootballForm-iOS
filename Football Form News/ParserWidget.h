//
//  ParserWidget.h
//  Football Form
//
//  Created by Aaron Wilkinson on 16/10/2014.
//  Copyright (c) 2014 Createanet. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ParserDelegate <NSObject>
- (void)receivedItems:(NSArray *)theItems;
- (void)rssErrored:(NSString *)error;
@end

@interface ParserWidget : NSObject <NSXMLParserDelegate> {
    id _delegate;
    
    NSMutableData *responseData;
    NSMutableArray *items;
    
    NSMutableDictionary *item;
    NSString *currentElement;
    NSMutableString * currentTitle, * currentDate, * currentSummary, * currentLink, * currentPodcastLink;
    
    int responseStatusCode;
}

@property (retain, nonatomic) NSMutableData *responseData;
@property (retain, nonatomic) NSMutableArray *items;
@property (retain, nonatomic) NSMutableString *currentTitle;
@property (retain, nonatomic) NSMutableString *currentDate;
@property (retain, nonatomic) NSMutableString *currentSummary;
@property (retain, nonatomic) NSMutableString *currentLink;
@property (retain, nonatomic) NSMutableString *currentPodcastLink;

- (void)parseRssFeed:(NSString *)url withDelegate:(id)aDelegate;

- (id)delegate;
- (void)setDelegate:(id)new_delegate;
@end
