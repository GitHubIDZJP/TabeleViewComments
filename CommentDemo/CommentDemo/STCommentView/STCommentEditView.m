//
//  NFCommentToolView.m
//  AFNetworking
//
//  Created by menghua liu on 2018/5/7.
//

#import "STCommentEditView.h"
#import "STCommentTextView.h"
#import "UIView+Frame.h"
#import "UIColor+Extension.h"
#import "UIFont+Extension.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define maxHeight 80.f
#define originalHeight 56.f

@interface STCommentEditView() <UITextViewDelegate>

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) STCommentTextView *inputView;
@property (nonatomic, strong) UIView *inputBackgroundView;

@property (nonatomic, assign) CGFloat oneLineHeight;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, assign) CGFloat keyboardHeight;
@property (nonatomic, copy) NSString *namePlaceholder;

@end

@implementation STCommentEditView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.content = [[NSString alloc] init];
        self.maxWords = 200;
        
        [self loadSubViews];
        [self addNotification];
        
    }
    return self;
}

- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)loadSubViews {
    self.frame = CGRectMake(0, SCREEN_HEIGHT - originalHeight, SCREEN_WIDTH, originalHeight);
    self.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    
    self.inputBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH - 75 - 15, originalHeight - 20)];
    self.inputBackgroundView.backgroundColor = [UIColor clearColor];
    self.inputBackgroundView.layer.borderColor  = [UIColor colorWithHexString:@"#EDEDED"].CGColor;
    self.inputBackgroundView.layer.borderWidth = 1.f;
    self.inputBackgroundView.layer.cornerRadius = self.inputBackgroundView.height/2;
    [self addSubview:self.inputBackgroundView];
    
    self.inputView = [[STCommentTextView alloc] initWithFrame:CGRectMake(10, 0, self.inputBackgroundView.width - 20, self.inputBackgroundView.height)];
    self.inputView.font = [UIFont customFontWithName:@"PingFangSC-Regular" size:16.f];
    self.inputView.delegate = self;
    self.inputView.contentInset = UIEdgeInsetsMake(-1, 0, 0,0);
    self.inputView.textContainerInset = UIEdgeInsetsMake(8.5, 0, 0, 0);
    self.inputView.placeholder = @"优质评论将会优先展示";
    self.inputView.textColor = [UIColor colorWithHexString:@"#333333"];
    self.inputView.placeholderColor = [UIColor colorWithHexString:@"#A5A5A5"];
    self.inputView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.inputView.scrollEnabled = NO;
    [self.inputBackgroundView addSubview:self.inputView];
    
    self.sendButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 75, 0, 75, originalHeight)];
    [self.sendButton addTarget:self action:@selector(sendButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.sendButton setTitle:@"发送" forState:UIControlStateNormal];
    self.sendButton.titleLabel.font = [UIFont customFontWithName:@"PingFangSC-Regular" size:16.f];
    self.sendButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.sendButton setTitleColor:[UIColor colorWithHexString:@"#A5A5A5"] forState:UIControlStateNormal];
    self.sendButton.enabled = NO;
    [self addSubview:self.sendButton];
    
    CGSize size = [self.inputView sizeThatFits:CGSizeMake(self.inputView.width, MAXFLOAT)];
    self.oneLineHeight = size.height;
}

#pragma mark - Lazy load

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _maskView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.2f];
        _maskView.hidden = YES;
        _maskView.alpha = 0.f;
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
        [_maskView addGestureRecognizer:tapGesture];
        [self.superview insertSubview:_maskView belowSubview:self];
    }
    return _maskView;
}

#pragma mark - Public method

- (void)show {
    [self.inputView becomeFirstResponder];
}

- (void)updatePlaceholder:(NSString *)placeholder {
    self.namePlaceholder = placeholder;
}

#pragma mark - Keyboard notification

- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    self.inputView.text = self.content;
    
    self.maskView.hidden = NO;
    self.maskView.alpha = 1.f;
    
    CGFloat keyboardHeight = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    self.keyboardHeight = keyboardHeight;
    [UIView animateWithDuration:0.15f animations:^{
        self.y = SCREEN_HEIGHT - keyboardHeight - CGRectGetHeight(self.frame);
    }];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.inputView.placeholder = self.namePlaceholder.length > 0 ? self.namePlaceholder : self.inputView.placeholder;
}

- (void)textViewDidChange:(UITextView *)textView{
    CGSize size = [textView sizeThatFits:CGSizeMake(textView.width, MAXFLOAT)];
    
    if (size.height <= self.oneLineHeight) {
        
        [UIView animateWithDuration:0.15f animations:^{
            self.inputBackgroundView.height = originalHeight - 20;
            textView.height = originalHeight - 20;
            self.y = SCREEN_HEIGHT - self.keyboardHeight - originalHeight;
            self.height = originalHeight;
            self.sendButton.y = (self.height - self.sendButton.height)/2;
        }];
        textView.scrollEnabled = NO;
        
    } else {

        [UIView animateWithDuration:0.15 animations:^{
            self.y = SCREEN_HEIGHT - self.keyboardHeight - maxHeight;
            self.height = maxHeight;
            self.sendButton.y = (self.height - self.sendButton.height)/2;
            self.inputBackgroundView.height = maxHeight - 20;
            textView.height = maxHeight - 20;
        }];
        
        textView.scrollEnabled = YES;
    }
    
    if (textView.text.length > self.maxWords || textView.text.length == 0) {
        [self.sendButton setTitleColor:[UIColor colorWithHexString:@"#A5A5A5"] forState:UIControlStateNormal];
        self.sendButton.enabled = NO;
    } else {
        [self.sendButton setTitleColor:[UIColor colorWithHexString:@"#3799FF"] forState:UIControlStateNormal];
        self.sendButton.enabled = YES;
    }
    
    self.content = textView.text;
}

#pragma mark - Setter

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    self.inputView.textColor = _textColor;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    self.inputView.placeholderColor = _placeholderColor;
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    self.inputView.placeholder = _placeholder;
}

#pragma mark - Private method

- (void)tapGesture:(UITapGestureRecognizer *)gesture {
    [self endEditing:YES];
    
    [UIView animateWithDuration:0.5f animations:^{
        
        self.maskView.alpha = 0.f;
        self.maskView.hidden = YES;
        
        self.y = SCREEN_HEIGHT - self.height;
        self.hidden = YES;
    }];
}

- (void)sendButtonClicked:(UIButton *)button {
    NSLog(@"正在发送：%@", self.content);
   
    // send and show progress HUD
    // ...
    
    // simulate sending
    [NSThread sleepForTimeInterval:1.f];
    
    BOOL sendSuccess = YES;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(commentEditView:didRequsetStatus:)]) {
        [self.delegate commentEditView:self didRequsetStatus:sendSuccess];
    }
    
    if (sendSuccess) {
        [self.inputView endEditing:YES];
        self.content  = @"";
        [UIView animateWithDuration:0.15 animations:^{
            self.maskView.alpha = 0.f;
            self.maskView.hidden = YES;
            self.y = SCREEN_HEIGHT - self.height;
            self.hidden = YES;
        }];
    }
}

@end
