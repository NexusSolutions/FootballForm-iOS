//
//  ViewController.m
//  ColumnSeries
//
//  Created by Colin Eberhardt on 04/07/2013.
//  Copyright (c) 2013 ShinobiControls. All rights reserved.
//

#import "ViewController.h"
#import <ShinobiCharts/ShinobiChart.h>

@interface ViewController () <SChartDatasource>

@end

@implementation ViewController
{
    NSDictionary* _sales[2];
    ShinobiChart* _chart;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _sales[0] = @{@"Broccoli" : @5.65, @"Carrots" : @12.6, @"Mushrooms" : @8.4};
    _sales[1] = @{@"Broccoli" : @4.35, @"Carrots" : @13.2, @"Mushrooms" : @4.6, @"Okra" : @0.6};
	
    // Create the chart
    CGFloat margin = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) ? 10.0 : 50.0;
    _chart = [[ShinobiChart alloc] initWithFrame:CGRectInset(self.view.bounds, margin, margin)];
    _chart.title = @"Grocery Sales Figures";
    
    _chart.autoresizingMask =  ~UIViewAutoresizingNone;
    
    _chart.licenseKey = @""; // TODO: add your trial licence key here!
    
    // add a pair of axes
    SChartCategoryAxis *xAxis = [[SChartCategoryAxis alloc] init];
    xAxis.style.interSeriesPadding = @0;
    _chart.xAxis = xAxis;
    
    SChartAxis *yAxis = [[SChartNumberAxis alloc] init];
    yAxis.title = @"Sales (1000s)";
    yAxis.rangePaddingHigh = @1.0;
    _chart.yAxis = yAxis;
    
    
    // add to the view
    [self.view addSubview:_chart];
    
    _chart.datasource = self;
    
    // show the legend 
    _chart.legend.hidden = NO;
    _chart.legend.placement = SChartLegendPlacementInsidePlotArea;
}

#pragma mark - SChartDatasource methods

- (NSInteger)numberOfSeriesInSChart:(ShinobiChart *)chart {
    return 2;
}

-(SChartSeries *)sChart:(ShinobiChart *)chart seriesAtIndex:(NSInteger)index {
    SChartColumnSeries *lineSeries = [[SChartColumnSeries alloc] init];
    lineSeries.title = index == 0 ? @"2011" : @"2012";
    return lineSeries;
}

- (NSInteger)sChart:(ShinobiChart *)chart numberOfDataPointsForSeriesAtIndex:(NSInteger)seriesIndex {
    return _sales[seriesIndex].allKeys.count;
}

- (id<SChartData>)sChart:(ShinobiChart *)chart dataPointAtIndex:(NSInteger)dataIndex forSeriesAtIndex:(NSInteger)seriesIndex {
    SChartDataPoint *datapoint = [[SChartDataPoint alloc] init];
    NSString* key = _sales[seriesIndex].allKeys[dataIndex];
    datapoint.xValue = key;
    datapoint.yValue = _sales[seriesIndex][key];
    return datapoint;
}

@end
