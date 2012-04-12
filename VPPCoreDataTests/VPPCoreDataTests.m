//
//  VPPCoreDataTests.m
//  VPPCoreDataTests
//
//  Created by Víctor on 12/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VPPCoreDataTests.h"
#import "VPPCoreData.h"
#import <CoreData/CoreData.h>
#import "Quote.h"


@implementation VPPCoreDataTests
@synthesize moc;
- (void)setUp
{
    [super setUp];
    
    NSManagedObjectModel *mom = [NSManagedObjectModel mergedModelFromBundles:[NSArray arrayWithObject:[NSBundle bundleForClass:[self class]]]];
    [[VPPCoreData sharedInstance] setManagedObjectModel:mom];
    [[VPPCoreData sharedInstance] setPersistentStoreType:NSInMemoryStoreType];

    self.moc = [VPPCoreData sharedInstance].mainContext;
}

- (void)tearDown
{
    [[VPPCoreData sharedInstance] deleteAllObjectsFromEntity:@"Quote" managedObjectContext:moc];
    [[VPPCoreData sharedInstance] deleteAllObjectsFromEntity:@"Author" managedObjectContext:moc];
    
    [super tearDown];
}


- (void) testEqual:(id)object1 to:(id)object2
{
    STAssertEqualObjects(object1, object2, @"Objects are different");
}

- (Quote *) createQuote:(NSString *)quoteText date:(NSDate *)date
{
    Quote *quote = [[VPPCoreData sharedInstance] getNewObjectForEntity:@"Quote" managedObjectContext:moc];
    quote.quote = quoteText;
    quote.date = date;

    return quote;
}

- (NSArray *) insertQuotesPrefix:(NSString *)prefix amount:(int)amount
{
    NSMutableArray *quotes = [NSMutableArray array];
    for (int i = 1; i <= amount; i++)
    {
        [quotes addObject:[self createQuote:[NSString stringWithFormat:@"%@ %d",prefix,i] date:[NSDate date]]];
    }
    
    return quotes;
}



- (void) testCreateManagedObjectContext 
{
    NSPersistentStoreCoordinator *coordinator = [VPPCoreData sharedInstance].persistentStoreCoordinator;
    
    NSManagedObjectContext *newMoc = [[VPPCoreData sharedInstance] createManagedObjectContext];
    
    STAssertEqualObjects(newMoc.persistentStoreCoordinator, coordinator, @"persistent store coordinator are not equal");
}

/* Only vpp core data methods that have a managedObjectContext parameter are
 tested. This is beacuse any method without that parameter will delegate on it.
 */

- (void) testCountObjects 
{
    int count = [[self insertQuotesPrefix:@"Text" amount:10] count];
    int vppCount = [[VPPCoreData sharedInstance] countObjectsForEntity:@"Quote" filteredBy:nil managedObjectContext:moc];
    
    STAssertTrue(count == vppCount, @"Counts are different");
    
}



- (void) testPagedObjects
{
    NSArray *descriptors = [NSSortDescriptor sortDescriptorsFromSQLString:@"date"];
    
    NSMutableArray *quotes = [NSMutableArray array];
    [quotes addObjectsFromArray:[self insertQuotesPrefix:@"Text" amount:10]];
    [quotes addObjectsFromArray:[self insertQuotesPrefix:@"Quote" amount:20]];
    
    [quotes sortUsingDescriptors:descriptors];

    NSArray *result = [[VPPCoreData sharedInstance] objectsForEntity:@"Quote" sortDescriptors:descriptors filteredBy:nil fetchLimit:10 offset:0 managedObjectContext:moc];
    
    [self testEqual:[quotes subarrayWithRange:NSMakeRange(0, 10)] to:result];
    
    result = [[VPPCoreData sharedInstance] objectsForEntity:@"Quote" sortDescriptors:descriptors filteredBy:nil fetchLimit:10 offset:1 managedObjectContext:moc];
    
    [self testEqual:[quotes subarrayWithRange:NSMakeRange(0, 10)] to:result];

    result = [[VPPCoreData sharedInstance] objectsForEntity:@"Quote" sortDescriptors:descriptors filteredBy:nil fetchLimit:10 offset:5 managedObjectContext:moc];
    
    [self testEqual:[quotes subarrayWithRange:NSMakeRange(4, 10)] to:result];
    
    result = [[VPPCoreData sharedInstance] objectsForEntity:@"Quote" orderBy:@"date" filteredBy:nil fetchLimit:10 offset:5 managedObjectContext:moc];
    
    [self testEqual:[quotes subarrayWithRange:NSMakeRange(4, 10)] to:result];

    result = [[VPPCoreData sharedInstance] objectsForEntity:@"Quote" orderedByAttribute:@"date" ascending:YES filteredBy:nil fetchLimit:10 offset:5 managedObjectContext:moc];
    
    [self testEqual:[quotes subarrayWithRange:NSMakeRange(4, 10)] to:result];
}




- (void) testAllObjects
{
    NSArray *descriptors = [NSSortDescriptor sortDescriptorsFromSQLString:@"date"];
    
    NSMutableArray *quotes = [NSMutableArray array];
    [quotes addObjectsFromArray:[self insertQuotesPrefix:@"Text" amount:10]];
    [quotes addObjectsFromArray:[self insertQuotesPrefix:@"Quote" amount:20]];
    
    [quotes sortUsingDescriptors:descriptors];
    
    NSArray *result = [[VPPCoreData sharedInstance] allObjectsForEntity:@"Quote" sortDescriptors:descriptors filteredBy:nil managedObjectContext:moc];
    
    [self testEqual:quotes to:result];
    
    /* no need to test any other 'allObjects' method, as they all delegate in the 
    equivalent 'objects' method, already tested. */
}


- (void) testFilterObjects 
{
    NSArray *descriptors = [NSSortDescriptor sortDescriptorsFromSQLString:@"date"];
    
    NSMutableArray *quotes = [NSMutableArray array];
    [quotes addObjectsFromArray:[self insertQuotesPrefix:@"Text" amount:10]];
    [quotes addObjectsFromArray:[self insertQuotesPrefix:@"Quote" amount:20]];
    
    [quotes sortUsingDescriptors:descriptors];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"quote contains[cd] %@",@"text"];
    NSArray *filteredArray = [quotes filteredArrayUsingPredicate:predicate];
    
    NSArray *result = [[VPPCoreData sharedInstance] allObjectsForEntity:@"Quote" sortDescriptors:descriptors filteredBy:predicate managedObjectContext:moc];
    
    [self testEqual:filteredArray to:result];

    predicate = [NSPredicate predicateWithFormat:@"quote contains[cd] %@",@"quot"];
    filteredArray = [quotes filteredArrayUsingPredicate:predicate];
    
    result = [[VPPCoreData sharedInstance] allObjectsForEntity:@"Quote" sortDescriptors:descriptors filteredBy:predicate managedObjectContext:moc];
    
    [self testEqual:filteredArray to:result];

    
    predicate = [NSPredicate predicateWithFormat:@"quote contains[cd] %@",@"something weird"];
    
    result = [[VPPCoreData sharedInstance] allObjectsForEntity:@"Quote" sortDescriptors:descriptors filteredBy:predicate managedObjectContext:moc];
    
    [self testEqual:[NSArray array] to:result];
}


- (void) testRemove
{
    NSArray *descriptors = [NSSortDescriptor sortDescriptorsFromSQLString:@"date"];
    
    NSMutableArray *quotes = [NSMutableArray array];
    [quotes addObjectsFromArray:[self insertQuotesPrefix:@"Text" amount:10]];
    [quotes addObjectsFromArray:[self insertQuotesPrefix:@"Quote" amount:20]];
    
    [quotes sortUsingDescriptors:descriptors];
    
    Quote *quoteToRemove = [quotes lastObject];
    [[VPPCoreData sharedInstance] deleteObject:quoteToRemove];
    [quotes removeObject:quoteToRemove];
    
    NSArray *result = [[VPPCoreData sharedInstance] allObjectsForEntity:@"Quote" sortDescriptors:descriptors filteredBy:nil managedObjectContext:moc];
    
    [self testEqual:quotes to:result];
    
}


- (void) testRemoveAll
{

    [self insertQuotesPrefix:@"Text" amount:10];
    [self insertQuotesPrefix:@"Quote" amount:20];

    [[VPPCoreData sharedInstance] deleteAllObjectsFromEntity:@"Quote" managedObjectContext:moc];
    
    NSArray *result = [[VPPCoreData sharedInstance] allObjectsForEntity:@"Quote" sortDescriptors:nil filteredBy:nil managedObjectContext:moc];
    
    [self testEqual:[NSArray array] to:result];
    
}


@end
