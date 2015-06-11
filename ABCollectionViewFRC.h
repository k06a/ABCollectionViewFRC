//
//  ABFetchedResultsController.h
//  Careba
//
//  Created by Антон Буков on 11.06.15.
//  Copyright (c) 2015 Anton Bukov. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

@interface ABCollectionViewFRC : NSObject <NSFetchedResultsControllerDelegate>

@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, weak) id<NSFetchedResultsControllerDelegate> delegate;

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView delegate:(id<NSFetchedResultsControllerDelegate>)delegate;

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller;
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller;

-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath;
- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type;

@end
