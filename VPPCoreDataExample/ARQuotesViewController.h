//
//  ARQuotesViewController.h
//  VPPCoreDataExample
//
//  Created by Víctor on 11/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ARQuotesViewController : UITableViewController { 
    BOOL loading;
}

@property (nonatomic, retain) NSArray *quotes;
@property (nonatomic, retain) UISegmentedControl *segmentedControl;


@end
