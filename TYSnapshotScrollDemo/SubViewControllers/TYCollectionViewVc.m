//
//  TYCollectionViewVc.m
//  TYSnapshotScroll
//
//  Created by TonyReet on 2017/12/24.
//  Copyright © 2017年 TonyReet. All rights reserved.
//

#import "TYCollectionViewVc.h"
#import "TYCustomCollectionViewCell.h"

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
    flowLayout.itemSize = CGSizeMake(50, 50);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:[[UIScreen mainScreen] bounds] collectionViewLayout:flowLayout];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[TYCustomCollectionViewCell class] forCellWithReuseIdentifier:collectionCellID];
    
    self.snapView = self.collectionView;
}

#pragma mark - dataSource
- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.isLongImage ? 1000 : 100;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TYCustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCellID forIndexPath:indexPath];
    
    cell.contentView.backgroundColor = [UIColor colorWithHue:drand48() saturation:1.0 brightness:1.0 alpha:1.0];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",@(indexPath.row)];
    
    return cell;
}
@end
