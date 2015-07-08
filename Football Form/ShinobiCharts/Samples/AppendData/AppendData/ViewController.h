//
//  ViewController.h
//  AppendData
//
//  Created by Daniel Gorst on 26/06/2013.
//  Copyright (c) 2013 Scott Logic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ShinobiCharts/ShinobiChart.h>

@interface ViewController : UIViewController <SChartDatasource>

@property (nonatomic, retain) ShinobiChart *chart;

@end
