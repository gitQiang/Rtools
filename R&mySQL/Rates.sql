USE mathes_version3
#同比增长2012-2013
select a.months as Months, 
b.incomeMonth2012 as Income2012, a.incomeMonth2013 as Income2013, 
(a.incomeMonth2013/b.incomeMonth2012-1)*100 as IncomeRate2012_2013,
LN((a.incomeMonth2013/b.incomeMonth2012-1)*100) as IncomeLogRate2012_2013,
b.expenseMonth2012 as Expense2012, a.expenseMonth2013 as Expense2013,
(a.expenseMonth2013/b.expenseMonth2012-1)*100 as ExpenseRate2012_2013,
LN((a.expenseMonth2013/b.expenseMonth2012-1)*100) as ExpenseLogRate2012_2013
from
( 
select date_format(tradingDate,'%m') as months,sum(income) as incomeMonth2013, sum(expense) as expenseMonth2013 from test_bankaccount where date_format(tradingDate,'%Y') = '2013' group by date_format(tradingDate, '%Y-%m')
) a
,
(
select date_format(tradingDate, '%m') as months, sum(income) as incomeMonth2012, sum(expense) as expenseMonth2012 from test_bankaccount where date_format(tradingDate,'%Y') = '2012' group by date_format(tradingDate, '%Y-%m')
) b
where a.months = b.months;


# 同比增长2013-2014
select a.months as Months, 
b.incomeMonth2013 as Income2013, a.incomeMonth2014 as Income2014, 
(a.incomeMonth2014/b.incomeMonth2013-1)*100 as IncomeRate2013_2014,
LN((a.incomeMonth2014/b.incomeMonth2013-1)*100) as IncomeLogRate2013_2014,
b.expenseMonth2013 as Expense2013, a.expenseMonth2014 as Expense2014,
(a.expenseMonth2014/b.expenseMonth2013-1)*100 as ExpenseRate2013_2014,
LN((a.expenseMonth2014/b.expenseMonth2013-1)*100) as ExpenseLogRate2013_2014
from
( 
select date_format(tradingDate,'%m') as months, sum(income) as incomeMonth2014, sum(expense) as expenseMonth2014 from test_bankaccount where date_format(tradingDate,'%Y') = '2014' group by date_format(tradingDate, '%Y-%m')
) a
,
(
select date_format(tradingDate, '%m') as months, sum(income) as incomeMonth2013, sum(expense) as expenseMonth2013 from test_bankaccount where date_format(tradingDate,'%Y') = '2013' group by date_format(tradingDate, '%Y-%m')
) b
where a.months = b.months;


# 环比增长 2012
select concat_ws('-',b.months+0,a.months+1) as Month, 
a.incomeMonth2012 as IncomeNow, b.incomeMonth2012 as IncomeLast,
(a.incomeMonth2012/b.incomeMonth2012-1)*100 as IncomeRate2012_2012,
LN((a.incomeMonth2012/b.incomeMonth2012-1)*100) as IncomeLogRate2012_2012,
a.expenseMonth2012 as ExpenseNow, b.expenseMonth2012 as ExpenseLast,
(a.expenseMonth2012/b.expenseMonth2012-1)*100 as ExpenseRate2012_2012,
LN((a.expenseMonth2012/b.expenseMonth2012-1)*100) as ExpenseLogRate2012_2012
from
( 
select FLOOR(date_format(tradingDate,'%m'))-1 as months, sum(income) as incomeMonth2012, sum(expense) as expenseMonth2012 from test_bankaccount where date_format(tradingDate,'%Y') = '2012' group by date_format(tradingDate, '%Y-%m')
) a
,
(
select date_format(tradingDate, '%m') as months, sum(income) as incomeMonth2012, sum(expense) as expenseMonth2012 from test_bankaccount where date_format(tradingDate,'%Y') = '2012' group by date_format(tradingDate, '%Y-%m')
) b
where a.months = b.months;

# 环比增长 2013
select concat_ws('-',b.months+0,a.months+1) as Month, 
a.incomeMonth2013 as IncomeNow, b.incomeMonth2013 as IncomeLast,
(a.incomeMonth2013/b.incomeMonth2013-1)*100 as IncomeRate2013_2013,
LN((a.incomeMonth2013/b.incomeMonth2013-1)*100) as IncomeLogRate2013_2013,
a.expenseMonth2013 as ExpenseNow, b.expenseMonth2013 as ExpenseLast,
(a.expenseMonth2013/b.expenseMonth2013-1)*100 as ExpenseRate2013_2013,
LN((a.expenseMonth2013/b.expenseMonth2013-1)*100) as ExpenseLogRate2013_2013
from
( 
select FLOOR(date_format(tradingDate,'%m'))-1 as months, sum(income) as incomeMonth2013, sum(expense) as expenseMonth2013 from test_bankaccount where date_format(tradingDate,'%Y') = '2013' group by date_format(tradingDate, '%Y-%m')
) a
,
(
select date_format(tradingDate, '%m') as months, sum(income) as incomeMonth2013, sum(expense) as expenseMonth2013 from test_bankaccount where date_format(tradingDate,'%Y') = '2013' group by date_format(tradingDate, '%Y-%m')
) b
where a.months = b.months;

# 环比增长 2014
select concat_ws('-',b.months+0,a.months+1) as Month, 
a.incomeMonth2014 as IncomeNow, b.incomeMonth2014 as IncomeLast,
(a.incomeMonth2014/b.incomeMonth2014-1)*100 as IncomeRate2014_2014,
LN((a.incomeMonth2014/b.incomeMonth2014-1)*100) as IncomeLogRate2014_2014,
a.expenseMonth2014 as ExpenseNow, b.expenseMonth2014 as ExpenseLast,
(a.expenseMonth2014/b.expenseMonth2014-1)*100 as ExpenseRate2014_2014,
LN((a.expenseMonth2014/b.expenseMonth2014-1)*100) as ExpenseLogRate2014_2014
from
( 
select FLOOR(date_format(tradingDate,'%m'))-1 as months, sum(income) as incomeMonth2014, sum(expense) as expenseMonth2014 from test_bankaccount where date_format(tradingDate,'%Y') = '2014' group by date_format(tradingDate, '%Y-%m')
) a
,
(
select date_format(tradingDate, '%m') as months, sum(income) as incomeMonth2014, sum(expense) as expenseMonth2014 from test_bankaccount where date_format(tradingDate,'%Y') = '2014' group by date_format(tradingDate, '%Y-%m')
) b
where a.months = b.months;
