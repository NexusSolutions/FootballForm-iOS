//
//  ViewController.m
//  HandlingSelection
//
//  Created by Colin Eberhardt on 15/07/2013.
//  Copyright (c) 2013 ShinobiControls. All rights reserved.
//

#import "ViewController.h"
#import <ShinobiCharts/ShinobiChart.h>
#import "ColumnChartDataSource.h"
#import "PieChartDataSource.h"

@interface ViewController () <SChartDelegate>

@end

@implementation ViewController
{
    NSDictionary* _sales;
    ShinobiChart* _columnChart;
    ShinobiChart* _pieChart;
    
    ColumnChartDataSource* _columnChartDataSource;
    PieChartDataSource* _pieChartDataSource;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // create the data
    _sales = @{@"2012": @{@"Broccoli" : @5.65, @"Carrots" : @12.6, @"Mushrooms" : @8.4},
               @"2013": @{@"Broccoli" : @4.35, @"Carrots" : @13.2, @"Mushrooms" : @4.6, @"Okra" : @0.6}};
    
    // create datasources for each chart
    _columnChartDataSource = [[ColumnChartDataSource alloc] initWithSales:_sales  displayYear:@"2012"];
    _pieChartDataSource = [[PieChartDataSource alloc] initWithSales:_sales displayYear:@"2012"];
	
    // create the charts
    [self createColumnChart:CGRectMake(0, 0,self.view.bounds.size.width, self.view.bounds.size.height / 2)];
    [self createPieChart:CGRectMake(0, self.view.bounds.size.height / 2, self.view.bounds.size.width, self.view.bounds.size.height / 2)];
}

- (void)createPieChart:(CGRect)frame {
    
    // Create the chart
    CGFloat margin = 40.0;
    _pieChart = [[ShinobiChart alloc] initWithFrame:CGRectInset(frame, margin, margin)];
    [self updatePieTitle];
    
    _pieChart.autoresizingMask =  ~UIViewAutoresizingNone;
    
    _pieChart.licenseKey = @""; // TODO: add your trial licence key here!
    
    // add to the view
    [self.view addSubview:_pieChart];
    
    _pieChart.datasource = _pieChartDataSource;
    
    // show the legend
    _pieChart.legend.hidden = NO;
}

- (void) updatePieTitle {
    _pieChart.title = [NSString stringWithFormat:@"Grocery Sales For %@", _pieChartDataSource.displayYear];
}

- (void)createColumnChart:(CGRect)frame {
    
    // Create the chart
    CGFloat margin = 40.0;
    _columnChart = [[ShinobiChart alloc] initWithFrame:CGRectInset(frame, margin, margin)];
    _columnChart.title = @"Grocery Sales Figures";
    
    _columnChart.autoresizingMask =  ~UIViewAutoresizingNone;
    
    _columnChart.licenseKey = @""; // TODO: add your trial licence key here!
    
    // add a pair of axes
    SChartCategoryAxis *xAxis = [[SChartCategoryAxis alloc] init];
    xAxis.style.interSeriesPadding = @0;
    _columnChart.xAxis = xAxis;
    
    SChartAxis *yAxis = [[SChartNumberAxis alloc] init];
    yAxis.title = @"Sales (1000s)";
    yAxis.rangePaddingHigh = @1.0;
    _columnChart.yAxis = yAxis;    
    
    // add to the view
    [self.view addSubview:_columnChart];
    
    _columnChart.datasource = _columnChartDataSource;
    _columnChart.delegate = self;    
    
    // show the legend
    _columnChart.legend.hidden = NO;
    _columnChart.legend.placement = SChartLegendPlacementInsidePlotArea;
}

-(void)sChart:(ShinobiChart *)chart toggledSelectionForSeries:(SChartSeries *)series nearPoint:(SChartDataPoint *)dataPoint atPixelCoordinate:(CGPoint)pixelPoint {
    
    // determine which year was tapped
    NSString* tappedYear = series.title;
    
    // update the datasources
    _columnChartDataSource.displayYear = tappedYear;
    _pieChartDataSource.displayYear = tappedYear;
    
    // update the pie chart state
    [self updatePieTitle];
    [_pieChart reloadData];
    [_pieChart redrawChart];
}




@end
