//
//  TreeTagViewController.m
//  HJTreeTag
//
//  Created by DaCang on 2017/12/6.
//  Copyright © 2017年 SpeakNow. All rights reserved.
//

#import "TreeTagViewController.h"
#import "HJTagsView.h"
#import "HJTagModel.h"

@interface TreeTagViewController ()
@property (nonatomic, strong)HJTagsView *view1;
@end

@implementation TreeTagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    HJTagModel *model1 = [[HJTagModel alloc]initTagModelWithTagContentsArray:[@[@"电风扇",@"第三方",@"发咖妃的都是"] mutableCopy] tagStyle:TagViewStyleStraightLeft coordinate:CGPointMake(0.5, 0.2)];
    
    HJTagModel *model2 = [[HJTagModel alloc]initTagModelWithTagContentsArray:[@[@"佛挡杀佛三",@"电风扇"] mutableCopy] tagStyle:TagViewStyleStraightLeft coordinate:CGPointMake(0.5, 0.3)];
    
    HJTagModel *model3 = [[HJTagModel alloc]initTagModelWithTagContentsArray:[@[@"打发斯蒂芬"] mutableCopy] tagStyle:TagViewStyleStraightLeft coordinate:CGPointMake(0.5, 0.4)];
    
    HJTagModel *model4 = [[HJTagModel alloc]initTagModelWithTagContentsArray:[@[@"东方闪电",@"地方",@"喂喂喂热风"] mutableCopy] tagStyle:TagViewStyleObliqueLeft coordinate:CGPointMake(0.5, 0.5)];
    
    HJTagModel *model5 = [[HJTagModel alloc]initTagModelWithTagContentsArray:[@[@"的2",@"的是否打赏"] mutableCopy] tagStyle:TagViewStyleObliqueLeft coordinate:CGPointMake(0.5, 0.6)];
    
    HJTagModel *model6 = [[HJTagModel alloc]initTagModelWithTagContentsArray:[@[@"232"] mutableCopy] tagStyle:TagViewStyleObliqueLeft coordinate:CGPointMake(0.5, 0.7)];
    
    HJTagsView *view1 = [[HJTagsView alloc]initWithTagModel:model1];
    HJTagsView *view2 = [[HJTagsView alloc]initWithTagModel:model2];
    HJTagsView *view3 = [[HJTagsView alloc]initWithTagModel:model3];
    HJTagsView *view4 = [[HJTagsView alloc]initWithTagModel:model4];
    HJTagsView *view5 = [[HJTagsView alloc]initWithTagModel:model5];
    HJTagsView *view6 = [[HJTagsView alloc]initWithTagModel:model6];
    
    view1.center = CGPointMake((self.view.bounds.size.width * model1.coordinate.x),(self.view.bounds.size.height * model1.coordinate.y));
    view2.center = CGPointMake((self.view.bounds.size.width * model2.coordinate.x),(self.view.bounds.size.height * model2.coordinate.y));
    view3.center = CGPointMake((self.view.bounds.size.width * model3.coordinate.x),(self.view.bounds.size.height * model3.coordinate.y));
    view4.center = CGPointMake((self.view.bounds.size.width * model4.coordinate.x),(self.view.bounds.size.height * model4.coordinate.y));
    view5.center = CGPointMake((self.view.bounds.size.width * model5.coordinate.x),(self.view.bounds.size.height * model5.coordinate.y));
    view6.center = CGPointMake((self.view.bounds.size.width * model6.coordinate.x),(self.view.bounds.size.height * model6.coordinate.y));
    
    [view1 showTagsViewWithAnimated:YES];
    [view2 showTagsViewWithAnimated:YES];
    [view3 showTagsViewWithAnimated:YES];
    [view4 showTagsViewWithAnimated:YES];
    [view5 showTagsViewWithAnimated:YES];
    [view6 showTagsViewWithAnimated:YES];
    
    [self.view addSubview:view1];
    [self.view addSubview:view2];
    [self.view addSubview:view3];
    [self.view addSubview:view4];
    [self.view addSubview:view5];
    [self.view addSubview:view6];
    
    _view1 = view1;
    UIButton *button  = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 40)];
    button.backgroundColor = [UIColor whiteColor];
    [button addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)action {
    if (_view1.hiddenTagView == NO) {
        [_view1 hideTagsViewWithAnimated:YES];
    }else{
        [_view1 showTagsViewWithAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

