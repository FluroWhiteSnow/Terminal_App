<h1>Overview of my app - Recipe Book!</h1>

My application at its simplest form shall be a digital recipe book. You shall be able to create an account and log in. You shall be able to browse a set of default recipes from an entrée, main and dessert menu. You shall also be able to upload your own recipe and save it for later viewing. However, other people will not be able to see your recipe you have created. If you want other people to view the recipe you have uploaded you can submit your recipe for global review. When you submit your recipe for global review it will go to a “staging area”. Now the user “admin” who has administrative privileges will be able to review this recipe, decide where it belongs (entrée, main, dessert) and either accept it or delete it. Once it has been accepted it shall be uploaded to the default recipe book for all other existing and new users. You may also edit your recipe if you wish. You will be able to do this by going to the edit menu, following the instructions and changing what you like without having to rewrite your entire recipe again recipe again. A user may also delete an uploaded recipe, but not a default recipe as they will not have the option to do so.

If you ever have trouble about forgetting a recipe you have made this an easy digital cook book for you so you shall never forget again! The target audience for this app will most likely be targeted towards anyone who likes to cook, or wants to save their recipes.

All the user has to do is log in and it shall be ready to go! Navigate to the browse recipes section and BAM! You’re cooking!
<br>
<br>

## Overview of each feature

<br>
<br>

## Feature 1

Adding/Removing a recipe

A user shall be able to upload a recipe of their choosing. You shall be able to give it a name, how long it shall take to cook. A rating and the steps to follow to complete the recipe. You shall also be able to delete your recipes at will. You will not however be able to delete default recipes and this includes the ones you have submitted to be reviewed for the global recipe book.
<br>
<br>

## Feature 2

Staging a recipe

If a user really thinks their recipe is special and wants everyone to know about it and enjoy it. They may submit their recipe for review by the administrator. The administrator shall then review the recipe and deem it worthy or not if it shall be accessible as a default recipe for all users or if it sucks and should be deleted. You shall only be able to submit a recipe you have uploaded and not a default recipe. You shall not have the option to stage a default recipe. Next time a user logs in or a new user is created, the recipe shall be uploaded to their recipe book also.
<br>
<br>

## Feature 3

User log in / Create user

If you do not have an account, you may be able to create an account to log in and have access to some default recipes. Your username and password shall then be saved for use later on when you want to log in. If you have logged in and created a recipe, you and only you shall have access to that recipe the next time you log in.

How will the user interact and experience the application?

It pretty straight forward and will have instructions at each step if needed. You shall be prompted and have a menu where you shall be able to move your arrow keys up and down and then select you option. You shall also be able to input text into certain areas, however you will be prompted to do so when needed. If there is an error in the application or has an answer it does not want, it shall prompt the user to enter the right input and reload the method.
<br>
<br>
<br>
<br>

## My plan to impliment each feature

## Feature 1

Add and remove recipes

Be able to input text for recipe

Save the text from the inputs in a hash

Save that hash to a YAML file

Load YAML hash into ruby hash

Delete recipe from the hash

Overwrite YAML file with new ruby hash
<br>
<br>

## Feature 2

Read recipes into a ruby variable

Select only the recipes the user has not uploaded and not a default recipe

Display only user recipes

All them to enter for staging

Move recipe to staging file

Admin log in and have access to staging file

Make sure user does not have access to staging file

Move recipes to default books.

<br>
<br>

## Feature 3

User log in / create user

Make a YAML file with usernames and passwords.

If login in ensure that the username exits

If username exits allow them to log in

If password is correct log in or tell them to try again

If user wants to create an account, test if the username they want already exists

If it does try again

If not write new username and password to YAML file and create the account and log in user
<br>
<br>
<br>
<br>

## How to install

<br>

To be able to run this program you need to have ruby installed head over to https://www.ruby-lang.org/en/documentation/installation/ and follow the documentation to do so!

There are no extraordinary system or hardware requirements to run this program. Just some ruby gems!

You shall need to have these ruby gems, rspec, artii, colorize and tty-prompt

After you have ruby installed, to install these gems go to your terminal enter these commands:
<br>
<br>

To run the file go to

```
gem install tty-prompt
```

```
gem install artii
```

```
gem install rspec
```

```
gem install colorize
```

<br>
<br>

## How to use it!

To run app, open the terminal and type ./run_app.sh
<br>

The log in for administrator is Username: admin Password: admin
<br>
To create a user just select create account and log in that way!
<br>
Navigation is easy, you cannot go back when you are adding a recipe at the moment!

## Extra features \* _cough_ \* not bugs

<br>

Once a user has submited a recipe to the staging area and it has been accecpted it shall still show that they are able to uploaded the recipe again to stagin even though it is now a default recipe.
<br>
Users cannot edit rating on recipes.
<br>
Users cannot add or delete entire steps in the edit section.
<br>
You cannot go back when you are adding a recipe

## Testing!

The testing approach I used was manual testing

### Test to see if default recipe updated.

log in as a user
Make a new recipe
add it to staging area
log in as another user
check if recipe is visable
log in as admin
accept recipe
log in as user and check if recipe is now visble there too

### Test if recipe is edited and saves

Log in as user
go to browse recipe
go to browse recipe
edit recipe
go to browse recipe to check if changed
log out and back in the see if the change has been saved

### Test if users are uniqe and are being saved

Create a user
check if wanted username is already created
if not create that username with password
log in
log out
check if username is saved

### Test to see if the recipe deletes

log in as user
upload recipe
browse recipe section to see if it uploaded
delete that recipe
log out and back in to see if it has saved
