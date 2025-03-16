# Fabric ISV Workload Example

## Multitenancy
Many of the applications we come across in SDP
There are two fundamental ways of storing data when you are running a SaaS service and have many customers.  One is to store any one tenant in their own database.  The other is to use one database for multiple tenants and use a column to differentiate across the tables.  

## AdventureworksLTMulti
This database is a copy of the AdventureWorksLT database, but with one modification.  It has a new column added to the tables, TenantID

## Medallion Architecgure
Let's use a Medallion Architecture.  Medallion architecture is just a strategy.  It is not the only way.  It can be used and molded to fit the current needs.  So while we'll build this a certain way, don't assume that this is the only way to build this.  

### Bronze
We'll use Bronze as the landing place for the data just after SQL.  At first we're going to do full loads from SQL.  But eventually we'll modify the architecture to accomodate incremental loads.  We'll land the data from SQL, either a full load or an incremental load in the Bronze layer.  So in this layer, let's just use parquet files.

### Silver
Silver is the first place where we'll do the processing to get the incrementals integrated.  At first we'll just do full loads, so that means that Silver won't look very different from Bronze.  But that's ok.  Eventually it will be the only place where we have all the data integrated together - the full load and all the subsequent incremental loads.

### Gold
The Gold Layer is where we will build a dimensional model.  For this exercise, we'll keep the dimensional model very simple.  This exercise is not a dimensional model exercise, but more about everything in between.  So I'll be asking for simple tables in the Gold layer.

## Iterate
We're going to iterate many times across the medallion architecture we're going to build here.  This will mean we can check our progress many times along the way.  It also means we can begin testing our solution right away.  We can build automated tests the ensure that we're getting valid results 

## Iteration One - One Table
The goal here is to make it all the way through the medallion architecture as quicly as possible.  Set up all the different layers with an small iteration.  Let's take the ```Header``` table.  For the first iteration, let's load the entire table all the way through.
