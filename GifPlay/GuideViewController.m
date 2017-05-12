//
//  GuideViewController.m
//  GifPlay
//
//  Created by VS on 2017/5/12.
//  Copyright © 2017年 FelixKong. All rights reserved.
//

#import "GuideViewController.h"

#import "FLAnimatedImage.h"
#import "FLAnimatedImageView.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define TOTALCOUNT 3

#define DEBUG_VIEW_COLOR [UIColor colorWithRed:arc4random() % 256 / 255.0 green:arc4random() % 256 / 255.0 blue:arc4random() % 256 / 255.0 alpha:1.0]

@interface GuideViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (weak, nonatomic) IBOutlet UIButton *entryBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *entryBtnBottom;


@property (strong, nonatomic) NSMutableArray *animatedImageViews;
@property (assign, nonatomic) int lastPage;
@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupDefault];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.animatedImageViews removeAllObjects];
    self.animatedImageViews = nil;
}

#pragma mark - Method
- (NSMutableArray *)animatedImageViews {
    if (!_animatedImageViews) {
        _animatedImageViews = [NSMutableArray array];
    }
    return _animatedImageViews;
}

- (void)setupDefault {
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * TOTALCOUNT, 0);
    for (int i = 0; i<TOTALCOUNT; i++) {
        FLAnimatedImageView *imageView = [[FLAnimatedImageView alloc] init];
        FLAnimatedImage *image = [self animatedImageWithURLForResource:[NSString stringWithFormat:@"引导页%d",i+1]];
        if (i == 0) {
            imageView.animatedImage = image;
        } else {
            // 设置首帧图片
            imageView.image = image.posterImage;
        }
        imageView.frame = CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [_scrollView addSubview:imageView];
        [self.animatedImageViews addObject:imageView];
    }
    self.pageControl.numberOfPages = TOTALCOUNT;
}

- (FLAnimatedImage *)animatedImageWithURLForResource:(NSString *)fileName {
    NSURL *url = [[NSBundle mainBundle] URLForResource:fileName withExtension:@"gif"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    FLAnimatedImage *animatedImage = [[FLAnimatedImage alloc] initWithAnimatedGIFData:data];
    return animatedImage;
}

- (void)setupAnimateImage:(int)page {
    FLAnimatedImageView *imageView = self.animatedImageViews[page];
    FLAnimatedImage *image = [self animatedImageWithURLForResource:[NSString stringWithFormat:@"引导页%d",page+1]];
    imageView.animatedImage = image;
    
    if (page == TOTALCOUNT - 1) {
        imageView.loopCompletionBlock= ^(NSUInteger loopCountRemaining) {
            [UIView animateWithDuration:0.3 animations:^{
                self.entryBtn.hidden = NO;
                self.entryBtnBottom.constant = 75;
                [self.entryBtn layoutIfNeeded];
            }];
        };
    } else {
        self.entryBtn.hidden = YES;
        self.entryBtnBottom.constant = 0;
        [self.entryBtn layoutIfNeeded];
    }
}

- (void)setupFistFrameImageWithPage:(int)page {
    // 设置首帧图片，每次播放从首帧开始(如果不设置，滑回上一个会显示最后一帧的图片)
    if (self.lastPage != page) {
        if (self.lastPage < page ) {
            FLAnimatedImageView *imageView1 = self.animatedImageViews[page-1];
            imageView1.animatedImage = [self animatedImageWithURLForResource:[NSString stringWithFormat:@"引导页%d",page]];
            imageView1.image = imageView1.animatedImage.posterImage;
        } else {
            FLAnimatedImageView *imageView2 = self.animatedImageViews[page+1];
            imageView2.animatedImage = [self animatedImageWithURLForResource:[NSString stringWithFormat:@"引导页%d",page+2]];
            imageView2.image = imageView2.animatedImage.posterImage;
        }
    }
}

#pragma mark - Action
- (IBAction)onEntryBtnTap:(UIButton *)sender {
    if (self.startAppBlock) {
        self.startAppBlock();
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pages = scrollView.contentOffset.x / scrollView.frame.size.width;
    int page = (int)(pages + 0.5);
    
    [self setupAnimateImage:page];
    
    [self setupFistFrameImageWithPage:page];
    
    self.pageControl.currentPage = page;
    self.lastPage = page;
}

@end
