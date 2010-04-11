newdb.db	SQLite Database
categorise.pl	Sort the items already in the DB (by regex + manually)
insert.pl	Insert the items into the DB
list.pl		List all the items in the DB
summary.pl	Show an overall summary (Totals in each label + unlabelled count)

Setup:
	1. Copy newdb.db to banker.db
	2. Download your bankstatement as CSV
	3. Edit insert.pl vars $cAmount, $cMatch etc to match your CSV
	4. Run insert.pl <filename>.csv to put it all in the DB
	5. Run categorise.pl
