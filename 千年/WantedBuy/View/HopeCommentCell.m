//
//  HopeCommentCell.m
//  千年
//
//  Created by God on 16/1/9.
//  Copyright © 2016年 God. All rights reserved.
//

#import "HopeCommentCell.h"

@implementation HopeCommentCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(HopeCommentModel *)model
{
    _model = model;
    [self setUpUIlabel];
    [self SetUIWithModel:model];
}
-(void)setUpUIlabel
{
    for(UIView *view in [self subviews])
    {
        [view removeFromSuperview];
    }
    CommentMan = [[UILabel alloc]init];
    CenterLabel = [[UILabel alloc]init];
    HopeMan = [[UILabel alloc]init];
    HopeComment = [[UILabel alloc]init];
    TimeLabel = [[UILabel alloc]init];
    [TimeLabel setTextColor:[UIColor lightGrayColor]];
    CenterLabel.text = @"回复";
    HopeComment.numberOfLines = 0;
    
//    REcommentMan = [[UIButton alloc] init];
//    RecommentUser = [[UIButton alloc] init];
//    
//    ContentLabel = [[UILabel alloc] init];
//    ContentLabel.numberOfLines = 0;
    
    [self addSubview:CommentMan];
    [self addSubview:CenterLabel];
    [self addSubview:HopeMan];
    [self addSubview:HopeComment];
    [self addSubview:TimeLabel];
    
//    [self addSubview:RecommentUser];
//    [self addSubview:REcommentMan];
//    [self addSubview:ContentLabel];
}
-(void)SetUIWithModel:(HopeCommentModel *)model
{
    CommentMan.text = model.comment_nick;
    CGFloat CommentMan_X = 5;
    CGFloat CommentMan_Y = 5;
    CGSize CommentMan_size = [CommentMan.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]}];
    [CommentMan setFrame:CGRectMake(CommentMan_X, CommentMan_Y, CommentMan_size.width, CommentMan_size.height)];
    [CommentMan setFont:[UIFont systemFontOfSize:15]];
    [CommentMan setTextColor:[UIColor redColor]];
    
    TimeLabel.text = [NSString timeWithString:model.comment_time];
    
    CGSize Time_size = [TimeLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]}];
    CGFloat Time_Y = CGRectGetMinY(CommentMan.frame);
    CGFloat Time_X = winWidth - Time_size.width ;
    [TimeLabel setFrame:CGRectMake(Time_X, Time_Y, Time_size.width, Time_size.height)];
    [TimeLabel setFont:[UIFont systemFontOfSize:12]];
    
    HopeComment.text = model.comment_description;
    CGFloat HopeComment_X = 10;
    CGFloat HopeComment_Y = CGRectGetMaxY(CommentMan.frame);
    CGSize HopeComment_size = [HopeComment.text boundingRectWithSize:CGSizeMake(winWidth-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]} context:nil].size;
    [HopeComment setFrame:CGRectMake(HopeComment_X, HopeComment_Y, HopeComment_size.width, HopeComment_size.height)];
    HopeComment.font = [UIFont systemFontOfSize:18];
    
    int i = 5;
    
    if(model.RecommentArray!=nil)
    {
        for(NSArray *tmpArray in model.RecommentArray)
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
                        [RecommentUser setFrame:CGRectMake(CGRectGetMinX(HopeComment.frame), CGRectGetMaxY(label.frame), Btn_size.width, Btn_size.height)];
                    }
                }
            }else
            {
                [RecommentUser setTitle:[tmpArray objectAtIndex:2] forState:UIControlStateNormal];
                CGSize Btn_size = [RecommentUser.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]}];
                [RecommentUser setFrame:CGRectMake(CGRectGetMinX(HopeComment.frame), CGRectGetMaxY(HopeComment.frame), Btn_size.width, Btn_size.height)];
            }
            
            NSString *string = [NSString stringWithFormat:@"%@%li",[tmpArray objectAtIndex:0],model.Row];
//            NSLog(@"%@",string);
            
            [RecommentUser addTarget:self action:@selector(Recomment:) forControlEvents:UIControlEventTouchUpInside];

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
                [contectLabel setFrame:CGRectMake(20, CGRectGetMaxY(RecommentUser.frame)+2, con_size.width, con_size.height)];
                contectLabel.font = [UIFont systemFontOfSize:15];
                [self addSubview:contectLabel];
             i++;
        }
    }
    for(UIView *view in [self subviews])
    {
        if(view.tag == i-1)
        {
            UILabel *label = (UILabel *)view;
            _Height = CGRectGetMaxY(label.frame)+5;
            model.height = CGRectGetMaxY(label.frame)+5;
        }else
        {
            _Height = CGRectGetMaxY(HopeComment.frame)+5;
            model.height = CGRectGetMaxY(HopeComment.frame)+5;
        }
    }
}

-(void)Recomment:(UIButton *)btn
{
    
    NSString *string = [NSString stringWithFormat:@"%li",btn.tag];
    
    NSString *username = [string substringToIndex:11];
    NSString *ROW = [string substringFromIndex:11];

    if([self.delegate respondsToSelector:@selector(didSelectedWithUserName:UserNick:Row:)])
    {
        [self.delegate didSelectedWithUserName:username UserNick:btn.titleLabel.text Row:[ROW integerValue]];
    }
}

@end
