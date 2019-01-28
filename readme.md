# Yandex Market - Database structure
Home assignment for Data management course at BI HSE, 2nd year

## Content
* [Subject area study](#subject_area)
* [Database design - conceptual level](#database_concept)
* [Database design - physical layer (external Layer)](#database_physical)
* [Creating procedures, functions, triggers and examples of their use](#creating_proc_func_trig)
* [Creating tables in SQL Server 2014 Management Studio](#creating_tables)
* [Filling tables in SQL Server 2014 Management Studio](#filling_tables)

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

Let's transfer the conceptual model to the physical level.
![yandex_market_physical_level](https://github.com/AndreyVolkovBI/SQL_Projects/blob/master/physical_level.png)

In this model, entities appear with properties, an explicit link is created by identifiers, the model is supplemented with aggregating entities for implementing many-to-many relationships (SpecificationInCategory, ProductInCategory, SpecificationOfProduct, ProductInStore).

<a name="creating_proc_func_trig"></a>
## Creating procedures, functions, triggers and examples of their use

### Procedures

`how_many_clicks_left` - a procedure that counts how many clicks on a store advertisement a user has left

![how_many_clicks_left](https://github.com/AndreyVolkovBI/SQL_Projects/blob/master/ManagementStudio/Procedures/how_many_clicks_left.png)
![how_many_clicks_left_result](https://github.com/AndreyVolkovBI/SQL_Projects/blob/master/ManagementStudio/Procedures/how_many_clicks_left_result.png)

`all_deferred_by_customer_id` - a procedure that displays all deferred goods user by customer id

![all_deferred_by_customer_id](https://github.com/AndreyVolkovBI/SQL_Projects/blob/master/ManagementStudio/Procedures/all_defered_by_customer_id.png)
![all_deferred_by_customer_id_result](https://github.com/AndreyVolkovBI/SQL_Projects/blob/master/ManagementStudio/Procedures/all_defered_by_customer_id_result.png)

`all_reviews_by_customer_id` - a procedure that shows all customer's reviews

![all_reviews_by_customer_id](https://github.com/AndreyVolkovBI/SQL_Projects/blob/master/ManagementStudio/Procedures/all_reviews_by_customer_id.png)
![all_reviews_by_customer_id_result](https://github.com/AndreyVolkovBI/SQL_Projects/blob/master/ManagementStudio/Procedures/all_reviews_by_customer_id_result.png)

`show_product_with_specifications_and_categories` - procedure that shows all the characteristics of products and categories

![show_product_with_specifications_and_categories](https://github.com/AndreyVolkovBI/SQL_Projects/blob/master/ManagementStudio/Procedures/show_products_with_specifications_and_categories.png)
![show_product_with_specifications_and_categories_result](https://github.com/AndreyVolkovBI/SQL_Projects/blob/master/ManagementStudio/Procedures/show_prod_result.png)

`add_customer` - adds a customer to a table with customers

![add_customer](https://github.com/AndreyVolkovBI/SQL_Projects/blob/master/ManagementStudio/Procedures/proc_add_customer.png)
![add_customer_result](https://github.com/AndreyVolkovBI/SQL_Projects/blob/master/ManagementStudio/Procedures/proc_res.png)

### Functions

`get_advertising_by_store_id` - a function that returns a table with a description of the specific store's price plan

![get_advertising_by_store_id](https://github.com/AndreyVolkovBI/SQL_Projects/blob/master/ManagementStudio/func/get_ads_by_store_id.png)
![get_advertising_by_store_id_result](https://github.com/AndreyVolkovBI/SQL_Projects/blob/master/ManagementStudio/func/get_ads_by_store_id_result.png)

`get_all_stores_with_info_that_have_product` - a function that returns a table with information about stores that have a specific product

![get_all_stores_with_info_that_have_product](https://github.com/AndreyVolkovBI/SQL_Projects/blob/master/ManagementStudio/func/get_all_stores.png)
![get_all_stores_with_info_that_have_product_result](https://github.com/AndreyVolkovBI/SQL_Projects/blob/master/ManagementStudio/func/get_all_stores_result.png)

### Triggers

`password_validation` - a trigger that terminates a transaction if the number of characters in the password is less than five

![password_validation](https://github.com/AndreyVolkovBI/SQL_Projects/blob/master/ManagementStudio/trigger/validation_password.png)
As a result, the operation was interrupted while trying to add a user with a password length of less than 5 characters.
![password_validation_result](https://github.com/AndreyVolkovBI/SQL_Projects/blob/master/ManagementStudio/trigger/trig_res.png)

`yandex_validation` - a trigger that interrupts a transaction when trying to insert data into the Yandex table, into which you cannot insert data
![yandex_validation](https://github.com/AndreyVolkovBI/SQL_Projects/blob/master/ManagementStudio/trigger/insert_error.png)
When you try to insert data into the Yandex table, the trigger fires and completes the transaction.
![yandex_validation](https://github.com/AndreyVolkovBI/SQL_Projects/blob/master/ManagementStudio/trigger/valid_result.png)

<a name="creating_tables"></a>
## Creating tables in SQL Server 2014 Management Studio

The database diagram in SQL Server 2014 Management Studio completely copies both the properties and the location of the database model at the physical level.

![yandex_market_tables_first_part](https://github.com/AndreyVolkovBI/SQL_Projects/blob/master/ManagementStudio/schema/first_part.png)
![yandex_market_tables_second_part](https://github.com/AndreyVolkovBI/SQL_Projects/blob/master/ManagementStudio/schema/second_part.png)

<a name="filling_tables"></a>
## Filling tables in SQL Server 2014 Management Studio

Tables are populated by performing data insertion into the table.

### Yandex
![yandex_market_tables_filling_yandex](https://github.com/AndreyVolkovBI/SQL_Projects/blob/master/ManagementStudio/tables/yandex_table.png)

### Customer
![yandex_market_tables_filling_customer](https://github.com/AndreyVolkovBI/SQL_Projects/blob/master/ManagementStudio/tables/customer.png)

### Deferred
![yandex_market_tables_filling_deferred](https://github.com/AndreyVolkovBI/SQL_Projects/blob/master/ManagementStudio/tables/deffered_table.png)

### Review
![yandex_market_tables_filling_review](https://github.com/AndreyVolkovBI/SQL_Projects/blob/master/ManagementStudio/tables/review_table.png)

### Store
![yandex_market_tables_filling_store](https://github.com/AndreyVolkovBI/SQL_Projects/blob/master/ManagementStudio/tables/store_table.png)

### Advertisement
![yandex_market_tables_filling_advertisement](https://github.com/AndreyVolkovBI/SQL_Projects/blob/master/ManagementStudio/tables/advertisement_table.png)

### Price Plan
![yandex_market_tables_filling_price_plan](https://github.com/AndreyVolkovBI/SQL_Projects/blob/master/ManagementStudio/tables/price_plan_table.png)

### Delivery Service
![yandex_market_tables_filling_delivery_service](https://github.com/AndreyVolkovBI/SQL_Projects/blob/master/ManagementStudio/tables/delivery_service_table.png)

### Delivery
![yandex_market_tables_filling_delivery](https://github.com/AndreyVolkovBI/SQL_Projects/blob/master/ManagementStudio/tables/delivery_table.png)

### Product
![yandex_market_tables_filling_product](https://github.com/AndreyVolkovBI/SQL_Projects/blob/master/ManagementStudio/tables/product.png)

### Product In Store
![yandex_market_tables_filling_product_in_store](https://github.com/AndreyVolkovBI/SQL_Projects/blob/master/ManagementStudio/tables/product_in_store.png)

### Category
![yandex_market_tables_filling_category](https://github.com/AndreyVolkovBI/SQL_Projects/blob/master/ManagementStudio/tables/category_table.png)

### Specification
![yandex_market_tables_filling_specification](https://github.com/AndreyVolkovBI/SQL_Projects/blob/master/ManagementStudio/tables/specification_table.png)

### Specification In Category
![yandex_market_tables_filling_specification_in_category](https://github.com/AndreyVolkovBI/SQL_Projects/blob/master/ManagementStudio/tables/specification_in_category.png)

### Product In Category
![yandex_market_tables_filling_product_in_category](https://github.com/AndreyVolkovBI/SQL_Projects/blob/master/ManagementStudio/tables/product_in_category.png)

### Specification Of Product
![yandex_market_tables_filling_specification_of_product](https://github.com/AndreyVolkovBI/SQL_Projects/blob/master/ManagementStudio/tables/specification_of_product.png)

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

Why Yandex Market refused shopping cart: https://yandex.ru/support/partnermarket/purchase/about.html

Card Product: https://yandex.ru/support/partnermarket/about/product-profile.html

Product Reviews: https://yandex.ru/support/market/opinions/opinion.html

Delivery for online stores: https://delivery.yandex.ru/promo/

Delivery method: https://yandex.ru/support/partnermarket/settings/delivery.html

Market for stores: https://yandex.ru/support/partnermarket/

Price list: https://yandex.ru/support/partnermarket/export/recommendation.html

Promotion: https://yandex.ru/support/partnermarket/auction/high-positions.html

Rate Management (tariff plan): https://yandex.ru/support/partnermarket/auction/select-and-set.html
