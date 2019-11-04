//
//  TYSnapshotScroll.h
//  TYSnapshotScroll
//
//  Created by apple on 16/12/28.
//  Copyright © 2016年 TonyReet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WKWebView.h>

@interface TYSnapshotScroll : NSObject

+ (void )screenSnapshot:(UIView *)snapshotView finishBlock:(void(^)(UIImage *snapShotImage))finishBloc;


/// 多个scrollView(tablview)嵌套获取截图，使用场景:iOS13涉及scrollView嵌套tableView获取截图的地方
/// @param snapshotView 最外层的scrollView
/// @param modifyLayoutBlock 需要修改布局的block
/// @param finishBlock 结束的block
+(void )screenSnapshotWithMultipleScroll:(UIView *)snapshotView modifyLayoutBlock:(void(^)(CGFloat extraHeight))modifyLayoutBlock finishBlock:(void(^)(UIImage *snapShotImage))finishBlock;

@end
