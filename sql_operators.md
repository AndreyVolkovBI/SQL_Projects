### Sql Operators

## Join

t1
| k1 | d1 |
------------- | -------------
1|1 1|10
2|2 2|20
3|3 5|50
4|4 6|60
Неправильно (Cross Join):

При таком 
```sql
select ... 
from t1, t2, t3, t4
where t1.key = t2.key
and t2.key = t3.key
```