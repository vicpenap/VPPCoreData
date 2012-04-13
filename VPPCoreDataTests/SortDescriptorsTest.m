//
//  SortDescriptorsTest.m
//  VPPCoreDataExample
//
//  Created by Víctor on 13/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SortDescriptorsTest.h"
#import "NSSortDescriptor+VPPCoreData.h"

@implementation SortDescriptorsTest

- (void) checkCount:(NSArray *)sortDescriptors expected:(int)expected
{
    STAssertTrue(expected == [sortDescriptors count], @"sort descriptors count doesn't match");
}

- (void) checkKey:(NSSortDescriptor *)sortDescriptor expected:(NSString *)key
{
    STAssertEqualObjects(sortDescriptor.key, key, @"Keys don't match");
}

- (void) checkAscending:(NSSortDescriptor *)sortDescriptor expected:(BOOL)expected
{
    STAssertTrue(sortDescriptor.ascending == expected, @"Ascending doesn't match");    
}


- (void)test1
{
    NSArray *sortDescriptors = [NSSortDescriptor sortDescriptorsFromSQLString:@"date"];
    [self checkCount:sortDescriptors expected:1];
    
    
    NSSortDescriptor *sortDescriptor = [sortDescriptors objectAtIndex:0];
    [self checkAscending:sortDescriptor expected:YES];
    [self checkKey:sortDescriptor expected:@"date"];
}

- (void)test2
{
    NSArray *sortDescriptors = [NSSortDescriptor sortDescriptorsFromSQLString:@"date asc"];
    [self checkCount:sortDescriptors expected:1];
    
    
    NSSortDescriptor *sortDescriptor = [sortDescriptors objectAtIndex:0];
    [self checkAscending:sortDescriptor expected:YES];
    [self checkKey:sortDescriptor expected:@"date"];
}

- (void)test3
{
    NSArray *sortDescriptors = [NSSortDescriptor sortDescriptorsFromSQLString:@"date desc"];
    [self checkCount:sortDescriptors expected:1];
    
    
    NSSortDescriptor *sortDescriptor = [sortDescriptors objectAtIndex:0];
    [self checkAscending:sortDescriptor expected:NO];
    [self checkKey:sortDescriptor expected:@"date"];
}

- (void)test4
{
    NSArray *sortDescriptors = [NSSortDescriptor sortDescriptorsFromSQLString:@"date weird"];
    [self checkCount:sortDescriptors expected:0];
}

- (void)test5
{
    NSArray *sortDescriptors = [NSSortDescriptor sortDescriptorsFromSQLString:@"date, title"];
    [self checkCount:sortDescriptors expected:2];
    
    
    NSSortDescriptor *sortDescriptor = [sortDescriptors objectAtIndex:0];
    [self checkAscending:sortDescriptor expected:YES];
    [self checkKey:sortDescriptor expected:@"date"];
    
    sortDescriptor = [sortDescriptors objectAtIndex:1];
    [self checkAscending:sortDescriptor expected:YES];
    [self checkKey:sortDescriptor expected:@"title"];
}

- (void)test6
{
    NSArray *sortDescriptors = [NSSortDescriptor sortDescriptorsFromSQLString:@"date, title desc"];
    [self checkCount:sortDescriptors expected:2];
    
    
    NSSortDescriptor *sortDescriptor = [sortDescriptors objectAtIndex:0];
    [self checkAscending:sortDescriptor expected:YES];
    [self checkKey:sortDescriptor expected:@"date"];
    
    sortDescriptor = [sortDescriptors objectAtIndex:1];
    [self checkAscending:sortDescriptor expected:NO];
    [self checkKey:sortDescriptor expected:@"title"];
}


- (void)test7
{
    NSArray *sortDescriptors = [NSSortDescriptor sortDescriptorsFromSQLString:@"date asc, title"];
    [self checkCount:sortDescriptors expected:2];
    
    
    NSSortDescriptor *sortDescriptor = [sortDescriptors objectAtIndex:0];
    [self checkAscending:sortDescriptor expected:YES];
    [self checkKey:sortDescriptor expected:@"date"];
    
    sortDescriptor = [sortDescriptors objectAtIndex:1];
    [self checkAscending:sortDescriptor expected:YES];
    [self checkKey:sortDescriptor expected:@"title"];
}



- (void)test8
{
    NSArray *sortDescriptors = [NSSortDescriptor sortDescriptorsFromSQLString:@"date desc, title"];
    [self checkCount:sortDescriptors expected:2];
    
    
    NSSortDescriptor *sortDescriptor = [sortDescriptors objectAtIndex:0];
    [self checkAscending:sortDescriptor expected:NO];
    [self checkKey:sortDescriptor expected:@"date"];
    
    sortDescriptor = [sortDescriptors objectAtIndex:1];
    [self checkAscending:sortDescriptor expected:YES];
    [self checkKey:sortDescriptor expected:@"title"];
}

- (void)test9
{
    NSArray *sortDescriptors = [NSSortDescriptor sortDescriptorsFromSQLString:@"date asc, title asc"];
    [self checkCount:sortDescriptors expected:2];
    
    
    NSSortDescriptor *sortDescriptor = [sortDescriptors objectAtIndex:0];
    [self checkAscending:sortDescriptor expected:YES];
    [self checkKey:sortDescriptor expected:@"date"];
    
    sortDescriptor = [sortDescriptors objectAtIndex:1];
    [self checkAscending:sortDescriptor expected:YES];
    [self checkKey:sortDescriptor expected:@"title"];
}


- (void)test10
{
    NSArray *sortDescriptors = [NSSortDescriptor sortDescriptorsFromSQLString:@"date desc, title desc"];
    [self checkCount:sortDescriptors expected:2];
    
    
    NSSortDescriptor *sortDescriptor = [sortDescriptors objectAtIndex:0];
    [self checkAscending:sortDescriptor expected:NO];
    [self checkKey:sortDescriptor expected:@"date"];
    
    sortDescriptor = [sortDescriptors objectAtIndex:1];
    [self checkAscending:sortDescriptor expected:NO];
    [self checkKey:sortDescriptor expected:@"title"];
}

- (void)test11
{
    NSArray *sortDescriptors = [NSSortDescriptor sortDescriptorsFromSQLString:@"date weird, title"];
    [self checkCount:sortDescriptors expected:1];
    
    
    NSSortDescriptor *sortDescriptor = [sortDescriptors objectAtIndex:0];
    [self checkAscending:sortDescriptor expected:YES];
    [self checkKey:sortDescriptor expected:@"title"];
}

- (void)test12
{
    NSArray *sortDescriptors = [NSSortDescriptor sortDescriptorsFromSQLString:@"date desc weird, title"];
    [self checkCount:sortDescriptors expected:1];
    
    
    NSSortDescriptor *sortDescriptor = [sortDescriptors objectAtIndex:0];
    [self checkAscending:sortDescriptor expected:YES];
    [self checkKey:sortDescriptor expected:@"title"];
}

- (void)test13
{
    NSArray *sortDescriptors = [NSSortDescriptor sortDescriptorsFromSQLString:@"date desc weird, title desc"];
    [self checkCount:sortDescriptors expected:1];
    
    
    NSSortDescriptor *sortDescriptor = [sortDescriptors objectAtIndex:0];
    [self checkAscending:sortDescriptor expected:NO];
    [self checkKey:sortDescriptor expected:@"title"];
}




@end
