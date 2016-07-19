//
//  AudioPlayDetailView.m
//  GDAudioPlayer
//
//  Created by xiaoyu on 16/7/18.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import "AudioPlayDetailView.h"
#import "GDSlider.h"
@interface AudioPlayDetailView ()

@property (nonatomic, strong) UILabel *titlelabel;              //musictitle

@property (nonatomic, strong) UILabel *singerlabel;             //singer

@property (nonatomic, strong) UIView *controlView;              //

@property (nonatomic, strong) UIButton *nextButton;             //下一首

@property (nonatomic, strong) UIButton *forwardButton;          //上一首

@property (nonatomic, strong) UIButton *playButton;             //播放按钮

@property (nonatomic, strong) UIProgressView *audio_progress;   //进度条

@property (nonatomic, strong) GDSlider *audio_slider;           //silder

@end


@implementation AudioPlayDetailView
- (void)dealloc{
    [_titlelabel removeFromSuperview];_titlelabel = nil;
    [_singerlabel removeFromSuperview];_singerlabel = nil;
    [_controlView removeFromSuperview];_controlView = nil;
    [_nextButton removeFromSuperview];_nextButton = nil;
    [_forwardButton removeFromSuperview];_forwardButton = nil;
    [_playButton removeFromSuperview];_playButton = nil;

}
- (instancetype) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = XUIColor(0x000000, 0.90);
        [self AudioCreateUIView];
    }
    return self;
}
- (void)AudioCreateUIView {
    [self createHeader];
    [self createUIControl];
    
    _audio_slider = [[GDSlider alloc] initWithFrame:CGRectMake(20, CGRectGetMidY(self.controlView.frame)-55, SCREENWIDTH-40, 25)];

    
    [self addSubview:_audio_slider];

}

- (void)createUIControl {
    //初次进来显示之前保存的当前播放
    NSDictionary *dic = UserDefault(CurrentPlay_Music);
    if (dic) {
        self.titlelabel.text = dic[@"mname"];self.singerlabel.text = dic[@"msinger"];
    }
    self.controlView.center = CGPointMake(SCREENWIDTH/2, SCREENHEIGHT-120);
    [self addSubview:self.controlView];
    [self.controlView addSubview:self.nextButton];
    [self.controlView addSubview:self.forwardButton];
    [self.controlView addSubview:self.playButton];

}
//header
- (void)createHeader{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10, 25, 40, 40);
    button.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    [button setImage:XUIImage(@"APD_dismiss") forState:UIControlStateNormal];
    [button setImage:XUIImage(@"APD_dismiss") forState:UIControlStateHighlighted];
    [self addSubview:button];
    [button addTarget:self action:@selector(dismissVC:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.titlelabel];
    [self addSubview:self.singerlabel];
    }
#pragma mark - 按钮点击事件

#pragma mark - 懒加载
//播放
- (UIButton *)playButton{
    if(!_playButton){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(82.5, 12.5, 55, 55);
        [button setBackgroundImage:XUIImage(@"tabbar_audio_start_normal") forState:UIControlStateNormal];
        [button setBackgroundImage:XUIImage(@"tabbar_audio_start_highlight") forState:UIControlStateHighlighted];
        button.tag = Audio_PlayButtonTag;
        [button addTarget:self action:@selector(audioBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _playButton = button;
    }
    return _playButton;
}
//下一首
-(UIButton *)nextButton{
    if(!_nextButton){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(220-40, 20, 40, 40);
        [button setBackgroundImage:XUIImage(@"tabbar_audio_next_normal") forState:UIControlStateNormal];
        [button setBackgroundImage:XUIImage(@"tabbar_audio_next_highlight") forState:UIControlStateHighlighted];
        button.tag = Audio_NextButtonTag;
        [button addTarget:self action:@selector(audioBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _nextButton = button;
        
    }
    return _nextButton;
}
//上一首
- (UIButton *)forwardButton{
    if (!_forwardButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 20, 40, 40);
        [button setBackgroundImage:XUIImage(@"APD_audio_forward_normal") forState:UIControlStateNormal];
        [button setBackgroundImage:XUIImage(@"APD_audio_forward_highlight") forState:UIControlStateHighlighted];
        button.tag = Audio_ForwardButtonTag;
        [button addTarget:self action:@selector(audioBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _forwardButton = button;
    }
    return _forwardButton;
}
- (UIView *)controlView{
    if (!_controlView) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 220, 80)];
        view.userInteractionEnabled = YES;
        _controlView = view;
    }
    return _controlView;
}
//singer
- (UILabel *)singerlabel{
    if (!_singerlabel) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 15)];
        label.center = CGPointMake(SCREENWIDTH/2, 65);
        label.textColor = XUIColor(0xffffff, 1);
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        _singerlabel = label;
    }
    return _singerlabel;
}
//歌曲名
- (UILabel *)titlelabel{
    if (!_titlelabel) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
        label.center = CGPointMake(SCREENWIDTH/2, 40);
        label.textColor = XUIColor(0xffffff, 1);
        label.textAlignment = NSTextAlignmentCenter;
        _titlelabel = label;
    }
    return _titlelabel;
}
#pragma mark - 点击事件
- (void)dismissVC:(UIButton *)sender {
    if ([_gd_delegate respondsToSelector:@selector(audioViewdismiss:)]) {
        [_gd_delegate audioViewdismiss:sender];
    }
}
- (void)audioBtnClick:(UIButton*)sender{
    if ([_gd_delegate respondsToSelector:@selector(audioViewBtnclick:)]) {
        [_gd_delegate audioViewBtnclick:sender];
    }
}
@end
