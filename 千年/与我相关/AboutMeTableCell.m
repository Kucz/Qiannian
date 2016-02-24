//
//  AboutMeTableCell.m
//  千年
//
//  Created by God on 16/1/25.
//  Copyright © 2016年 God. All rights reserved.
//

#import "AboutMeTableCell.h"
#import "HopeCommentModel.h"
#import "DetailCommentModel.h"
//static int i = 0;
@implementation AboutMeTableCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


-(void)setHopeModel:(HopeCommentModel *)hopeModel
{
    _hopeModel = hopeModel;
    for(UIView *view in [self subviews])
    {
        [view removeFromSuperview];
    }
    [self setUpUIWithModel:hopeModel];
}


-(void)setDetailModel:(DetailCommentModel *)detailModel
{
    _detailModel = detailModel;
    for(UIView *view in [self subviews])
    {
        [view removeFromSuperview];
    }
    [self setUpUIWithDetailModel:detailModel];
}


-(void)setUpUIWithModel:(HopeCommentModel *)hopeModel
{
    UIButton *commentNick = [[UIButton alloc] init];
//    commentNick.title = hopeModel.comment_nick;
    [commentNick setTitle:hopeModel.comment_nick forState:UIControlStateNormal];
    CGFloat X = 10;
    CGFloat Y = 5;
    CGSize comment_size = [commentNick.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]}];
    [commentNick setFrame:CGRectMake(X, Y, comment_size.width, comment_size.height)];
    [commentNick addTarget:self action:@selector(ChooseWanted:) forControlEvents:UIControlEventTouchUpInside];
    commentNick.tag = hopeModel.Row;
    [commentNick setFont:[UIFont systemFontOfSize:15]];
    [commentNick setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self addSubview:commentNick];
     UILabel *centerLabel = [[UILabel alloc] init];
    if(hopeModel.RecommentArray.count==0)
    {
        centerLabel.text = @"回复了您:";
    }else{
        centerLabel.text = @"回复了您的留言:";
    }
    CGFloat center_Y = 5;
    CGSize center_size = [centerLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]}];
    [centerLabel setFrame:CGRectMake(CGRectGetMaxX(commentNick.frame), center_Y, center_size.width, center_size.height)];
    [centerLabel setFont:[UIFont systemFontOfSize:12]];
    [self addSubview:centerLabel];
    
    UILabel *CommentDescLabel = [[UILabel alloc] init];
    CommentDescLabel.numberOfLines = 0;
    if(hopeModel.RecommentArray.count == 0)
    {
        CommentDescLabel.text = hopeModel.comment_description;
    }else{
        NSArray *array = hopeModel.RecommentArray.lastObject;
        CommentDescLabel.text = array.lastObject;
    }
    CGFloat comment_X = 20;
    CGFloat comment_Y = CGRectGetMaxY(centerLabel.frame)+5;
    CGFloat comment_width = winWidth-40;
    CGSize commentD_size = [CommentDescLabel.text boundingRectWithSize:CGSizeMake(comment_width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} context:nil].size;
    [CommentDescLabel setFrame:CGRectMake(comment_X, comment_Y, commentD_size.width, commentD_size.height)];
    [self addSubview:CommentDescLabel];
    
    UILabel *bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(CommentDescLabel.frame), 100, 30)];
    bottomLabel.center = CGPointMake(self.center.x, bottomLabel.center.y);
    bottomLabel.text = @"点击查看详情";
    [bottomLabel setTextColor:[UIColor colorWithRed:29/255.0 green:153/255.0 blue:229/255.0 alpha:1.0]];
    [bottomLabel setFont:[UIFont systemFontOfSize:12]];
    [self addSubview:bottomLabel];
    
    _hopeModel.height = CGRectGetMaxY(bottomLabel.frame);
}

-(void)setUpUIWithDetailModel:(DetailCommentModel *)detailModel
{
    UIButton *commentNick = [[UIButton alloc] init];
    [commentNick setTitle:detailModel.commentNick forState:UIControlStateNormal];
    CGFloat X = 10;
    CGFloat Y = 5;
    CGSize comment_size = [commentNick.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]}];
    [commentNick setFrame:CGRectMake(X, Y, comment_size.width, comment_size.height)];
    [commentNick addTarget:self action:@selector(ChooseGood:) forControlEvents:UIControlEventTouchUpInside];
    commentNick.tag = detailModel.Row;
    [commentNick setFont:[UIFont systemFontOfSize:15]];
    [commentNick setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self addSubview:commentNick];
    UILabel *centerLabel = [[UILabel alloc] init];
    
    if(detailModel.ReGoodCommentArray.count==0)
    {
        centerLabel.text = @"给您的商品留言:";
    }else{
        centerLabel.text = @"回复了您的商品留言:";
    }
    
    CGFloat center_Y = 5;
    CGSize center_size = [centerLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]}];
    [centerLabel setFrame:CGRectMake(CGRectGetMaxX(commentNick.frame), center_Y, center_size.width, center_size.height)];
    [centerLabel setFont:[UIFont systemFontOfSize:12]];
    [self addSubview:centerLabel];
    
    UILabel *CommentDescLabel = [[UILabel alloc] init];
    CommentDescLabel.numberOfLines = 0;
    if(detailModel.ReGoodCommentArray.count==0)
    {
        CommentDescLabel.text = detailModel.commentdescription;
    }else{
        NSArray *array = detailModel.ReGoodCommentArray.lastObject;
        CommentDescLabel.text = array.lastObject;
    }
    CGFloat comment_X = 20;
    CGFloat comment_Y = CGRectGetMaxY(centerLabel.frame)+5;
    CGFloat comment_width = winWidth-40;
    CGSize commentD_size = [CommentDescLabel.text boundingRectWithSize:CGSizeMake(comment_width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} context:nil].size;
    
    
    [CommentDescLabel setFrame:CGRectMake(comment_X, comment_Y, commentD_size.width, commentD_size.height)];
    [self addSubview:CommentDescLabel];
    
    UILabel *bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(CommentDescLabel.frame), 100, 30)];
    bottomLabel.center = CGPointMake(self.center.x, bottomLabel.center.y);
    bottomLabel.text = @"点击查看详情";
    [bottomLabel setTextColor:[UIColor colorWithRed:29/255.0 green:153/255.0 blue:229/255.0 alpha:1.0]];
    [bottomLabel setFont:[UIFont systemFontOfSize:12]];
    [self addSubview:bottomLabel];
    
    _detailModel.height = CGRectGetMaxY(bottomLabel.frame);
}

-(void)ChooseWanted:(UIButton *)btn
{
    if([self.delegate respondsToSelector:@selector(ChooseWantedButton:)])
    {
        [self.delegate ChooseWantedButton:btn];
    }
}
-(void)ChooseGood:(UIButton *)btn
{
    if([self.delegate respondsToSelector:@selector(ChooseGoodButton:)])
    {
        [self.delegate ChooseGoodButton:btn];
    }
}
@end
