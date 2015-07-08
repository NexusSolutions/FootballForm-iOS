//
//  ViewController.m
//  TimeSeriesChart
//
//  Created by Colin Eberhardt on 08/07/2013.
//  Copyright (c) 2013 ShinobiControls. All rights reserved.
//

#import "ViewController.h"
#import <ShinobiCharts/ShinobiChart.h>

@interface ViewController () <SChartDatasource>

@end

@implementation ViewController
{
    ShinobiChart* _chart;
    NSMutableArray* _timeSeries;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Create the chart
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat margin = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) ? 10.0 : 50.0;
    _chart = [[ShinobiChart alloc] initWithFrame:CGRectInset(self.view.bounds, margin, margin)];
    _chart.title = @"Apple Stock Price";
    
    _chart.autoresizingMask =  ~UIViewAutoresizingNone;
    
    _chart.licenseKey = @""; // TODO: add your trial licence key here!
    
    // add a discontinuous date axis
    SChartDiscontinuousDateTimeAxis *xAxis = [[SChartDiscontinuousDateTimeAxis alloc] init];
    
    // a time period that defines the weekends
    SChartRepeatedTimePeriod* weekends = [[SChartRepeatedTimePeriod alloc] initWithStart:[self dateFromString:@"02-01-2010"]
                                                                              andLength:[SChartDateFrequency dateFrequencyWithDay:2]
                                                                           andFrequency:[SChartDateFrequency dateFrequencyWithWeek:1]];
    [xAxis addExcludedRepeatedTimePeriod:weekends];
    xAxis.title = @"Date";
    _chart.xAxis = xAxis;
    
    SChartNumberAxis *yAxis = [[SChartNumberAxis alloc] init];
    yAxis.title = @"Price (USD)";
    _chart.yAxis = yAxis;
    
    // create some data
    [self loadChartData];
    
    // enable gestures
    yAxis.enableGesturePanning = YES;
    yAxis.enableGestureZooming = YES;
    xAxis.enableGesturePanning = YES;
    xAxis.enableGestureZooming = YES;
    
    // add to the view
    [self.view addSubview:_chart];
    
    _chart.datasource = self;
}

- (void)loadChartData {
    
    _timeSeries = [NSMutableArray new];
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"AppleStockPrices" ofType:@"json"];
    
    NSData* json = [NSData dataWithContentsOfFile:filePath];
    
    NSArray* data = [NSJSONSerialization JSONObjectWithData:json
                                                 options:NSJSONReadingAllowFragments
                                                   error:nil];

    for (NSDictionary* jsonPoint  in data) {
        SChartDataPoint* datapoint = [self dataPointForDate:jsonPoint[@"date"]
                                                  andValue:jsonPoint[@"close"]];
        [_timeSeries addObject:datapoint];
    }
    
}

#pragma mark - utility methods

- (NSDate*) dateFromString:(NSString*)date {
    static NSDateFormatter *dateFormatter;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    }
    return [dateFormatter dateFromString:date];
}

- (SChartDataPoint*)dataPointForDate:(NSString*)date andValue:(NSNumber*)value {
    SChartDataPoint* dataPoint = [SChartDataPoint new];
    dataPoint.xValue = [self dateFromString:date];
    dataPoint.yValue = value;
    return dataPoint;    
}

#pragma mark - SChartDatasource methods

- (NSInteger)numberOfSeriesInSChart:(ShinobiChart *)chart {
    return 1;
}

-(SChartSeries *)sChart:(ShinobiChart *)chart seriesAtIndex:(NSInteger)index {
    SChartLineSeries *lineSeries = [[SChartLineSeries alloc] init];
    return lineSeries;
}

- (NSInteger)sChart:(ShinobiChart *)chart numberOfDataPointsForSeriesAtIndex:(NSInteger)seriesIndex {
    return _timeSeries.count;
}

- (id<SChartData>)sChart:(ShinobiChart *)chart dataPointAtIndex:(NSInteger)dataIndex forSeriesAtIndex:(NSInteger)seriesIndex {
    return _timeSeries[dataIndex];
}

@end
