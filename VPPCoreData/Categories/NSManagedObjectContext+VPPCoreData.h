//
//  NSManagedObjectContext+VPPCDSave.h
//  VPPCoreDataExample
//
//  Created by Víctor on 11/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface NSManagedObjectContext (VPPCoreData)

- (void) save:(NSError **)error;

@end
