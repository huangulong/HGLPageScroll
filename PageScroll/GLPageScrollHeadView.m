//
//  GLPageScrollHeadView.m
//  LexanderA-ScrollDemo
//
//  Created by admin on 2019/4/28.
//  Copyright © 2019 历山大亚. All rights reserved.
//

#import "GLPageScrollHeadView.h"

@implementation GLPageScrollHeadView

- (void)dealloc{
    NSLog(@"%s",__FUNCTION__);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _zoom = YES;
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:imageView];
        _bgImageView = imageView;
    }
    return self;
}

- (void)setOffsetY:(CGFloat)offsetY{
    _offsetY = offsetY;
    if (_zoom) {
        //如果offsetY小于0
        if (offsetY <= 0) {
            CGRect rect = self.bounds;
            rect.origin.y += offsetY;
            rect.size.height -= offsetY;
            self.bgImageView.frame = rect;
        }else{
            self.bgImageView.frame = self.bounds;
        }
    }
}

//如果其子控件不处理事件的话 就交给外部去处理吧
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView * view = [super hitTest:point withEvent:event];
    if (view == self) {
        view = nil;
    }
    return view;
}

@end
