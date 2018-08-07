# Auctionplace_Behavior_Analysis
Uses R to analyze Ebay auction data in order to draw conclusion from seller/buyer behavior.

Analyzes questions such as:

  I. "Whats our price distribution?"

  II. "Which length auction is the most common?"

  III. "Which length autction gets the most bids (best for seller)"

  IV. "How does initial price effect final price?"

  V. "How does final price effect seller gain?"

The data contains multiple items in the data set, but for simplification we take just the "Xbox console" sales.
Here is the distribution of our prices for the consoles: 

![pricedist](https://user-images.githubusercontent.com/34739163/43706849-b849230c-9923-11e8-969d-38ff2bd8ae1f.png)

First we bucket auctions into their respective durations (3 day, 5 day, 7 day): 

![auctionbids](https://user-images.githubusercontent.com/34739163/43706855-bda970fe-9923-11e8-8938-5e460a233ca4.png)

It appears 7 day actions are the most popular option, let's check the distribution of bids for each auction type to see whats best for sellers:

![xboxsales](https://user-images.githubusercontent.com/34739163/43706863-c5117544-9923-11e8-8ecb-6273b2564798.png)

It appears the most popular auction type also generates the most buyer interest.

What happens when we filter starting prices as high vs low?  How does this effect final price?:

![startpricedist](https://user-images.githubusercontent.com/34739163/43706869-c958bf54-9923-11e8-90cf-ada623b36572.png)

It appears lower starting prices does indeed produce more total bids/interest, especially for 7 day auctions.

Alternatively, lets take a look at high starting bids; do they actually lead to higher final prices?:

![finalprice](https://user-images.githubusercontent.com/34739163/43707865-47cf30e6-9926-11e8-8343-4646d91121fa.png)

We can see 7 day auctions (the most popular), tend to produce higher average prices. This was the auction with
on average the lowest starting bid.  i.e higher opening bids do not mean higher final prices.

Lastly, we can see if a higher final price correlates to a higher overall gain for the seller:

![sellergain](https://user-images.githubusercontent.com/34739163/43706875-cc45a86c-9923-11e8-8af7-1c8ddd22dbec.png)

This particular dataset shows that indeed a higher price does correlate with a higher net gain for seller.
