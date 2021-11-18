# sfindocker
Easily to test your symfony applications on futurs versions of PHP

## Quick installation

🛑 sfindocker only works on recents symfony application built with Symfony cli. Mailer and database on your docker-compose.yml are also required

 * Step 1, go to your projet and start your database and mailer with docker-compose
 * Step 2, copy paste docker-compose-php81RC6.yaml in your project
 * Step 3, replace PROJECT_FOLDER_NAME by the exact name of your current folder
 * Step 4, start this new docker-compose-php81RC6.yaml `docker-compose -f docker-compose-php81RC6.yaml up --force-recreate`
 * Step 5, go to http://localhost:8000/ on your favorite browser, and you should be on PHP8.1 RC6

## The purpose of this little tool

I wanted to see if i got deprecated codes on my project, but I didn't want install PHP8.1 RC6 on my macbook. Docker is a perfect solution to test it quickly. 

## Feel free to contribute 🚀

You can adapt php81RC6 for you needs. 

## Disclaimer 

I only test it on my mac
