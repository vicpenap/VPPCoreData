//
//  ActiveRecordTests.h
//  VPPCoreDataExample
//
//  Created by Víctor on 12/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

//  Logic unit tests contain unit test code that is designed to be linked into an independent test executable.
//  See Also: http://developer.apple.com/iphone/library/documentation/Xcode/Conceptual/iphone_development/135-Unit_Testing_Applications/unit_testing_applications.html

#import <SenTestingKit/SenTestingKit.h>
#import <CoreData/CoreData.h>

@interface ActiveRecordTests : SenTestCase

@property (nonatomic, retain) NSManagedObjectContext *moc;

@end
