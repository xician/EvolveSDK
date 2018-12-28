//
//  ThumbnailCollectionViewCell.h
//  ARKitImageRecognition
//
//  Created by Cresset Admin on 25/10/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ThumbnailCollectionViewCell : UICollectionViewCell


@property (nonatomic, retain) IBOutlet UIImageView *thumbnailImg;
@property (nonatomic, retain) IBOutlet UILabel *titleLbl;
@property (nonatomic, retain) IBOutlet UILabel *descriptionLbl;

@property (nonatomic, retain) IBOutlet UILabel *selectionBGLbl;
@property (nonatomic, retain) IBOutlet UIImageView *selectionBGImg;

@end

NS_ASSUME_NONNULL_END
