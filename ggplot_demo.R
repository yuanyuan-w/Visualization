library(ggplot2)

setwd('F:\\R\\R case\\visualization')
# load data
book_info <- read.csv('book_douban.csv',  header=F)
colnames = c('name', 'ratings', 'comment_num', 'price', 'author', 'pub', 'url')
book_info_df <- as.data.frame(book_info, col.names=colnames)
plot_data <- data.frame(book_info_df[1], as.vector(unlist(book_info_df[2])), 
                        as.vector(unlist(book_info_df[3])), as.vector(unlist(book_info_df[4])))
colnames(plot_data) <- c('name', 'ratings', 'comments', 'price')

# data preprocess
plot_data$rating_level[plot_data$ratings >= 9.0] <- 'great'
plot_data$rating_level[plot_data$ratings >= 8.0 & plot_data$ratings < 9.0 ] <- 'good'
plot_data$rating_level[plot_data$ratings >= 7.0 & plot_data$ratings < 8.0 ] <- 'average'
plot_data$rating_level[plot_data$ratings < 7.0 ] <- 'low'
plot_data$rating_level <- factor(plot_data$rating_level, 
                            levels = c('great', 'good', 'average', 'low'))
# visulization

# 各档评分的多少
ggplot(plot_data,aes(x=rating_level, ))+
  geom_bar()
# 可以看出，average档（7.0—8.0）的评分比较多，其次是good（8.0-9.0）
# 特别好great（>9.0）和low都比较少,近似于正态分布

# 评论人数与评分的关系
# 初步可视化分析
ggplot(plot_data, aes(x = comments, y = ratings, colour = ratings))+
  geom_point()+
  xlim(c(0, 1500))
# 关注大部分数据样本
ggplot(plot_data, aes(x = comments, y = ratings, colour = ratings))+
  geom_point()+
  xlim(c(0, 500))
# 评论数和评分高低似乎没有明显的联系
# 气泡图
ggplot(plot_data, aes(x = comments, y = ratings, size = price, colour = rating_level))+
  geom_point(alpha = .5)+
  xlim(c(0, 1500))+
  scale_size_area()+
  scale_color_brewer(palette = 'Set1')
# 数据分布呈现倒三角的形状，至少可以发现：评论数越多，评分低的可能性越小

# 评分高的大多价钱比较高
ggplot(plot_data, aes(x = ratings, y = price, size = price, colour = rating_level))+
  geom_point(alpha = .5)+
  ylim(c(0, 150))+
  scale_size_area()+
  scale_color_brewer(palette = 'Set1')+
  geom_smooth(method = 'lm')

# 评分和评论数量统计上相关性分析
cor(plot_data$ratings, plot_data$comments)
cor.test(plot_data$ratings, plot_data$comments)
# 结论：几乎没有相关性

# # 评分和价钱统计上相关性分析
cor(plot_data$ratings, plot_data$price)
cor.test(plot_data$ratings, plot_data$price)
# 结论：评分和价钱有一定的正相关，特别是在评分在8-9之间的书中，验证了一个古老的哲理：一分价钱一分货
# 但是，也存在质量与价格不对等的情况，这种现象在评分低的书中表现得尤为明显。
