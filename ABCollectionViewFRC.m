//
//  ABFetchedResultsController.m
//  Careba
//
//  Created by Антон Буков on 11.06.15.
//  Copyright (c) 2015 Anton Bukov. All rights reserved.
//

#import "ABCollectionViewFRC.h"

@interface ABCollectionViewFRC ()

@property (nonatomic, strong) NSMutableArray *changes;

@end

@implementation ABCollectionViewFRC

- (NSMutableArray *)changes
{
    if (_changes == nil)
        _changes = [NSMutableArray array];
    return _changes;
}

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView delegate:(id<NSFetchedResultsControllerDelegate>)delegate
{
    if (self = [super init]) {
        self.collectionView = collectionView;
        self.delegate = delegate;
    }
    return self;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    self.changes = nil;
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    [self.changes addObject:@{@"type":@(type),@"object":anObject,@"indexPath":indexPath,@"newIndexPath":newIndexPath}];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    [self.changes addObject:@{@"type":@(type),@"sectionInfo":sectionInfo,@"sectionIndex":@(sectionIndex)}];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.collectionView performBatchUpdates:^{
        if ([(id)self.delegate respondsToSelector:@selector(controllerWillChangeContent:)])
            [self.delegate controllerWillChangeContent:controller];
        for (NSDictionary *change in self.changes) {
            if (change[@"sectionIndex"]) {
                if ([(id)self.delegate respondsToSelector:@selector(controller:didChangeSection:atIndex:forChangeType:)])
                    [self.delegate controller:controller didChangeSection:change[@"sectionInfo"] atIndex:[change[@"sectionIndex"] unsignedIntegerValue] forChangeType:[change[@"type"] unsignedIntegerValue]];
            } else {
                if ([(id)self.delegate respondsToSelector:@selector(controller:didChangeObject:atIndexPath:forChangeType:newIndexPath:)])
                    [self.delegate controller:controller didChangeObject:change[@"object"] atIndexPath:change[@"indexPath"] forChangeType:[change[@"type"] unsignedIntegerValue] newIndexPath:change[@"newIndexPath"]];
            }
        }
        if ([(id)self.delegate respondsToSelector:@selector(controllerDidChangeContent:)])
            [self.delegate controllerDidChangeContent:controller];
        self.changes = nil;
    } completion:nil];
}

@end
