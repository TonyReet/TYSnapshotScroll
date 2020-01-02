

#import <UIKit/UIKit.h>

@interface LargeImageDownsizingViewController : UIViewController

@property (nonatomic,strong) UIImageView *progressView;

@property (nonatomic,strong) UIImage *sourceImage;

@property (nonatomic,strong) UIImage *destImage;

@property (nonatomic,assign) CGRect sourceTile;

@property (nonatomic,assign) CGRect destTile;

@property (nonatomic,assign) CGFloat imageScale;

@property (nonatomic,assign) CGSize sourceResolution;

@property (nonatomic,assign) CGFloat sourceTotalPixels;

@property (nonatomic,assign) CGFloat sourceTotalMB;

@property (nonatomic,assign) CGSize destResolution;

@property (nonatomic,assign) CGContextRef destContext;

@property (nonatomic,assign) CGFloat sourceSeemOverlap;

-(void)downsize;
-(void)updateScrollView:(id)arg;
-(void)initializeScrollView:(id)arg;
-(void)createImageFromContext;

@end
