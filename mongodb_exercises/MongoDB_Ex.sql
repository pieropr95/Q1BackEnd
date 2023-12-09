-- EX01

db.dump16.find({
  'contract.country': 'Spain',
  'Client.Surname.1': {$exists: true}
}).pretty()

-- EX02
  
db.dump16.find(
  {'Movies.Title': /[0-9].*/},
  {'Movies.Title': 1, _id: 0}
).pretty()

-- EX03

db.dump16.find(
  {'Movies.Details.Budget': {$gt: 10000000, $lt: 40000000},
  'Movies.Details.Gross': {$gt: 10000000, $lt: 40000000}},
  {'Movies': 
    {$elemMatch: {'Details.Budget': {$gt: 10000000, $lt: 40000000},
    'Details.Gross': {$gt: 10000000, $lt: 40000000}}},
  'Movies.Title': 1,
  'Movies.Details.Budget': 1,
  'Movies.Details.Gross': 1,
  _id: 0}
).pretty()

-- EX04

db.dump16.aggregate([
{$unwind: {path: "$Movies"}},
{$project: {_id:0, Title:'$Movies.Title', Year: {$substr:['$Client.Birth date',6,2]}}},
{$group: {_id:{Year:'$Year', Title:'$Title'}, Count: {$sum:1}}},
{$project: {_id:0, Year:'$_id.Year', Title:'$_id.Title', Count:'$Count'}},
{$sort: {'Count':-1}},
{$group: {_id:'$Year', Year:{$first:'$Year'}, Title:{$first:'$Title'}, Count:{$first:'$Count'}}},
{$sort: {'_id':1}},
]).pretty()

-- EX05

db.dump16.aggregate([
{$unwind: {path: "$Movies"}},
{$project: {"_id":0, "Movies.Title":1, "Movies.Viewing PCT": 1}},
{$match:{ "Movies.Viewing PCT": {$gt:5, $lt:50}}},
{$group: {_id: "$Movies.Title", "Count": {$sum:1}} },
{$sort: {"Count":-1} },
{$limit: 10}
]).pretty()

-- EX06

db.dump16.aggregate([
{$unwind: {path: "$Movies"}},
{$project: {"_id":0,
"Country":"$Movies.Details.Country",
"Budget":{ $ifNull: [ "$Movies.Details.Budget", 0] },
"Gross":{ $ifNull: [ "$Movies.Details.Gross", 0] },
"Benefit": {$subtract: [{ $ifNull: [ "$Movies.Details.Gross", 0] }, { $ifNull: [ "$Movies.Details.Budget", 0] }]}}},
{$group: {_id: "$Country",
"Average_Budget": {$avg: "$Budget"},
"Average_Gross": {$avg: "$Gross"},
"Average_Benefit": {$avg: "$Benefit"}} } ,
{$sort: {'Average_Benefit':-1}}
]).pretty()

-- EX07

db.dump16.aggregate([
{$unwind: {path : '$Movies'}},
{$project: {'Movies.Title':1,
'Movies.Details.Budget':1,
'Movies.Details.Gross':1,
'_id':0}},
{$group: {'_id' : {'Title' : '$Movies.Title',
'Budget' : '$Movies.Details.Budget',
'Gross' : '$Movies.Details.Gross'},
'title': {$first :'$Movies.Title'},
'budget':{$first :'$Movies.Details.Budget'},
'gross':{$first :'$Movies.Details.Gross'}}},
{$facet : {'BudgetOrder' : [{$sort:{'budget' : -1}},
{$bucketAuto : {groupBy : '$budget', buckets : 10, output: {"titles": { $push: "$title" }}}},
{$group:{'_id':null, 'mostExpensiveMovies': { $last: "$$ROOT" }}}],
'GrossORder' : [{$sort: {'gross' : -1}},
{$bucketAuto : {groupBy : '$gross', buckets : 10, output: { "titles": { $push: "$title" }}}},
{$group:{'_id':null,'mostProductiveMovies': { $last: "$$ROOT" }}}]}}
]).pretty()
