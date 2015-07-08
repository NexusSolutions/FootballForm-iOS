//
//  ViewController.m
//  GettingStarted
//
//  Created by Colin Eberhardt on 04/07/2013.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import "ViewController.h"
#import <ShinobiCharts/ShinobiChart.h>

@interface ViewController () <SChartDatasource>

@end

@implementation ViewController
{
    ShinobiChart* _chart;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Create the chart
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat margin = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) ? 10.0 : 50.0;
    _chart = [[ShinobiChart alloc] initWithFrame:CGRectInset(self.view.bounds, margin, margin)];
    _chart.title = @"Trigonometric Functions";
    
   _chart.autoresizingMask =  ~UIViewAutoresizingNone;
    
    _chart.licenseKey = @""; // TODO: add your trial licence key here!
    
    // add a pair of axes
    SChartNumberAxis *xAxis = [[SChartNumberAxis alloc] init];
    xAxis.title = @"X Value";
    
    _chart.xAxis = xAxis;
    
    SChartNumberAxis *yAxis = [[SChartNumberAxis alloc] init];
    yAxis.title = @"Y Value";
    yAxis.rangePaddingLow = @(0.1);
    yAxis.rangePaddingHigh = @(0.1);
    _chart.yAxis = yAxis;

    // enable gestures
    yAxis.enableGesturePanning = YES;
    yAxis.enableGestureZooming = YES;
    xAxis.enableGesturePanning = YES;
    xAxis.enableGestureZooming = YES;
    
    
    // add to the view
    [self.view addSubview:_chart];
    
    _chart.datasource = self;
    
     _chart.legend.hidden = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone);
}

#pragma mark - SChartDatasource methods

- (NSInteger)numberOfSeriesInSChart:(ShinobiChart *)chart {
    return 2;
}

-(SChartSeries *)sChart:(ShinobiChart *)chart seriesAtIndex:(NSInteger)index {
    
    SChartLineSeries *lineSeries = [[SChartLineSeries alloc] init];
    lineSeries.style.showFill = YES;
    
    // the first series is a cosine curve, the second is a sine curve
    if (index == 0) {
        lineSeries.title = [NSString stringWithFormat:@"y = cos(x)"];
    } else {
        lineSeries.title = [NSString stringWithFormat:@"y = sin(x)"];
    }
    
    return lineSeries;
}

- (NSInteger)sChart:(ShinobiChart *)chart numberOfDataPointsForSeriesAtIndex:(NSInteger)seriesIndex {
    return 100;
}

- (id<SChartData>)sChart:(ShinobiChart *)chart dataPointAtIndex:(NSInteger)dataIndex forSeriesAtIndex:(NSInteger)seriesIndex {
    
    SChartDataPoint *datapoint = [[SChartDataPoint alloc] init];
    
    // both functions share the same x-values
    double xValue = dataIndex / 10.0;
    datapoint.xValue = [NSNumber numberWithDouble:xValue];
    
    // compute the y-value for each series
    if (seriesIndex == 0) {
        datapoint.yValue = [NSNumber numberWithDouble:cosf(xValue)];
    } else {
        datapoint.yValue = [NSNumber numberWithDouble:sinf(xValue)];
    }
    
    return datapoint;
}

@end
