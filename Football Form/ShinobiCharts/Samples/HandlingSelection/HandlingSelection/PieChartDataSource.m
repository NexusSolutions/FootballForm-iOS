//
//  PieChartDataSource.m
//  HandlingSelection
//
//  Created by Colin Eberhardt on 16/07/2013.
//  Copyright (c) 2013 ShinobiControls. All rights reserved.
//

#import "PieChartDataSource.h"

@implementation PieChartDataSource
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

- (NSDictionary*)dataForYear {
    NSDictionary* salesForYear = _sales[self.displayYear];
    return salesForYear;
}

#pragma mark - SChartDatasource methods

- (int)numberOfSeriesInSChart:(ShinobiChart *)chart {
    return 1;
}

-(SChartSeries *)sChart:(ShinobiChart *)chart seriesAtIndex:(int)index {
    SChartPieSeries *lineSeries = [[SChartPieSeries alloc] init];
    return lineSeries;
}

- (int)sChart:(ShinobiChart *)chart numberOfDataPointsForSeriesAtIndex:(int)seriesIndex {
   return [self dataForYear].count;
}

- (id<SChartData>)sChart:(ShinobiChart *)chart dataPointAtIndex:(int)dataIndex forSeriesAtIndex:(int)seriesIndex {
    SChartDataPoint *datapoint = [[SChartDataPoint alloc] init];
    
    NSDictionary* salesForYear = [self dataForYear];
    
    NSString* key = salesForYear.allKeys[dataIndex];
    datapoint.xValue = key;
    datapoint.yValue = salesForYear[key];
    return datapoint;
}

@end
