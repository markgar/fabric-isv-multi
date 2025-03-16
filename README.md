# Fabric ISV Workload Example

## Multitenancy
Many of the applications we come across in SDP are applications written years ago and at that time, sold as on prem software.  As the internet became a more viable place to sell software as a service, companies began modifying their software.  Many companies just took the software and hosted it in virtual machines retaining the application architecture intact.  But others, seeking higher density, chose to modify the application to host multiple customers.  To keep the data from these customers separat, they added a new column to most if not all tables.  They added a TenantID column or something equivalent with a different name.  This brings us to the two multi-tenant archtectures that we come across.

The first is the hosted model.  We usually see this as one database per customer.  Each database is an almost exact copy of all the others.  Customers simplify the transition to a multi-tenant architecture, but they complicate the deployment and ALM of the application.  Keeping 50,000 databases on the same version is not easy.

The other is to have one or just a few database that host all the customers.  Some have the TenantID on every table, some do not.  When it is not on every table, the ETL must eventually account for this an join to a table that does have the TenantID so that the records in that table can be differentiated by customer.

## AdventureworksLTMulti
This database is a copy of the AdventureWorksLT database, but with one modification.  It has a new column added to the tables, TenantID.  This allows us to use this column to differentiate between the different tenants.  We'll use this column to split the data out by customer into different workspaces.  This keeps the data for each customer separate in different workspaces without having to add RLS.

## Medallion Architecture
Let's use a Medallion Architecture.  Medallion architecture is just a strategy - a framework.  The way that it is described in books and in Microsoft's documentation is not the only way.  It can be used and molded to fit the current needs of the current project.  So while we'll build this a certain way, don't assume that this is the only way to build this.

In Fabric there are some choices that need to be made for the implementation.  ETL can be done by Pipelines, Notebooks, Spark Job Definitions, and Warehouse Stored Procedures - and maybe even more.  I won't be suggesting any particular strategy.  Choose one and go with it.  Maybe you'll decide to come back and try a different implementation.  The more you try, the more you'll know how to compare and contrast them when someone asks.

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

The other consideration for this iteration is that we will only have one tenant to load.  The database comes with 2 tenants so we'll need to add a predicate when we pull the data to only include ```TenantID=1```.  Let's add this predicate when we load data out of SQL and into the Bronze layer.  That way we won't have to worry about for the rest of the ETL we build in this iteration.

This will mean loading a full load of the ```SalesOrderHeader``` from the SQL Server and landing that in the Bronze layer as parquet, no v-order.  Then this parquet file should be loaded into the silver layer, just as is.  Remember that for us, the Silver layer is used for integrating the incementals, but for now, since we are only doing full loads, we don't have to worry aobut that.  So when you load silver, you can just remove any data from that last load, and replace it with the full load that was just pulled from SQL.

Now that the Silver layer is loaded, let's load the Gold layer.  For our simple use case, let's only load 3 columns into a table called ```FactSalesHeader```
```
SalesOrderID
TotalDue
CustomerID
```

This already allows us to begin to make some interesting queries both by Sales Order as a whole as by Customer.  We could add more columns and build more dimensions, but for now, we'll keep it super simple so we get a complete working system from source to target in a very short amount of time.  We will be able to continue the interations and add more each iteration.

**Completion Criteria**

The ```SalesOrderHeader``` should be loaded for one tenant in its entirety into Bronze.  Then fully loaded into Silver.  Then only 3 columns loaded into Gold for the ```SalesOrderHeader```.  This process should be able to be executed one right after the other - after the user starting only one item - a Spark Job, a Notebook, a Pipeline or whatever.

## Iteration Two - Two Tenants
Let's take the work we've done with the ```SalesOrderHeader``` table and expand it to include loading multiple Tenants.  The database already has 2 tenants in it, so let's modify the Bronze extract to include both tenants.  This will only entail removing the predicate from the Bronze load.

Silver and Gold will need to change more.  We know we want Gold for each customer to be separate, but let's assume that one of our requirements is that eventually, querying of each tenant's data separately in Silver is a requirement.  So this might mean that you need to rename or move your Silver and Gold layers.  You could move each set of Silver and Gold into a new workspace - one Workspace for each Tenant, or you could just rename them in place in the current workspace.  Remember, ISVs can have hundreds if not thousands of Tenants, we'll try and build a hundred or so take this into account as you adjust this part of the architecture.  Our current guidance for PowerBI is for customers that a building customer facing PowerBI applications is to put one tenant in one workspace.  This strategy has worked well over the last few years, so consider this when making your decision on how to proceede.

Since we're trying to move in small iterations, just builld the Silver and Gold for these two tenants by hand.  If we are going to have hundreds of tenants eventually, we'll need to build automation to do this, but for now, let's save that for later and just focus on the architecture we choose to house the data and the ETL to move the data from Bronze through Silver to Gold.

Now that we have locations to land each tenant in Silver and Gold, go ahead and modify the ETL processes to filter the data from Bronze and move it to the tenants Silver.  Then modify the process that moves data from Silver to Gold to move the correct data to the correct Gold layer.

**Completion Criteria**

Bronze will look pretty similar - a full extract of the ```SalesOrderHeader``` from the source SQL database - although this time with both ```TenantID=1``` AND ```TenantID=2```.

Silver and Gold will now have multiplied - one set for each tenant.

Our ETL process now needs to run to extract TenantID=1 and move that to the Silver for TenantID=1 and the same for TenantID=2.  This should still be a 'dump and reload' process. Just remove all the data from the existing table in Silver and Gold and reload the entire table.