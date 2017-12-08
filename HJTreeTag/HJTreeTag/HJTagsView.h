//
//  HJTagsView.h
//  HJTreeTag
//
//  Created by DaCang on 2017/12/6.
//  Copyright © 2017年 SpeakNow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJTagModel.h"

@class HJTagsView;
typedef void(^centerDidTapBlock)(HJTagsView *);
typedef void(^textDidTapBlock)(HJTagsView *);
typedef void(^longPressBlock)(HJTagsView *);

@protocol HJTagsViewDelegate <NSObject>

@end;


@interface HJTagsView : UIView
//手势事件
@property (nonatomic, copy) centerDidTapBlock centerDidTapBlock;
@property (nonatomic, copy) textDidTapBlock textDidTapBlock;
@property (nonatomic, copy) longPressBlock longPressBlock;
@property (nonatomic, assign) BOOL editDisable;
@property (nonatomic, assign) BOOL showtagsView;
@property (nonatomic, assign) BOOL hiddenTagView;

-(instancetype)initWithTagModel:(HJTagModel *)tagModel;

-(void)showTagsViewWithAnimated:(BOOL )animated;
-(void)hideTagsViewWithAnimated:(BOOL )animated;

@end

