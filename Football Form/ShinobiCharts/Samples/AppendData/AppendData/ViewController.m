//
//  ViewController.m
//  AppendData
//
//  Created by Daniel Gorst on 26/06/2013.
//  Copyright (c) 2013 Scott Logic. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()    {
    NSInteger _currentDataIndex;
    NSTimer *_timer;
    NSMutableArray *_streamedData;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Create the chart
    self.chart = [[ShinobiChart alloc] initWithFrame:CGRectInset(self.view.bounds,20,20)];
    self.chart.title = @"Streaming";
    self.chart.autoresizingMask = ~UIViewAutoresizingNone;
    
    self.chart.licenseKey = @""; // TODO: add your trial licence key here!
    
    // Use a number axis for the x axis.
    self.chart.xAxis = [[SChartNumberAxis alloc] init];
    
    // Use a number axis for the y axis.
    self.chart.yAxis = [[SChartNumberAxis alloc] init];
    
    self.chart.datasource = self;
    
    // Add the chart to the view controller
    [self.view addSubview:self.chart];
    
    // Initialize our data
    _streamedData = [NSMutableArray array];
    for (unsigned int i = 0; i < 360; ++i)  {
        [_streamedData addObject:[self dataPointWithIndex:i]];
    }
    _currentDataIndex = _streamedData.count;
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(update) userInfo:nil repeats:YES];
}

- (SChartDataPoint*)dataPointWithIndex:(NSInteger)index  {
    SChartDataPoint *datapoint = [[SChartDataPoint alloc] init];
    datapoint.xValue = @(index);
    datapoint.yValue = @([self sinOfValue:index]);
    return datapoint;
}

- (double)sinOfValue:(int)value  {
    double valueInRadians = value * (M_PI / 180.0);
    return sin(valueInRadians);
}

- (void)update  {
    // Update our data, by adding a new value, and removing the first value
    [_streamedData addObject:[self dataPointWithIndex:_currentDataIndex]];
    [_streamedData removeObjectAtIndex:0];
    ++_currentDataIndex;
    
    // Refresh the chart
    [self.chart removeNumberOfDataPoints:1 fromStartOfSeriesAtIndex:0];
    [self.chart appendNumberOfDataPoints:1 toEndOfSeriesAtIndex:0];
    [self.chart redrawChart];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation   {
    return YES;
}

#pragma mark - SChartDatasource

// Returns the number of series in the specified chart
- (NSInteger)numberOfSeriesInSChart:(ShinobiChart *)chart {
    return 1;
}

// Returns the series at the specified index for a given chart
-(SChartSeries *)sChart:(ShinobiChart *)chart seriesAtIndex:(NSInteger)index {
    
    // In our example all series are line series.
    SChartLineSeries *lineSeries = [[SChartLineSeries alloc] init];
    lineSeries.style.lineWidth = @(2);
    return lineSeries;
}

// Returns the number of points for a specific series in the specified chart
- (NSInteger)sChart:(ShinobiChart *)chart numberOfDataPointsForSeriesAtIndex:(NSInteger)seriesIndex {
    return _streamedData.count;
}

// Returns the data point at the specified index for the given series/chart.
- (id<SChartData>)sChart:(ShinobiChart *)chart dataPointAtIndex:(NSInteger)dataIndex forSeriesAtIndex:(NSInteger)seriesIndex {
    return [_streamedData objectAtIndex:dataIndex];
}

@end
