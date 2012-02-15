//
//  Service.m
//  VPPCoreDataExample
//
//  Created by Víctor on 14/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Service.h"
#import "VPPCoreData.h"

@implementation Service

// example of request on main thread

+ (void) removeAllObjects {
    [[VPPCoreData sharedInstance] deleteAllObjectsFromEntity:@"Quote"];
}

// example of background operation
+ (void) findQuotesWithText:(NSString *)text completion:(void (^) (NSArray *data))block {
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"quote contains[cd] %@",text];
    [[VPPCoreData sharedInstance] allObjectsForEntity:@"Quote" orderedByAttribute:@"date" ascending:NO filteredBy:pred completion:^(NSArray *objects) {
        block(objects);
    }];
}

// example of given managed object context operations
+ (void) allQuotesCompletion:(void (^) (NSArray *data))block {
    NSOperationQueue *q = [[NSOperationQueue alloc] init];
    [q addOperationWithBlock:^{
        NSManagedObjectContext *moc = [[[VPPCoreData sharedInstance] createManagedObjectContext] retain];
        
        NSArray *quotes = [[VPPCoreData sharedInstance] allObjectsForEntity:@"Quote" orderedByAttribute:@"date" ascending:NO filteredBy:nil managedObjectContext:moc];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            block([[VPPCoreData sharedInstance] objectsWithExistingIDs:quotes]);
        }];
        [moc release];
    }];
    [q release];
}


+ (Quote *) createQuoteWithText:(NSString *)text {
    NSManagedObjectContext *moc = [[[VPPCoreData sharedInstance] createManagedObjectContext] retain];
    Quote *q = [[VPPCoreData sharedInstance] getNewObjectForEntity:@"Quote" managedObjectContext:moc];
    
    q.quote = text;
    q.date = [NSDate date];
    
    [[VPPCoreData sharedInstance] saveManagedObjectContext:moc error:NULL];
    [moc release];
    
    return q;
}

+ (int) countAllObjects {
    NSManagedObjectContext *moc = [[[VPPCoreData sharedInstance] createManagedObjectContext] retain];
    int count = [[VPPCoreData sharedInstance] countObjectsForEntity:@"Quote" filteredBy:nil managedObjectContext:moc];
    [moc release];
    
    return count;
}

@end
