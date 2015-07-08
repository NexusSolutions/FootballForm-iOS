//
//  PieChartDataSource.h
//  HandlingSelection
//
//  Created by Colin Eberhardt on 16/07/2013.
//  Copyright (c) 2013 ShinobiControls. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShinobiCharts/ShinobiChart.h>

/**
 A data source that is used to populate the pie chart. 
 */
@interface PieChartDataSource : NSObject <SChartDatasource>

- initWithSales:(NSDictionary*)sales displayYear:(NSString*)year;

// Inidcates which year the pie chart should be rendering
@property NSString* displayYear;

@end
