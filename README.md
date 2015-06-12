# ABCollectionViewFRC
NSFetchedResultsControllerDelegate wrapper for UICollectionView animated changes

# Usage

Just
```
pod 'ABCollectionViewFRC'
```

and replace this code (MagicalRecord used for example):

```
- (NSFetchedResultsController *)frc
{
    if (_frc == nil) {
        _frc = [MenuItem MR_fetchAllSortedBy:@"item_id" ascending:YES withPredicate:
                [NSPredicate predicateWithFormat:@"section = %@",self.menuSection] groupBy:nil delegate:self];
    }
    return _frc;
}
```

with this code:

```
@property (nonatomic, strong) id<NSFetchedResultsControllerDelegate> delegateWrapper;

...

- (id<NSFetchedResultsControllerDelegate>)delegateWrapper
{
    if (_delegateWrapper == nil)
        _delegateWrapper = [[ABCollectionViewFRC alloc] initWithCollectionView:self.collectionView delegate:self];
    return _delegateWrapper;
}

- (NSFetchedResultsController *)frc
{
    if (_frc == nil) {
        _frc = [MenuItem MR_fetchAllSortedBy:@"item_id" ascending:YES withPredicate:
                [NSPredicate predicateWithFormat:@"section = %@",self.menuSection] groupBy:nil delegate:self.delegateWrapper];
    }
    return _frc;
}
```

You just need to set delegate `ABCollectionViewFRC` instead of just `self` and you will be able to animate `UICollectionView` changes:

```
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.collectionView deleteItemsAtIndexPaths:@[newIndexPath]];
            break;
        case NSFetchedResultsChangeDelete:
            [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
            break;
        case NSFetchedResultsChangeMove:
            [self.collectionView moveItemAtIndexPath:indexPath toIndexPath:newIndexPath];
            break;
        case NSFetchedResultsChangeUpdate:
            [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.collectionView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]];
            break;
        case NSFetchedResultsChangeDelete:
            [self.collectionView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]];
            break;
        default:
            break;
    }
}
```

# Contribution

Feel free to discuss, pull request and [tweet](https://twitter.com/k06a)
