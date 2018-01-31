//
//  PreViewVC.m
//  AnimationDemo
//
//  Created by Chan on 2018/1/31.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "PreViewVC.h"
#import "PreViewCell.h"
#import "PageLayout.h"

@interface PreViewVC ()<UICollectionViewDelegate,UICollectionViewDataSource,pageDelegate> {
    UICollectionView *_collectioView;
}

@end

@implementation PreViewVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [_collectioView  setContentOffset:CGPointMake(_currentIndex * [UIScreen mainScreen].bounds.size.width, 0)];
    [_collectioView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
//    [_collectioView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:_currentIndex inSection:0]]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    PageLayout *layout = [PageLayout new];
    layout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectioView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) collectionViewLayout:layout];
    _collectioView.backgroundColor = [UIColor blackColor];
    _collectioView.delegate = self;
    _collectioView.dataSource = self;
    [_collectioView registerClass:[PreViewCell class] forCellWithReuseIdentifier:@"cell"];
    _collectioView.showsHorizontalScrollIndicator = NO;
//    [_collectioView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    _collectioView.pagingEnabled = YES;
    layout.pageDelegate = self;
    [self.view addSubview:_collectioView];
}

#pragma mark --UICollectionViewDataSource&delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArray.count;
}

- ( __kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PreViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell setCellWithData:_dataArray[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout cellCenteredAtIndexPath:(NSIndexPath *)indexPath page:(int)page {
    self.navigationItem.title = [NSString stringWithFormat:@"%zd of %zd",page + 1,_dataArray.count];
}

/*- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [_collectioView setContentOffset:CGPointMake(indexPath.row * [UIScreen mainScreen].bounds.size.width, 0)];
}*/

/*- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([object isEqual:_collectioView]) {
        NSInteger index = _collectioView.contentOffset.x/[UIScreen mainScreen].bounds.size.width;
        self.navigationItem.title = [NSString stringWithFormat:@"%zd of %zd",index + 1,_dataArray.count];
    }
}*/

/*- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x/[UIScreen mainScreen].bounds.size.width;
    self.navigationItem.title = [NSString stringWithFormat:@"%zd of %zd",index + 1,_dataArray.count];
}*/
@end
