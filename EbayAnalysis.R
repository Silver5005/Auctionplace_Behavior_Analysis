library(pacman) # package for loading packages
library(dplyr)# data manipulation and pipes
library(ggplot2)

library(RColorBrewer) # data visualization
library(extrafont)
library(gridExtra)

#load in Ebay data
ebay_cartier <- read.csv("../Desktop/R coding/Data/EbayAuctions.csv", header = T) %>%
  filter(item == "Xbox game console") %>% 
  tbl_df()
head(ebay_cartier)

str(ebay_cartier)
# number of auctions
n_distinct(ebay_cartier$auctionid) 
# average final price of an item
round(mean(ebay_cartier$price)) 

text_theme <- theme(text = element_text(size = 10, 
                                        family = "Verdana", 
                                        face = "italic"),
                    plot.title = element_text(hjust = 0.5))

# distribution of prices
ggplot(ebay_cartier, 
       aes(x = price)) + 
  geom_histogram(binwidth = 85, 
                 fill = "#008B8B", 
                 col = "white") +
  geom_vline(aes(xintercept = mean(ebay_cartier$price)), 
             col = "yellow",
             size = 1.5) +
  labs(title = "Distribution of final prices",
       x = "Final prices",
       y = "Frequency") +
  text_theme

#--------------------------------------------------------------------------------------------

# adding new factor variable
ebay_cartier$auction_type_f <- factor(ebay_cartier$auction_type, 
                                      labels = c("3 days", "5 days", "7 days"))

# distribution of auction types (by length)
ggplot(ebay_cartier, 
       aes(x = factor(1), 
           fill = auction_type_f)) +
  geom_bar(width = 3) +
  ggtitle("Auctions' bid distribution per type") +
  coord_polar(theta = "y") +
  labs(fill= "Type of auction") +
  scale_fill_brewer(palette = "PRGn") +
  xlab(NULL) + ylab(NULL) +
  text_theme 

# select what we need for further analysis
auctions <- ebay_cartier %>% 
  select(contains('id'), price, auction_type_f, -bidtime) %>%
  unique() # to make sure there is no repetitions

#---------------------------------------------------------------------

# few ggplot complements 
bar_auction_type <- geom_bar(aes(fill = auction_type_f), 
                             stat = "count")

palette <- scale_fill_brewer(palette = "Set2") 


# We can draw a table: number of auction per type
auctions %>%  
  group_by(auction_type_f) %>%
  summarize(n_auctions = n_distinct(auctionid))

# Or a bar chart with the same results:
# distribution of auction types for Xbox console
bar_p1<- ggplot(auctions %>% filter(price == bid),
                aes(x = auction_type_f)) +
  bar_auction_type +
  palette + 
  labs(title = "Xbox sales", 
       x = "Type of an eBay auction", 
       y = "Number of auctions") +
  guides(fill = F) +
  text_theme +
  coord_cartesian(ylim = c(0,100))
grid.arrange(bar_p1)

#---------------------------------------------------------------------------
#Checks distribution of bids per auction type to determine best time frame for sellers

bar_p2 <- auctions %>% 
  select(auctionid, auction_type_f, bid) %>%
  group_by(auctionid) %>%
  ggplot(aes(x = auction_type_f)) + 
  bar_auction_type + 
  palette + 
  labs(title = "Xbox sales", 
       x = "Type of an eBay auction", 
       y = "Number of bids per auctions") +
  guides(fill = F) +
  text_theme

grid.arrange(bar_p2)

#The most common auction type has the most bids, as should be expect.  What happens when we filter for low starting price?
#Checks low vs high starting prices to see optimal selling strategy.

violin_auction_type <- geom_violin(aes(fill = auction_type_f), 
                                   col = "white", scale = "area",  alpha = 0.5) 

ggplot(auctions, 
       aes(x = auction_type_f, y = openbid)) + 
  violin_auction_type +
  palette + 
  geom_point(col = "darkgrey", alpha = 0.2) +
  labs(title = "Distribution of starting prices",
       x = "Type of an eBay auction", 
       y = "Starting price per auction") +
  guides(fill = F) +
  text_theme +
  coord_cartesian(ylim = c(0, 150)) # few outliers masked

#Bids at various starting prices, seperated by auction type
#It appears lower starting prices does indeed produce more total bids/interest, especially for 7 day auctions.

#---------------------------------------------------------------------------------------------------------------------
#Lets take a look at high starting bids; do they actually lead to higher final prices?

ggplot(auctions, 
       aes(x = auction_type_f, y = price)) + 
  geom_boxplot(aes(fill = auction_type_f), 
               color = "darkgrey")  +
  labs(title = "Final price per action", 
       x = "Type of an auction", 
       y = "Final price") +
  guides(fill = F) +
  scale_fill_brewer(palette = "PRGn") + 
  text_theme + 
  coord_cartesian(ylim = c(0, 500)) # few outliers masked

#We can see 7 day auctions (the most popular), tend to produce higher average prices, and this was the auction with
#on average the lowest starting bid.  i.e higher opening bids do not mean higher final prices.


#But does the higher price mean the higher gain for seller?

# add new column to auctions: seller_gain 
auctions <- auctions %>% 
  mutate(seller_gain = price - openbid)

# relationship between seller gain and final price
ggplot(auctions, 
       aes(x = seller_gain, y = price)) + 
  geom_jitter(alpha = 0.3, col = "lightgrey") +
  geom_smooth(se = F, 
              aes(col = auction_type_f)) +
  labs(title = "Ratio gain/price per auction", 
       x = "Total seller gain", 
       y = "Final price",
       colour = "Auction type") +
  text_theme +
  coord_cartesian(ylim = c(0, 500))

#The majority of the time, it appears it does.
