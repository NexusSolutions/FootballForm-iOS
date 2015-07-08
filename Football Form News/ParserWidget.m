//
//  ParserWidget.m
//  Football Form
//
//  Created by Aaron Wilkinson on 16/10/2014.
//  Copyright (c) 2014 Createanet. All rights reserved.
//

#import "ParserWidget.h"

@implementation ParserWidget

@synthesize items, responseData;
@synthesize currentTitle;
@synthesize currentDate;
@synthesize currentSummary;
@synthesize currentLink;
@synthesize currentPodcastLink;

- (void)parseRssFeed:(NSString *)url withDelegate:(id)aDelegate {
    [self setDelegate:aDelegate];
    
    responseData = [NSMutableData data];
    NSURL *baseURL = [NSURL URLWithString:url];
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:baseURL];
    
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    responseStatusCode = (int)[httpResponse statusCode];
    
    if (responseStatusCode!=200) {
        
        if ([_delegate respondsToSelector:@selector(rssErrored:)]) {
            [_delegate rssErrored:@"Something went wrong, please reload notification centre to try again."];
        } else {
            [NSException raise:NSInternalInconsistencyException
                        format:@"Delegate doesn't respond to rssErrored:"];
        }

    } else {
        
        [responseData setLength:0];
        
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    [responseData appendData:data];
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    /*NSString * errorString = [NSString stringWithFormat:@"It doesn't look like you've got an internet connection, or we've been unable to reach the Football Form feed. If the issue persists, please contact us. (Error code %i )", [error code]];
    
    UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Error loading content" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];*/
    
    //NEED TO PASS ERROR
    
    if ([_delegate respondsToSelector:@selector(rssErrored:)])
        [_delegate rssErrored:@"An internet connection is required to access the latest football news. Please connect to the internet to continue."];
    else
    {
        [NSException raise:NSInternalInconsistencyException
                    format:@"Delegate doesn't respond to rssErrored:"];
    }

    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    self.items = [[NSMutableArray alloc] init];
    
    NSXMLParser *rssParser = [[NSXMLParser alloc] initWithData:responseData];
    
    [rssParser setDelegate:self];
    
    [rssParser parse];
    
}

#pragma mark rssParser methods

- (void)parserDidStartDocument:(NSXMLParser *)parser {
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    
    
    NSString *param3 = nil;
    NSRange start3 = [currentSummary rangeOfString:@";\">"];
    if (start3.location != NSNotFound)
    {
        param3 = [currentSummary substringFromIndex:start3.location + start3.length];
        NSRange end3 = [param3 rangeOfString:@"</p>"];
        if (end3.location != NSNotFound)
        {
            param3 = [param3 substringToIndex:end3.location];
        }
        
    }
    
    if (param3!=nil) {
        
        currentSummary = param3;
        
    }
    
    currentElement = [elementName copy];
    
    if ([elementName isEqualToString:@"item"]) {
        item = [[NSMutableDictionary alloc] init];
        self.currentTitle = [[NSMutableString alloc] init];
        self.currentDate = [[NSMutableString alloc] init];
        self.currentSummary = [[NSMutableString alloc] init];
        self.currentLink = [[NSMutableString alloc] init];
        self.currentPodcastLink = [[NSMutableString alloc] init];
        
        
    }
    
    // podcast url is an attribute of the element enclosure
    if ([currentElement isEqualToString:@"enclosure"]) {
        [currentPodcastLink appendString:[attributeDict objectForKey:@"url"]];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
    if ([elementName isEqualToString:@"item"]) {
        [item setObject:self.currentTitle forKey:@"title"];
        [item setObject:self.currentLink forKey:@"link"];
        [item setObject:self.currentSummary forKey:@"summary"];
        [item setObject:self.currentPodcastLink forKey:@"podcastLink"];
        [item setObject:self.currentDate forKey:@"date"];
        
        /*
         //self.currentDate = [self.currentDate stringByReplacingOccurrencesOfString:@"\n" withString:@""];
         
         NSString *immutableString = [NSString stringWithString:self.currentDate];
         immutableString = [immutableString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
         
         // Parse date here
         NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
         
         [dateFormatter setDateFormat:@"E, d LLL yyyy HH:mm:ss Z"]; // Thu, 18 Jun 2010 04:48:09 -0700
         NSDate *date = [dateFormatter dateFromString:immutableString];
         
         NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
         [formatter setDateFormat:@"E d LLL yyyy HH:mm"];
         //uncomment to get the time only
         //[formatter setDateFormat:@"hh:mm a"];
         //[formatter setDateFormat:@"MMM dd, YYYY"];
         [formatter setDateStyle:NSDateFormatterMediumStyle];
         
         
         //get the date today
         NSString *parsedDate = [formatter stringFromDate:date];
         
         if (parsedDate != nil) {
         [item setObject:parsedDate forKey:@"date"];
         
         }
         */
        
        [items addObject:[item copy]];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    if ([currentElement isEqualToString:@"title"]) {
        [self.currentTitle appendString:string];
    } else if ([currentElement isEqualToString:@"link"]) {
        [self.currentLink appendString:string];
    } else if ([currentElement isEqualToString:@"description"]) {
        [self.currentSummary appendString:string];
    }else if ([currentElement isEqualToString:@"pubDate"]) {
        [self.currentDate appendString:string];
        NSCharacterSet* charsToTrim = [NSCharacterSet characterSetWithCharactersInString:@" \n"];
        [self.currentDate setString: [self.currentDate stringByTrimmingCharactersInSet: charsToTrim]];
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
    if (responseStatusCode==200) {

        if ([_delegate respondsToSelector:@selector(receivedItems:)]) {
            [_delegate receivedItems:items];
        } else {
            [NSException raise:NSInternalInconsistencyException format:@"Delegate doesn't respond to receivedItems:"];
        }
    }
}

#pragma mark Delegate methods

- (id)delegate {
    return _delegate;
}

- (void)setDelegate:(id)new_delegate {
    _delegate = new_delegate;
}

@end
