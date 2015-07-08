//
//  ViewController.m
//  PieChart
//
//  Created by Colin Eberhardt on 08/07/2013.
//  Copyright (c) 2013 ShinobiControls. All rights reserved.
//

#import "ViewController.h"
#import <ShinobiCharts/ShinobiChart.h>

@interface ViewController () <SChartDatasource, SChartDelegate>

@end

@implementation ViewController
{
    ShinobiChart* _chart;
    NSDictionary* _countrySize;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // create the data
     _countrySize = @{@"Russia" : @17, @"Canada" : @9.9, @"USA" : @9.6,
                      @"China" : @9.5, @"Brazil" : @8.5, @"Australia" : @7.6};
    
    // Create the chart
    CGFloat margin = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) ? 10.0 : 50.0;
    _chart = [[ShinobiChart alloc] initWithFrame:CGRectInset(self.view.bounds, margin, margin)];
    _chart.title = @"Countries By Area";
    
    // ensure the chart fills the screen
    _chart.autoresizingMask =  ~UIViewAutoresizingNone;
    
    // TODO: add your trial licence key here!
    _chart.licenseKey = @"";
    
    // add to the view
    [self.view addSubview:_chart];
    
    // this view controller acts as the datasource
    _chart.datasource = self;
    _chart.delegate = self;
    
    // show the legend
    _chart.legend.hidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SChartDelegate methods

- (void)sChart:(ShinobiChart *)chart toggledSelectionForRadialPoint:(SChartRadialDataPoint *)dataPoint inSeries:(SChartRadialSeries *)series atPixelCoordinate:(CGPoint)pixelPoint{
    NSLog(@"Selected country: %@", dataPoint.name);
}

#pragma mark - SChartDatasource methods

- (NSInteger)numberOfSeriesInSChart:(ShinobiChart *)chart {
    return 1;
}

-(SChartSeries *)sChart:(ShinobiChart *)chart seriesAtIndex:(NSInteger)index {
    SChartPieSeries* pieSeries = [[SChartPieSeries alloc] init];
    pieSeries.selectedStyle.protrusion = 10.0f;
    pieSeries.selectionAnimation.duration = @0.4;
    pieSeries.selectedPosition = @0.0;
    return pieSeries;
}

- (NSInteger)sChart:(ShinobiChart *)chart numberOfDataPointsForSeriesAtIndex:(NSInteger)seriesIndex {
    return _countrySize.allKeys.count;
}

- (id<SChartData>)sChart:(ShinobiChart *)chart dataPointAtIndex:(NSInteger)dataIndex forSeriesAtIndex:(NSInteger)seriesIndex {
    SChartRadialDataPoint *datapoint = [[SChartRadialDataPoint alloc] init];
    NSString* key = _countrySize.allKeys[dataIndex];
    datapoint.name = key;
    datapoint.value = _countrySize[key];
    return datapoint;
}

@end
