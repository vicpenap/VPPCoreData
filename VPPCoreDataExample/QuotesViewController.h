//
//  QuotesViewController.h
//  VPPCoreDataExample
//
//  Created by Víctor on 14/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuotesViewController : UITableViewController { 
    BOOL loading;
}

@property (nonatomic, retain) NSArray *quotes;
@property (nonatomic, retain) UISegmentedControl *segmentedControl;

@end
