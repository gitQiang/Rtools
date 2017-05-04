::1．用MySQL求出：收入与支出的月合计、季度合计、年合计；以及余额的月均余额。

:: 收入的月合计、季度合计、年合计
mysql -h255.1.1.1 -uusers -ppassword -e"select date_format(tradingDate, '%Y-%m') as Month, sum(income) as incomeMonth from test_bankaccount group by date_format(tradingDate, '%Y-%m');" mathes_version3 > D:/code/exercise/IncomeMonth.txt

mysql -h255.1.1.1 -uusers -ppassword -e"select concat_ws('-',date_format(tradingDate, '%Y'),FLOOR((date_format(tradingDate, '%m')+2)/3)) as Season, sum(income) as incomeSeason from test_bankaccount group by concat(date_format(tradingDate, '%Y'),FLOOR((date_format(tradingDate, '%m')+2)/3));" mathes_version3 > D:/code/exercise/IncomeSeason.txt

mysql -h255.1.1.1 -uusers -ppassword -e"select date_format(tradingDate, '%Y') as Year, sum(income) as incomeYear from test_bankaccount group by date_format(tradingDate, '%Y');" mathes_version3 > D:/code/exercise/IncomeYear.txt

:: 支出的月合计、季度合计、年合计
mysql -h255.1.1.1 -uusers -ppassword -e"select date_format(tradingDate, '%Y-%m') as Month, sum(expense) as expenseMonth from test_bankaccount group by date_format(tradingDate, '%Y-%m');" mathes_version3 > D:/code/exercise/expenseMonth.txt

mysql -h255.1.1.1 -uusers -ppassword -e"select concat_ws('-',date_format(tradingDate, '%Y'),FLOOR((date_format(tradingDate, '%m')+2)/3)) as Season, sum(expense) as expenseSeason from test_bankaccount group by concat(date_format(tradingDate, '%Y'),FLOOR((date_format(tradingDate, '%m')+2)/3));" mathes_version3 > D:/code/exercise/expenseSeason.txt

mysql -h255.1.1.1 -uusers -ppassword -e"select date_format(tradingDate, '%Y') as Year, sum(expense) as expenseYear from test_bankaccount group by date_format(tradingDate, '%Y');" mathes_version3 > D:/code/exercise/expenseYear.txt

:: 余额的月均余额
mysql -h255.1.1.1 -uusers -ppassword -e"select date_format(tradingDate, '%Y-%m') as Month, avg(balance) as balanceMonth from test_bankaccount group by date_format(tradingDate, '%Y-%m');" mathes_version3 > D:/code/exercise/balanceMonth.txt

:: 2. 利用收入与支出的月合计数用MySQL求出计算出其普通同比、环比月增长率，以及对数同比、环比月增长率。

::同比增长和环比增长
:: 2012 - 2013, 2013 - 2014
mysql -h255.1.1.1 -uusers -ppassword -e"source D:/code/exercise/Rates.sql" > D:/code/exercise/Rates.txt



