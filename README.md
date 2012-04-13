# VPPCoreData v0.2.0

VPPCoreData is a Core Data wrapper with Active Record support that simplifies
the task of managing data with Core Data framework. This library offers an 
automatic setup of Core Data and a set of methods to set and retrieve data, 
both in foreground and background.
 
This library depends on `CoreData` framework and also on the included 
`SynthesizeSingleton` library, made by Matt Gallagher.

This library contains a test project that you should read to get familiar with 
VPPCoreData syntax.

This project contains a sample application using it. Just open the project in 
XCode, build it and run it. 

For full documentation check out 
http://vicpenap.github.com/VPPCoreData 

Be aware that this library is under active development, so it may get changed 
later and it may contain bugs.

## Using it

### Active Record

Since v0.2.0, VPPCoreData includes a syntax compliant with Active Record pattern.

You can perform calls like these:

	[Quote all];
	[Quote findBy:predicate];
	Quote create];
	[aQuote remove];

You can also perform those calls using different Managed Object Contexts:

	[Quote moc] all]; 
	/* Will create a new Managed Object Context, configure it 
	with the Persistent Store Coordinator and other needed information
	and perform the query using it. */

	[Quote moc:anExistingMOC] all];
	/* Will configure the given Managed Object Context 
	with the Persistent Store Coordinator and other needed information
	and perform the query using it. */

You can perform similar different-moc calls with managed objects, such as:
	[[aQuote moc] refetch]; 

Take a look at this documentation page: http://vicpenap.github.com/VPPCoreData/Protocols/VPPCoreDataActiveRecord.html to see all existing Active Record operations.

You may notice that there's no save method. This is due to the nature of Core Data.
When you want to save changes, call the `saveChanges:` method from the Managed Object
Context you are using.

### Building DAOs and services

You can use VPPCoreData in the same way you are used to use Core Data. In this case,
VPPCoreData will simplify your code. For example, instead of creating an entire
fetch request, with entity description, sort descriptors and so, you would do:

	    [[VPPCoreData sharedInstance] allObjectsForEntity:@"Quote" 
                                              orderBy:@"date desc" 
                                           filteredBy:pred
                                           completion:^(NSArray *objects) {
                                               block(objects);
                                           }];

Take a look at this documentation page: http://vicpenap.github.com/VPPCoreData/Classes/VPPCoreData.html to see all existing methods.


## Changelog

- 2012/04/13 (v0.2.0): 
	- Added Active Record syntax. 
	- Improved documentation. 
	- Added unit tests.
- 2012/03/14 (v0.1.1): Bug fixing: two memory issues and problem when creating
objects that have require relationships.
- 2012/02/15 (v0.1.0): First release.

## License 

Copyright (c) 2012 Víctor Pena Placer ([@vicpenap](http://www.twitter.com/vicpenap))
http://www.victorpena.es/


Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

