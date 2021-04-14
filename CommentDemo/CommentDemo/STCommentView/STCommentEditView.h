//
//  NFCommentToolView.h
//  AFNetworking
//
//  Created by menghua liu on 2018/5/7.
//

#import <UIKit/UIKit.h>

@class STCommentEditView;

@protocol NFCommentEditViewDelegate <NSObject>

@optional

- (void)commentEditView:(STCommentEditView *)commentEditView didRequsetStatus:(BOOL)success;

@end


@interface STCommentEditView : UIView

@property (nonatomic, weak) id<NFCommentEditViewDelegate> delegate;
@property (nonatomic, copy) NSString *content;
// default is 200
@property (nonatomic, assign) NSUInteger maxWords;
// default is #333333
@property (nonatomic, strong) UIColor *textColor;
// default is #A5A5A5
@property (nonatomic, strong) UIColor *placeholderColor;
// default is 优质评论将会优先展示
@property (nonatomic, copy) NSString *placeholder;

- (void)show;

- (void)updatePlaceholder:(NSString *)placeholder;

@end
