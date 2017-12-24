//
//  TYCollectionViewVc.m
//  TYSnapshotScroll
//
//  Created by TonyReet on 2017/12/24.
//  Copyright © 2017年 TonyReet. All rights reserved.
//

#import "TYCollectionViewVc.h"

@interface TYCollectionViewVc ()
<
    UICollectionViewDataSource,
    UICollectionViewDelegate
>

@property (nonatomic,strong) UICollectionView *collectionView;

@end

static NSString *collectionCellID = @"collectionCellID";

@implementation TYCollectionViewVc
- (void)subClassInit {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collectionView = [[UICollectionView alloc] initWithFrame:[[UIScreen mainScreen] bounds] collectionViewLayout:flowLayout];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:collectionCellID];
    
    self.snapView = self.collectionView;
}

#pragma mark - dataSource
- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 100;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCellID forIndexPath:indexPath];
    
    cell.contentView.backgroundColor = [UIColor colorWithHue:drand48() saturation:1.0 brightness:1.0 alpha:1.0];
    return cell;
}
@end
