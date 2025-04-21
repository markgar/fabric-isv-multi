# Fabric ISV Workload Example

## Multitenancy
Many of the applications we come across were applications written years ago and at that time, sold as on prem software.  As the internet became a more viable place to sell software as a service, companies began modifying their software.  Many companies just took the software and hosted it in virtual machines retaining the application architecture intact.  But others, seeking higher density, chose to modify the application to host multiple customers.  To keep the data from these customers separat, they added a new column to most if not all tables.  They added a TenantID column or something equivalent with a different name.  This brings us to the two multi-tenant archtectures that we come across.

The first is the hosted model.  We usually see this as one database per customer.  Each database is an almost exact copy of all the others.  Customers simplify the transition to a multi-tenant architecture, but they complicate the deployment and ALM of the application.  Keeping 50,000 databases on the same version is not easy.

The other is to have one or just a few database that host all the customers.  Some have the TenantID on every table, some do not.  When it is not on every table, the ETL must eventually account for this an join to a table that does have the TenantID so that the records in that table can be differentiated by customer.

## AdventureworksLTMulti
This database is a copy of the AdventureWorksLT database, but with one modification.  It has a new column added to the tables: TenantID.  This allows us to use this column to differentiate between the different tenants.  We'll use this column to split the data out by customer into different workspaces.  This keeps the data for each customer separate in different workspaces without having to add RLS.  In our example, I'd like for us to try at build out this example for at least 100 tenants.  Obviously it won't be possible to build this by hand, but we'll build the automation together to makes it easy to onboard a new tenant in Fabric.

## Medallion Architecture
Let's use a Medallion Architecture.  Medallion architecture is just a strategy - a framework.  The way that it is described in books and in Microsoft's documentation is not the *only* way it can be implemented.  It can be changed and molded to fit the current needs of the current project.  So while we'll build this a certain way, don't assume that this is the only way it can be implemented.

In Fabric there are some choices that need to be made for the implementation.  ETL can be done by Pipelines, Notebooks, Spark Job Definitions, and Warehouse Stored Procedures - and maybe even more.  I won't be suggesting any particular strategy.  Choose one and go with it.  Maybe you'll decide to come back and try a different implementation.  The more you try, the more you'll know how to compare and contrast them.

### Bronze
We'll use Bronze as the landing place for the data just after SQL.  At first we're going to do full loads from SQL.  But eventually we'll modify the architecture to accomodate incremental loads.  We'll land the data from SQL, either a full load or an incremental load in the Bronze layer.  So in this layer, let's just use parquet files because the Bronze layer doesn't need to be queried, so no need for delta tables or V-order, for that matter.

### Silver
Silver is the first place where we'll do the processing to get the incrementals integrated.  At first we'll just do full loads, so that means that Silver won't look very different from Bronze.  But that's ok.  Eventually it will be the only place where we have all the data integrated together - the full load and all the subsequent incremental loads.

Silver will also be the first place where we separate out by TenantID, sharding the data for each tenant.

### Gold
The Gold Layer is where we will build a dimensional model.  For this exercise, we'll keep the dimensional model very simple.  This exercise is not a dimensional model exercise, but more about everything in between.  So I'll be asking for simple table design in the Gold layer.

## Iterate
We're going to iterate many times across the medallion architecture we're going to build here.  This will mean we can check our progress many times along the way.  It also means we can begin testing our solution right away.  We can build automated tests the ensure that we're getting valid results.  For instance, we could build tests that ensure that we have the same row counts in Silver that we do in Bronze.  This seems like a simple test, but the accumulation of these kinds of tests can ensure that regression does not happen during the development cycle.

# Section One - ETL Scale
## Iteration One - One Table
The goal here is to make it all the way through the medallion architecture as quickly as possible.  Set up all the different layers with an small iteration.  Let's take the ```SalesOrderHeader``` table.  For the first iteration, let's load the entire table all the way through.  This is going to be our Fact table with all the transactions in it.  We'll load some dimensions a little later.

The other consideration for this iteration is that we will only have one tenant to load.  The database comes with 2 tenants so we'll need to add a predicate when we pull the data to only include ```TenantID=1```.  That way we won't have to worry about for the rest of the ETL we build in this iteration.

This will mean loading a full load of the ```SalesOrderHeader``` from the SQL Server and landing that in the Bronze layer as parquet, no v-order.  Then this parquet file should be loaded into the Silver layer, just as is.  Remember that for us, the Silver layer is used for integrating the incementals, but for now, since we are only doing full loads, we don't have to worry aobut that.  So when you load Silver, you can just remove any data from that last load, and replace it with the full load that was just pulled from SQL.

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

Silver and Gold will need to change more.  We know we want Gold for each customer to be separate, but let's assume that one of our requirements is that eventually, querying of each tenant's data separately in Silver.  So this might mean that you need to rename or move your Silver and Gold layers.  You could move each set of Silver and Gold into a new workspace - one Workspace for each Tenant, or you could just rename them in place in the current workspace.  Remember, ISVs can have hundreds if not thousands of Tenants, so we'll try and build a hundred or so to take this into account as you adjust this part of the architecture.  Our current guidance for PowerBI is for customers that are building customer facing PowerBI applications is to put one tenant in one workspace.  This strategy has worked well over the last few years, so consider this when making your decision on how to proceede.

Since we're trying to move in small iterations, just build the Silver and Gold for these two tenants by hand.  If we are going to have hundreds of tenants eventually, we'll need to build automation to do this, but for now, let's save that for later and just focus on the architecture we choose to house the data and the ETL to move the data from Bronze through Silver to Gold.

Now that we have locations to land each tenant in Silver and Gold, go ahead and modify the ETL processes to filter the data from Bronze and move it to the tenants Silver.  Then modify the process that moves data from Silver to Gold to move the correct data to the correct Gold layer.

**Completion Criteria**

Bronze will look pretty similar - a full extract of the ```SalesOrderHeader``` from the source SQL database - although this time with both ```TenantID=1``` AND ```TenantID=2```.

Silver and Gold will now have multiplied - one set for each tenant.

Our ETL process now needs to run to extract TenantID=1 and move that to the Silver for TenantID=1 and the same for TenantID=2.  This should still be a 'dump and reload' process. Just remove all the data from the existing table in Silver and Gold and reload the entire table.

Remember, we need for this to run out of one single initiation action.  It needs to be unified into one single process that can be run with one action.  One manual run or one scheduled item.

Also, use the tool of your choice to draw an architecture diagram showing how the the whole flow works.

## Iteration Four - Basic Automation
In this iteration, we're going to add one more tenant, but we're going to do it using automation.  We're going to create a process where we can add an additional tenant by running one script, or one job.  Doesn't really matter how you handle it, but it needs to be easy to run.  Some options here might be using the Fabric CLI, calling the Fabric REST API, using Azure Devops Pipelines or GitHub Actinos, or a combination of more than one.

Let me suggest that you start by using the Fabric CLI.  This will require having Python installed on your machine.  You can use [this](https://code.visualstudio.com/docs/python/python-tutorial) documentation to get python working with VSCode.

You'll need to create any artifacts required to run your process.  If you need another workspace, create that too as a part of this process.  

If you're having to update your code due to adding another tenant, try and factor that out.  Make it so that this script can create the resources for a new tenant and then update some sort of metadata repository about your tenants so that your code can dynamically run on how ever many tenants are present.  Running this script should be all you need to add a tenant.

**Completion Criteria**
You'll need a script or a process that can be run in one step that adds everything needed to load another tenant.  After this process runs, you should be able to immediatly run your ETL and it run for all tenants.

There should be 3 tenants at the end of this iteration.

It's ok if the script or process or whatever you created still needs to be run by hand.  The important part is that it can be done in one step.

## Iteration Five - Adding More Tables to Silver
Now that we are working with more than one tenant, it will be more and more important to be very clever with our code so that the more tables we add and the more tenants we add, it shouldn't require additional code.  It's ok to require some additional configuration - something new in the metadata repository we talked about in the last iteration, but becuase Bronze and Silver are schematic copies of each other, having to add additional code is a sign we're not being efficient with our code.  Also, we might eventually have hundreds of tables to load from Bronze to Silver and having one piece of code to keep up that is driven by configuration to load hundreds of tables saves us a lot of code to write and test.

**Completion Criteria**

All the Bronze tables Loaded into Silver.  We're still just using a dump-and-reload strategy for now so that we don't get too bogged down in the incremental process buildout - which of course may not ever need to be built if we can dump-and-reload under the SLA that is provided by the business.  No need to build it if we don't have to and we need to build the initialization process anyways, so this isn't wasted work.

## Iteration Seven - Silver ETL at scale
Now at this point we have 1 shared Bronze, which is shared by all tenants.  And we have 3 tenant currently in our ISV solution.  Our customers often have 1000 tenants and this brings a whole new challenge to ETL scale.  If we have ~100 tables in our SQL Server, that means we have ~100 in Silver.  In many enterprises, daily load is acceptable, but in an ISV application, this will need to be sped up significantly.  Let's assume this is going to need to be updated every hour.  This means loading all ~100 tables each hour, but for each tenant.  And if we have 1000 tenants, this means we'll need to refresh 100*1000 tables each hour!  That's a total of 100,000 tables!  That's a lot - and that's just for Silver.  We'll need to refresh Gold also afterword.

This is where some of the decisions we've made are going to really affect the outcomes.  If we chose Spark Notebooks and Pipelines, we'll need to figure out how to optimize to get 100,000 tables reloaded.  One thing we haven't talked about yet is incrementatl loads.  This will allow you to have smaller loads each hour, but it won't change how many tables need to be loaded.  So if your process has much overhead to process each table, then the whole process can end up taking a really long time.  We'll also want to maximize the parallelization so that we can complete as many tables at a time as possible.  Also the efficiency of your code is critical as any extra time wasted loading a table can really multiply out to a long time.

In this iteration, we need to begin measuring how fast we can complete the complete refresh.  For this exercise, we'll just focus on Bronze to Silver and we'll try to get the tenant count up into the hundreds of tenants.  If youre feeling ambitious, try and get it up to 1,000.

So the first task is to automate the ETL of Bronze to Silver so that it can be run all at the same time.  Try it with just 3 tenants.  You can try just looping through each tenant one after the other and then try and figure out a way to run them in parallel.  Compare the two times.  Keep track of these as we'll want to compare how fast we can do 3, 30, 300, and 1000

# Section Two - Code Deployment and CICD at Scale
## Iteration One - Enabling GitFlow an Bronze
You might be anxious to get more tables loaded and you can do this next if you want to.  If that's the case, skip to the next Iteration.  But if you're up for the challenge, in this iteration we'll be working on setting up the CICD pipelines and automation to deploy our code from dev to prod.  We'll just have two environments in this exercise so keep us moving, but most medallion architectures will have more that just two.

The first thing we'll need to do is associate our workspaces with a Git repository.  This can be either GitHub or Azure Devops.  Either one works.  Azure Devops might be a little easier becuase you don't need to deal with PATs and you just use your EntraID to authenticate.  But use whatever is easier to get your hands on.  The deployment pipeline technology is almost identical so even those won't differ much between the two.

Ok - I'm going to make an assumption that you have a workspace for your Bronze layer and one workspace for your Silver and Gold.  If you have separated Silver and Gold, that's totally fine.  You'll just end up with more workspaces when we are done.  Remember we're trying to go to at least 100 tenants so it might be easier to put Silver and Gold in the same workspace.  But this there really are multiple ways to make this work.

Now that you have Bronze under source control, you can start committing your code to the Git repository.  This is already an improvement over not having Git backed workspaces, but to take it to the next level, we need to enable developers to work at the same time without bumping into each other.  If a developer is changing a semantic model and renaming a column, and another developer is modifying a report that relies on that semantic model, then we need for these two developers to work on their own copy of the source code so that the developer working on modifying the report can complete this task without being interrupted or broken by the change in the semantic model.

This is done by using branches.  A branch is just a copy of the current source code in the reposoitory.  Developers can make changes on the new branch and then later merge it back into the main branch of the repository.  Fabric has capabilities to make this work and it is called Branch Out. This will create a new workspace and a new branch and bind them together.  These kinds of branches are commonly called 'feature branches'.  Developers work in that workspace and feature branch until they are done - at which point, the developer commits the final version of their code to the feature branch.  At that point, the developer creates a Pull Request in the Git reposotry - GitHub or Azure Devops - and this is the process by which the changes in the new branch are merged into the main branch - the main branch always holding the sum total of everything that has been merged back in.  This is the end of the road for the workspace and the feature branch that were created.  We can delete them both now.  You can delete the workspace in Fabric, but you'll have to go to your Git repo tool to delete the feature branch.

The last thing we need to do is create a branch policy.  There are multiple ways to create a policy that will achieve this, but this policy will force developers to develop on a branch and use a pull request to merge into main.  Developers will not be allowed to commit code to main directly.  This enforces the dicipline of using feature branches.

**Completion Criteria**

Bronze workspace will be bound to the main branch of a Git repository.  There will be a branch policy on main that forbits direct commits to main and merge will only be allowe by a pull request.

I'll give you a hint on how to set up your branch policy.  Go to the main branch and force approvals for merge on main.  The only way to do approvals is through a pull request.

## Iteration Two - Enable deploying to Prod for Bronze
You might notice that you don't really have a dev environmgnt *and* a prod environment.  You have essentially a prod workspace where you can branch out, do work, and then merge.  And this merge puts that code into production.  Without any chance to test prior.  This may actually work in some scenarios, but when working in an ISV environment, this risk is probably not tolerable.

So, how do we add a production environment?  We'll need a new workspace and we'll need to deploy our code from the dev Bronze workspace to the prod Bronze workspace.  There is more than one way to move the code from dev to prod.  One would be to add another permanent branch in the repo and bind that to prod and use Git to merge code from what would be the dev branch to the prod branch.  Once code is merged to the branch bound to prod, you'd then to a git sync in the prod workspace and this would bring the code from git repo into the prod workspace.  This a valid strategy for Bronze.  This strategy won't work when we get to Silver and Gold when we have hundreds of workspaces to deploy to, but for Bronze, it could work.

If this is the way you want to go, you'll need to add another long lived branch in your repo.  Let's say you leave main for your development and you add one called 'prod' for binding to your prod workspace.  You won't want to allow anyone to commit to this new 'prod' branch, not even from a feature branch.

If you'd rather solve this problem with something other than Git, read on.  The other way is to deploy from dev to prod using automation - meaning the Fabric API.  The Fabric API has everything we need to create, update, and delete items in a workspace.  Luckily we don't have to use the REST API, we can use the Fabric CLI, which makes the process of writing these scripts much easier.  If you want to use the REST API instead, that's totally fine.  Go for it.  But I think you'll save time using the CLI.

The idea here would be to run some scripting on Azure Devops or GitHub using Pipelines or Actions that when the pipeline runs, (I'm just going to use the generic, pipeline from now on) it takes the code that is ready to go to prod and deploys it directly from Git to the workspace.  If you've never looked at the Git repo behind a workspace, go ahead and take a look.  Each Fabric item is in a folder with its name and item type.  This will make it easy for us to identify what's what so that we can deploy everything correctly.

When our pipeline runs on worker in GitHub or Azure Devops, we need to get a copy of the code so we can deploye it.  On Azure Devops, this is already done for you, but on GitHub Actions, it is not.  So if your running in GitHub, you'll need to do what's called a checkout.

Now imagine yourself running a terminal session and in that terminal session, the code is now sitting in a directory right where the terminal is open.  You'd be able to write scripts that change directory into the Git reposotory and and do stuff with the code.  For us, we're going to want to go to the directories we need to and use the Fabric CLI to deploy the code.  The CLI already knows how to read the files, you just have to tell it where the files are and which workspace you want to put them in.

There is a question of order of operations here.  You might need to deploy a Fabric notebook before a Fabric pipeline because it references it.  Let's not worry too much about trying to detect these by inspecting the code in the Git repository.  You'll know in which order to deploy everything.  So when you write this script, just hard code the order.  The other issue we have is that a Fabric pipeline references a notebook, it does it by GUID.  But the GUIDs in the repo will be for the notebook in the development workspace.  But we want this deployment to have the production Fabric pipeline point to the production Fabric notebook, not the notebook in the dev workspace.  So you'll have to account for that too by ensuring the Fabric pipeline references the correct notebook.

By the way - while you can use the multiple branch method to get code from dev to prod in both your Bronze and the Silver and Gold workspaces, that strategy won't work for deploying from the Silver and Gold workspace to the hundred workspaces that are tenant facing.  You'll need to use this scripted CLI deployments strategy.  Also, if you end up with more environments than dev and prod, it might mean that using this second method makes more sense.  But all that really matters is that we get control of the CICD process in a way that reduces risk by controlling deploymens and increases quality by allowing for automated testing. Also, remember that the goal of this exercise is to understand better the tooling and options within Fabric to solve these problems.  This isn't meant as a best practices guide.  There really are no 'best pratices', just good practices.  Using your judgement to decide, is the art of this science.

## Iteration Three
 - CICD on Silver and Gold
This is going to be more tricky.  We know we are going to eventually have hundreds of tenant facing workspaces for Silver and Gold so we can't create a Git repository for each one.  We also know that we still need dev to prod depolyments for Silver and Gold.  And we also know that we're going to need to deploy this prod workspace out to at least 100 tenant facing workspaces.  We can't really manage hundreds of Git repositories, so we'll just be deploying the code out to these hundred workspaces using some scripting and automation without binding them to a Git repo.

So know that we have an idea how to build this, go ahead and build the same thing for Silver and Gold that you build for Bronze.  We're going to need the exact same thing.  a dev