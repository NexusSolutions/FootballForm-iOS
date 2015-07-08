//
//  Parser.m
//  RssReader
//
//  Created by myApps on 6/18/10.
//  Copyright 2011 myApps. All rights reserved.
//

#import "Parser.h"


@implementation Parser

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

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
    
    [responseData appendData:data];
    

}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSString * errorString = [NSString stringWithFormat:@"It doesn't look like you've got an internet connection, or we've been unable to reach the Football Form feed. If the issue persists, please contact us. (Error code %i )", [error code]];
	
    UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Error loading content" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
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
    /*
    [currentSummary replaceOccurrencesOfString:@"/>"
                                    withString:@"/><br>"
                                       options:0
                                         range:NSMakeRange(0, [currentSummary length])];
    
    
    [currentSummary replaceOccurrencesOfString:@"<br><br><br><br>"
                                    withString:@"<br><br><font size=5>"
                                       options:0
                                         range:NSMakeRange(0, [currentSummary length])];
    
    [currentSummary replaceOccurrencesOfString:@"<img"
                                    withString:@"<center><img"
                                       options:0
                                         range:NSMakeRange(0, [currentSummary length])];
     */
    
    
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
	if ([_delegate respondsToSelector:@selector(receivedItems:)])
        [_delegate receivedItems:items];
    else
    {
        [NSException raise:NSInternalInconsistencyException
					format:@"Delegate doesn't respond to receivedItems:"];
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
