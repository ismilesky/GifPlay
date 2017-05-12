//
//  HomeViewController.m
//  GifPlay
//
//  Created by VS on 2017/5/12.
//  Copyright © 2017年 FelixKong. All rights reserved.
//

#import "HomeViewController.h"

#import "FLAnimatedImage.h"
#import "FLAnimatedImageView.h"

@interface HomeViewController ()

@property (weak, nonatomic) IBOutlet FLAnimatedImageView *animatedImgView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.animatedImgView.contentMode = UIViewContentModeScaleAspectFill;
    [self.animatedImgView clipsToBounds];

    self.animatedImgView.animatedImage = [self animatedImageWithURLForResource:@"niconiconi"];
}

- (FLAnimatedImage *)animatedImageWithURLForResource:(NSString *)fileName {
    NSURL *url = [[NSBundle mainBundle] URLForResource:fileName withExtension:@"gif"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    FLAnimatedImage *animatedImage = [[FLAnimatedImage alloc] initWithAnimatedGIFData:data];
    return animatedImage;
}
@end
