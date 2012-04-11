//
//  NSManagedObjectContext+VPPCoreData.h
//  VPPCoreDataExample
//
//  Created by Víctor on 11/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface NSManagedObjectContext (VPPCoreData)

- (void) saveChanges:(NSError **)error;

@end
