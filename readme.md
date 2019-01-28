# Yandex Market - Database structure
Home assignment for Data management course at BI HSE, 2nd year

## Content
* [Subject area study](#subject_area)
* [Database design - conceptual level](#database_concept)
* [Database design - physical layer (external Layer)](#)
* [Creating procedures, functions, triggers and examples of their use](#)
* [Creating tables in SQL Server 2014 Management Studio](#)
* [Filling tables in SQL Server 2014 Management Studio](#)

<a name="subject_area"></a>
## Subject area study
Yandex.Market is a service for search and selection of goods. There is a huge choice on the Market: more than 100 million offers from 20 thousand stores.
Service users have access to detailed descriptions of product characteristics, product search by parameters, comparison of models and prices, customer reviews about products and stores, video reviews, seller ratings and other options that help customers make the right choice.

Describing this subject area, we can distinguish the following entities:

### Entities
`Yandex` - administration of the company "Yandex", which manages the entire process of supporting the infrastructure of Yandex Market

`Deferred` - deferred goods of a particular user, which can be returned later, usually this section is called "bookmarks"

`Product` - product presented on the platform containing reviews and a list of stores that have this product in stock

`Category` - a category combining similar products

`Specification` - characteristic describing a particular product

`Review` - feedback on specific product

`Delivery service` - Yandex Market delivery service serving customer's orders

`Delivery` - information about the delivery of a particular product

`Store` - store, Yandex Market partner, containing a list of products

`Price list` - specific store price list

`Advertisement` - particular store advertisement

`Price Plan` - pricing plan for certain advertisement

Designing the database for Yandex Market does not provide for a detailed consideration of the features of store advertising, user properties, and work with the delivery service.


<a name="database_concept"></a>
## Database design - conceptual level

Transfer the entity data to the ER Diagram and define the connections between them.
![yandex_market_conceptual_level](https://github.com/AndreyVolkovBI/SQL_Projects/blob/master/conceptual_level.png)

Pay attention to the features of this model:
1. In one category there may be many products and one product may be in several categories. Each category can have many characteristics, and each characteristic can reflect several categories at once. A single product can have many characteristics, and each characteristic can reflect several products. Such an intricate system with categories and characteristics is motivated by the implementation of a convenient search by categories and characteristics within each category. Read more - how to choose a product: https://yandex.ru/support/market/choice-goods/product-search.html

2. Recently, Yandex Market has abandoned the “Cart” on the web site, replacing it with the “Deferred” button without the ability to place an order. One buyer may have several deferred goods and one deferred product may have one buyer. Read more - why Yandex Market refused shopping cart: https://yandex.ru/support/partnermarket/purchase/about.html

3. Yandex cooperates with several delivery services and acts as an intermediary between the store and the delivery service. Therefore, in a model, a company may have multiple delivery services, or it may not have at all. One delivery service can have many deliveries, and one delivery can be served by only one delivery service.

4. The buyer can leave feedback on products, one review belongs to one buyer. A single product can have multiple reviews and one review can have one product.

5. A store in the price list can have many products, one product can be in several price lists at once. One store can have several deliveries at once, and one delivery can belong to only one store. A store can have several advertisements at once and one advertisement can belong to only one store. Each announcement has one tariff plan (price plan) and one tariff plan can be at once at several announcements.

<a name="database_physical"></a>
## Database design - physical layer (external Layer)
![yandex_market_physical_level](https://github.com/AndreyVolkovBI/SQL_Projects/blob/master/physical_level.png)

<a name="creating_proc_func_trig"></a>
## Creating procedures, functions, triggers and examples of their use

<a name="creating_tables"></a>
## Creating tables in SQL Server 2014 Management Studio

<a name="filling_tables"></a>
## Filling tables in SQL Server 2014 Management Studio

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
