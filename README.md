# Fabric ISV Workload Example

## Multitenancy
Many of the applications we come across in SDP are applications written years ago and at that time, sold as on prem software.  As the internet became a more viable place to sell software as a service, companies began modifying their software.  Many companies just took the software and hosted it in virtual machines retaining the application architecture intact.  But others, seeking higher density, chose to modify the application to host multiple customers.  To keep the data from these customers separat, they added a new column to most if not all tables.  They added a TenantID column or something equivalent with a different name.  This brings us to the two multi-tenant archtectures that we come across.

The first is the hosted model.  We usually see this as one database per customer.  Each database is an almost exact copy of all the others.  Customers simplify the transition to a multi-tenant architecture, but they complicate the deployment and ALM of the application.  Keeping 50,000 databases on the same version is not easy.

The other is to have one or just a few database that host all the customers.  Some have the TenantID on every table, some do not.  When it is not on every table, the ETL must eventually account for this an join to a table that does have the TenantID so that the records in that table can be differentiated by customer.

## AdventureworksLTMulti
This database is a copy of the AdventureWorksLT database, but with one modification.  It has a new column added to the tables, TenantID.  This allows us to use this column to differentiate between the different tenants.  We'll use this column to split the data out by customer into different workspaces.  This keeps the data for each customer separate in different workspaces without having to add RLS.

## Medallion Architecture
Let's use a Medallion Architecture.  Medallion architecture is just a strategy.  It is not the only way.  It can be used and molded to fit the current needs.  So while we'll build this a certain way, don't assume that this is the only way to build this.

### Bronze
We'll use Bronze as the landing place for the data just after SQL.  At first we're going to do full loads from SQL.  But eventually we'll modify the architecture to accomodate incremental loads.  We'll land the data from SQL, either a full load or an incremental load in the Bronze layer.  So in this layer, let's just use parquet files because the Bronze layer doesn't need to be queried, so no need for delta tables or V-order, for that matter.

### Silver
Silver is the first place where we'll do the processing to get the incrementals integrated.  At first we'll just do full loads, so that means that Silver won't look very different from Bronze.  But that's ok.  Eventually it will be the only place where we have all the data integrated together - the full load and all the subsequent incremental loads.

### Gold
The Gold Layer is where we will build a dimensional model.  For this exercise, we'll keep the dimensional model very simple.  This exercise is not a dimensional model exercise, but more about everything in between.  So I'll be asking for simple table design in the Gold layer.

## Iterate
We're going to iterate many times across the medallion architecture we're going to build here.  This will mean we can check our progress many times along the way.  It also means we can begin testing our solution right away.  We can build automated tests the ensure that we're getting valid results.  FOr instance, we could build tests that ensure that we have the same row counts in Silver that we do in Bronze.  This seems like a simple test, but the accumulation of these kinds of tests can ensure that regression does not happen during the development cycle.

## Iteration One - One Table
The goal here is to make it all the way through the medallion architecture as quicly as possible.  Set up all the different layers with an small iteration.  Let's take the ```SalesOrderHeader``` table.  For the first iteration, let's load the entire table all the way through.  This is going to be our Fact table with all the transactions in it.  We'll load some dimensions a little later.

The other consideration for this iteration is that we will only have one tenant to load.  The database only has one tenant to start and we'll use a script to 'add' more tenants later.  But for now, it only has one, so we don't need to worry about that.

This will mean loading a full load of the ```SalesOrderHeader``` from the SQL Server and landing that in the Bronze layer as parquet, no v-order.  Then this parquet file should be loaded into the silver layer, just as is.  Remember that for us, the Silver layer is used for integrating the incementals, but for now, since we are only doing full loads, we don't have to worry aobut that.  So when you load silver, you can just remove any data from that last load, and replace it with the full load that was just pulled from SQL.

Now that the Silver layer is loaded, let's load the Gold layer.  For our simple use case, let's only load 3 columns.
```
SalesOrderID
TotalDue
CustomerID
```

This already allows us to begin to make some interesting queries both by Sales Order as a whole as by Customer.  We could add more columns and build more dimensions, but for now, we'll keep it super simple so we get a complete working system from source to target in a very short amount of time.  We will be able to continue the interations and add more each iteration.