//
//  ViewController.m
//  BubbleSeries
//
//  Created by Colin Eberhardt on 18/07/2013.
//  Copyright (c) 2013 ShinobiControls. All rights reserved.
//

#import "ViewController.h"
#import <ShinobiCharts/ShinobiChart.h>

@interface ViewController () <SChartDatasource>

@end

@implementation ViewController
{
    NSMutableArray* _data;
    ShinobiChart* _chart;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // Create the chart
    CGFloat margin = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) ? 10.0 : 50.0;
    _chart = [[ShinobiChart alloc] initWithFrame:CGRectInset(self.view.bounds, margin, margin)];
    _chart.title = @"Project Commit Punchcard";
    
    _chart.autoresizingMask =  ~UIViewAutoresizingNone;
    
    _chart.licenseKey = @""; // TODO: add your trial licence key here!
    
    // add a pair of axes
    SChartCategoryAxis *yAxis = [[SChartCategoryAxis alloc] init];
    yAxis.title = @"Day";
    yAxis.rangePaddingHigh = @0.5;
    yAxis.rangePaddingLow = @0.5;
    _chart.yAxis = yAxis;
    
    SChartAxis *xAxis = [[SChartNumberAxis alloc] init];
    xAxis.rangePaddingHigh = @0.5;
    xAxis.rangePaddingLow = @0.5;
    xAxis.title = @"Hour";
    _chart.xAxis = xAxis;
    
    [self loadChartData];
    
    // add to the view
    [self.view addSubview:_chart];
    
    _chart.datasource = self;
    
}

- (void)loadChartData {
    
    _data = [[NSMutableArray alloc] init];
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"punchcard" ofType:@"json"];
    NSData* json = [NSData dataWithContentsOfFile:filePath];
    NSArray* data = [NSJSONSerialization JSONObjectWithData:json
                                                    options:NSJSONReadingAllowFragments
                                                      error:nil];
    
    for (NSDictionary* jsonPoint  in data) {
        NSUInteger commits = [((NSNumber*)jsonPoint[@"commits"]) intValue];
        if (commits > 0) {
            SChartBubbleDataPoint* point = [[SChartBubbleDataPoint alloc] init];
            point.xValue = jsonPoint[@"hour"];
            point.yValue = jsonPoint[@"day"];
            point.area =  commits;
            [_data addObject:point];
        }
    
    }
}

#pragma mark - SChartDatasource methods

- (NSInteger)numberOfSeriesInSChart:(ShinobiChart *)chart {
    return 1;
}

-(SChartSeries *)sChart:(ShinobiChart *)chart seriesAtIndex:(NSInteger)index {
    SChartBubbleSeries* series = [[SChartBubbleSeries alloc] init];
    series.biggestBubbleDiameterForAutoScaling = @40;
    return series;
}

- (NSInteger)sChart:(ShinobiChart *)chart numberOfDataPointsForSeriesAtIndex:(NSInteger)seriesIndex {
    return _data.count;
}

- (id<SChartData>)sChart:(ShinobiChart *)chart dataPointAtIndex:(NSInteger)dataIndex forSeriesAtIndex:(NSInteger)seriesIndex {
    return _data[dataIndex];
}

@end