//
//  ColumnChartDataSource.m
//  HandlingSelection
//
//  Created by Colin Eberhardt on 16/07/2013.
//  Copyright (c) 2013 ShinobiControls. All rights reserved.
//

#import "ColumnChartDataSource.h"

@implementation ColumnChartDataSource
{
    NSDictionary* _sales;
}

- (id)initWithSales:(NSDictionary *)sales displayYear:(NSString *)year {
    if(self = [super init]) {
        _sales = sales;
        _displayYear = year;
    }
    return self;
}


#pragma mark - SChartDatasource methods

- (int)numberOfSeriesInSChart:(ShinobiChart *)chart {
    return _sales.count;
}

-(SChartSeries *)sChart:(ShinobiChart *)chart seriesAtIndex:(int)index {
    SChartColumnSeries *lineSeries = [[SChartColumnSeries alloc] init];
    NSString* year = _sales.allKeys[index];
    lineSeries.title = year;
    lineSeries.selectionMode = SChartSelectionSeries;
    lineSeries.style.showAreaWithGradient = NO;
    lineSeries.selectedStyle.showAreaWithGradient = NO;
    lineSeries.selectedStyle.areaColor = [UIColor redColor];
    lineSeries.selectedStyle.lineWidth = @0.0;
    
    // set the selected state of the line series - this reflects the initial UI state
    lineSeries.selected = [year isEqualToString:self.displayYear];
    return lineSeries;
}

- (int)sChart:(ShinobiChart *)chart numberOfDataPointsForSeriesAtIndex:(int)seriesIndex {
    NSString* year = _sales.allKeys[seriesIndex];
    NSDictionary* salesForYear = _sales[year];
    return salesForYear.count;
}

- (id<SChartData>)sChart:(ShinobiChart *)chart dataPointAtIndex:(int)dataIndex forSeriesAtIndex:(int)seriesIndex {
    SChartDataPoint *datapoint = [[SChartDataPoint alloc] init];
    
    NSString* year = _sales.allKeys[seriesIndex];
    NSDictionary* salesForYear = _sales[year];
    
    NSString* key = salesForYear.allKeys[dataIndex];
    datapoint.xValue = key;
    datapoint.yValue = salesForYear[key];
    return datapoint;
}


@end
