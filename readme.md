# Yandex Market - Database structure
Home assignment for Data management course at BI HSE, 2nd year
## Yandex Market - subject area study
Yandex.Market is consultant for products and prices. In the Yandex.Market catalog you will find the widest selection of products ranging from kitchen utensils and children's toys to auto parts and air conditioners.
![yandex_market_diagram](https://github.com/AndreyVolkovBI/SQL_Projects/blob/master/yandex_market_diagram.png)
## Entities
`Yandex` - the company owns Yandex Market

`Customer` - a customer of Yandex Market

`Shipping Service` - Yandex delivery service

`Store` - online stores, Yandex Market's partners

`Cart` - each user has a cart with multiple orders

`Order` - one particular order that could contain several products

`Product` - product item represented by Yandex Market itself

`Review` - feedback on specific product

`Shipping` - shipping details

`Price list` - each store has its own price list that contains informations about all the available products

`Advertisement` - each store could have its own advertisement inside the Yandex Market platform

`Price plan` - each advertisement has to have specific price plan

## Procedures
1. add_store_to_product(@storeId int, @productId int)  -- adds store to product card by ids
2. add_review_to_product(@reviewId int, @productId int, @userId int)  -- adds review to a specific product
3. add_new_user(@full_name nvarchar(50), @email nvarchar(100), @password nvarchar(100))  -- adds new user
4. add_product_to_cart(@productId int, @cartId int)  -- adds product to cart by product and cart ids

## Functions
1. get_orders_by_user_id(@userId int)  -- returns all orders from particular user
2. get_ads_by_store_id(@storeId int)  -- returns all ads of particular store

## Triggers
1. add_new_user_password_validation  -- checks password validation
2. add_reminder_for_shipping  -- adds reminder when shipping is submitted


## Functions Samples
```sql
create function yandexMarketSchema.get_orders_by_user_id(@userId int)
returns table
as
return (
	Select *
	from yandexMarketSchema.Order as yms_order
	where Id like @userId
);
go

create function yandexMarketSchema.get_ads_by_store_id(@storeId int)
returns table
as
return (
	Select *
	from yandexMarketSchema.Advertisement as yms_ad
	where Id like @storeId
);
go
```


## References
About Yandex Market: https://yandex.ru/support/partnermarket/

Placing a store on Yandex Market: https://yandex.ru/support/partnermarket/registration/how-to-register.html

Price list: https://yandex.ru/support/partnermarket/export/recommendation.html#recommendation

Questions about the product: https://yandex.ru/support/market/opinions/discussion.html

Store rating: https://yandex.ru/support/market/opinions/rating.html

Yandex delivery service: https://delivery.yandex.ru/

Store products on Market: https://yandex.ru/adv/products/classified/market/

Application placement positions: https://yandex.ru/support/partnermarket/about/placement-positions.html
