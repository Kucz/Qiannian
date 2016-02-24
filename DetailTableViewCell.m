//
//  DetailTableViewCell.m
//  千年
//
//  Created by God on 16/1/10.
//  Copyright © 2016年 God. All rights reserved.
//

#import "DetailTableViewCell.h"
#import "UIButton+WebCache.h"
@implementation DetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setUILable
{
    for(UIView *view in [self subviews])
    {
        [view removeFromSuperview];
    }
    headImageButton = [[UIButton alloc]init];
    nickNameLabel = [[UILabel alloc]init];
    timeLabel = [[UILabel alloc]init];
    CommentLabel = [[UILabel alloc]init];
    CommentLabel.numberOfLines = 0;
    [timeLabel setTextColor:[UIColor lightGrayColor]];
    [nickNameLabel setTextColor:[UIColor redColor]];
    [self addSubview:headImageButton];
    [self addSubview:timeLabel];
    [self addSubview:CommentLabel];
    [self addSubview:nickNameLabel];
    
}
-(void)setViewWithModel:(DetailCommentModel *)model
{
    [headImageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",model.commentImageUrl,Base_url]] forState:UIControlStateNormal];
    [headImageButton setFrame:CGRectMake(2, 2, 30, 30)];
    headImageButton.layer.cornerRadius = headImageButton.bounds.size.width/2;
    headImageButton.layer.masksToBounds = YES;
    
    nickNameLabel.text = model.commentNick;
    CGSize nick_size = [nickNameLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]}];
    [nickNameLabel setFrame:CGRectMake(CGRectGetMaxX(headImageButton.frame)+10, 2, nick_size.width, nick_size.height)];
    [nickNameLabel setFont:[UIFont systemFontOfSize:13]];
    nickNameLabel.font = [UIFont systemFontOfSize:15];
    
    timeLabel.text = [NSString timeWithString:model.commenttime];
    CGSize time_size = [timeLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]}];
    [timeLabel setFrame:CGRectMake(winWidth-time_size.width-5, CGRectGetMaxY(nickNameLabel.frame), time_size.width, time_size.height)];
    [timeLabel setFont:[UIFont systemFontOfSize:12]];
    
    
    CommentLabel.text = model.commentdescription;
    CGFloat Comment_W = winWidth-time_size.width-10;
    CGSize comment_size = [CommentLabel.text boundingRectWithSize:CGSizeMake(Comment_W, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
    [CommentLabel setFrame:CGRectMake(CGRectGetMaxX(headImageButton.frame)+10, CGRectGetMinY(timeLabel.frame)+10, comment_size.width, comment_size.height)];
    CommentLabel.font = [UIFont systemFontOfSize:15];
    CommentLabel.font = [UIFont fontWithName:@"Hiragino Sans" size:15];
    
    
    
    int i = 5;
    
    if(model.ReGoodCommentArray!=nil)
    {
        for(NSArray *tmpArray in model.ReGoodCommentArray)
        {
            UIButton *RecommentUser = [[UIButton alloc] init];
            [RecommentUser setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            if(i!=5)
            {
                for(UIView *view in [self subviews])
                {
                    if(view.tag == i-1)
                    {
                        UILabel *label = (UILabel *)view;
                        
                        [RecommentUser setTitle:[tmpArray objectAtIndex:2] forState:UIControlStateNormal];
                        CGSize Btn_size = [RecommentUser.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]}];
                        [RecommentUser setFrame:CGRectMake(CGRectGetMinX(headImageButton.frame), CGRectGetMaxY(label.frame), Btn_size.width, Btn_size.height)];
                    }
                }
            }else
            {
                [RecommentUser setTitle:[tmpArray objectAtIndex:2] forState:UIControlStateNormal];
                CGSize Btn_size = [RecommentUser.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]}];
                [RecommentUser setFrame:CGRectMake(CGRectGetMinX(headImageButton.frame), CGRectGetMaxY(CommentLabel.frame)+5, Btn_size.width, Btn_size.height)];
            }
            
            NSString *string = [NSString stringWithFormat:@"%@%li",[tmpArray objectAtIndex:0],model.Row];
            [RecommentUser addTarget:self action:@selector(REGoodComment:) forControlEvents:UIControlEventTouchUpInside];
            RecommentUser.tag = [string integerValue];
            RecommentUser.titleLabel.font = [UIFont systemFontOfSize:12];
            [self addSubview:RecommentUser];
            
            UILabel *CenterLabel1 = [[UILabel alloc] init];
            CenterLabel1.text = @"回复";
            CGSize Cen_size = [CenterLabel1.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]}];
            [CenterLabel1 setFrame:CGRectMake(CGRectGetMaxX(RecommentUser.frame), CGRectGetMinY(RecommentUser.frame), Cen_size.width, Cen_size.height)];
            [CenterLabel1 setFont:[UIFont systemFontOfSize:12]];
            [self addSubview:CenterLabel1];
            
            UIButton *RecommentMann = [[UIButton alloc] init];
            [RecommentMann setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [RecommentMann setTitle:[tmpArray objectAtIndex:3] forState:UIControlStateNormal];
            CGSize btn_size2 = [RecommentMann.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]}];
            [RecommentMann setFrame:CGRectMake(CGRectGetMaxX(CenterLabel1.frame)-10, CGRectGetMinY(CenterLabel1.frame), btn_size2.width, btn_size2.height)];
            RecommentMann.titleLabel.font = [UIFont systemFontOfSize:12];
            [self addSubview:RecommentMann];
            
            UILabel *centerlabel2 = [[UILabel alloc] init];
            centerlabel2.text = @":";
            CGSize label_size = [centerlabel2.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]}];
            [centerlabel2 setFrame:CGRectMake(CGRectGetMaxX(RecommentMann.frame), CGRectGetMinY(RecommentMann.frame), label_size.width, label_size.height)];
            centerlabel2.font = [UIFont systemFontOfSize:12];
            [self addSubview:centerlabel2];
            
            UILabel *contectLabel= [[UILabel alloc] init];
            contectLabel.numberOfLines = 0;
            contectLabel.tag = i;
            contectLabel.text = [tmpArray objectAtIndex:4];
            CGSize con_size = [contectLabel.text boundingRectWithSize:CGSizeMake(winWidth-40,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} context:nil].size;
            [contectLabel setFrame:CGRectMake(20, CGRectGetMaxY(RecommentUser.frame), con_size.width, con_size.height)];
            contectLabel.font = [UIFont systemFontOfSize:13];
            [self addSubview:contectLabel];
            i++;
        }
    }
    for(UIView *view in [self subviews])
    {
        if(view.tag == i-1)
        {
            UILabel *label = (UILabel *)view;
            model.height = CGRectGetMaxY(label.frame)+5;
        }else
        {
            model.height = CGRectGetMaxY(CommentLabel.frame)+5;
        }
    }
}

-(void)setModel:(DetailCommentModel *)model
{
    _model = model;
    [self setUILable];
    [self setViewWithModel:model];
}

-(void)REGoodComment:(UIButton *)btn
{
    NSString *string = [NSString stringWithFormat:@"%li",btn.tag];
    NSString *userName = [string substringToIndex:11];
    NSString *ROW = [string substringFromIndex:11];
    if([self.delegate respondsToSelector:@selector(didSelectedWithUsername:UserBick:Row:)])
    {
        [self.delegate didSelectedWithUsername:userName UserBick:btn.titleLabel.text Row:[ROW integerValue]];
    }
}

@end
