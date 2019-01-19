### Sql Operators

## Таблицы

`t1`

| k1 | d1 |
------------- | -------------
1|1
2|2
3|3
4|4

`t2`

| k2 | d2 |
------------- | -------------
1|10
2|20
5|50
6|60


## Неправильный (Cross Join):

При таком запросе будут дублироваться все значения
```sql
select ... 
from t1, t2, t3, t4
where t1.key = t2.key
and t2.key = t3.key
```
| d1 | d2 |
------------- | -------------
1|10
1|20
1|50
1|60
2|10
2|20
...|...

## Inner Join
```sql
select d1, d2
from t1 inner join t2 on t1.k1 = t2.k2
```
| d1 | d2 |
------------- | -------------
1|10
2|20

## Left Join
```sql
select d1, d2
from t1 left join t2 on t1.k1 = t2.k2
```
| d1 | d2 |
------------- | -------------
1|10
2|20
3|Null
4|Null

## Right Join
```sql
select d1, d2
from t1 right join t2 on t1.k1 = t2.k2
```
| d1 | d2 |
------------- | -------------
1|10
2|20
Null|50
Null|60

## Full Join
```sql
select d1, d2
from t1 full join t2 on t1.k1 = t2.k2
```
| d1 | d2 |
------------- | -------------
1|10
2|20
3|Null
4|Null
Null|50
Null|60

## Union
```sql
select d1, d2
from t1 left join t2 on t1.k1 = t2.k2
union all
select d1, d2
from t1 right join t2 on t1.k1 = t2.k2
where t1 is Null
```

