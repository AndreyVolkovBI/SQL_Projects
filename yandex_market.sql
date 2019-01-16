-- Procedures
1. add_store_to_product(@storeId int, @productId int)  -- adds store to product card by ids
2. add_review_to_product(@reviewId int, @productId int, @userId int)  -- adds review to a specific product
3. add_new_user(@full_name nvarchar(50), @email nvarchar(100), @password nvarchar(100))  -- adds new user
4. add_product_to_cart(@productId int, @cartId int)  -- adds product to cart by product and cart ids

-- Functions
1. get_orders_by_user_id(@userId int)  -- returns all orders from particular user
2. get_ads_by_store_id(@storeId int)  -- returns all ads of particular store

-- Triggers
1. add_new_user_password_validation  -- checks password validation
2. add_reminder_for_shipping  -- adds reminder when shipping is submitted


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