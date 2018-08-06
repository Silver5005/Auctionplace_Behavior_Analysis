library(pacman) # package for loading packages
library(dplyr)# data manipulation and pipes
library(ggplot2)

library(RColorBrewer) # data visualization
library(extrafont)
library(gridExtra)

# Load in Ebay data
ebay_cartier <- read.csv("../Desktop/R coding/Data/EbayAuctions.csv", header = T) %>%
  filter(item == "Xbox game console") %>% 
  tbl_df()
head(ebay_cartier)

# Initialize variables
str(ebay_cartier)
# Number of auctions
n_distinct(ebay_cartier$auctionid) 
# Average final price of an item
round(mean(ebay_cartier$price)) 

# Set text theme
text_theme <- theme(text = element_text(size = 10, 
                                        family = "Verdana", 
                                        face = "italic"),
                    plot.title = element_text(hjust = 0.5))

# Distribution of prices (graph 1)
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

# Adding new factor variable: Auction Length
ebay_cartier$auction_type_f <- factor(ebay_cartier$auction_type, 
                                      labels = c("3 days", "5 days", "7 days"))

# Number of each auction type (graph 2)
ggplot(ebay_cartier, 
       aes(x = factor(1), 
           fill = auction_type_f)) +
  geom_bar(width = 3) +
  ggtitle("Auctions' per type") +
  coord_polar(theta = "y") +
  labs(fill= "Type of auction") +
  scale_fill_brewer(palette = "PRGn") +
  xlab(NULL) + ylab(NULL) +
  text_theme 

# It appears 7 day auctions are more popular than 5 or 3 day alternatives.
#---------------------------------------------------------------------------
# Checks distribution of bids per auction type: Determine best time frame for sellers (graph 3)

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


# The most common auction type has the most bids, as should be expect.  
#---------------------------------------------------------------------------

# What happens when we filter for low starting price?
#Checks low vs high starting prices to see optimal selling strategy.

# Violen graph to display distribution (graph 4)
violin_auction_type <- geom_violin(aes(fill = auction_type_f), 
                                   col = "white", scale = "area",  alpha = 0.5) 
# ggplot for visualization
# Bids at various starting prices, seperated by auction type
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

# It appears lower starting prices does indeed produce more total bids/interest, especially for 7 day auctions.
#---------------------------------------------------------------------------

#Lets take a look at high starting bids; do they actually lead to higher final prices? (graph 5)
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
  coord_cartesian(ylim = c(0, 400)) # few outliers masked

# We can see 7 day auctions (the most popular), tend to produce higher average prices, and this was the auction with
#on average the lowest starting bid.  i.e higher opening bids do not mean higher final prices.
#---------------------------------------------------------------------------

# But does the higher price mean the higher gain for seller?
# add new column to auctions: seller_gain 
auctions <- auctions %>%
  mutate(seller_gain = price - openbid)

# Relationship between seller gain and final price (graph 6)
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

# The majority of the time, it appears a higher price does correlate to a higher gain.
