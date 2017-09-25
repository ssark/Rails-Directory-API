# README

## Set up

To start off, you can run `bundle install` to install all gems. Then run `rake db:drop` to drop any remnant data in the SQLite database. I did delete the database, but it'll be safer if you run this first. Then run `rake db:create` then `rake db:migrate` then `rake db:seed`.

In the way I structured the folder hierarchy, you are given one folder already (it was seeded to the app). This folder is called `root` and functions as the root folder; all other folders nest under this. If a folder is nested, it'll have a `parent` folder. Every folder has either 0 or more `children`. A folder can also contain 0 or more `notes`.

## Requests

### New Folder
curl -X POST -F "title=folder_name" -F "path=/root/…/parent" http://localhost:3000/folders

### New Note
curl -X POST -F "path=folder/path" -F "title=my_note" -F "content=content of note" http://localhost:3000/notes

### View note
curl -X GET http://localhost:3000/notes/name_of_note

### Move note
curl -X PATCH -F "title=root_note" -F "from=curr/path/to/note" -F "to=target/path" http://localhost:3000/notes/move

### View all data
curl http://localhost:3000/

## Explanations:

### Why not use nested routes?
I initially went along with the idea of nesting all of the routes belonging `Note` under those of `Folder` but this complicated the URL structure to which we sent requests which wouldn't be very developer-friendly.

### Why do I use `title`s of folders and notes to identify them in my URLs?
I decided to get rid of the default `:id` paramater in URLs that Rails gives us upon scaffolding so that the URL structure would be more developer-friendly. It's hard to keep track of ids of folders or notes created. Another major reason for this choice was that using ids within the URL strucuture would expose the backend i.e. a developer could figure out how many instances of a particular object were created/destroyed based on their object's id number. This isn't necessarily harmful but I think hiding one's underlying implementation and data is good practice. A caveat of this choice though is that all `title`s of folders and notes have to be unique since `title` is now used as the unique identifier. I know that `validates :title, uniqueness: true` doesn't strictly _always_ maintain the uniqueness of the `title` in the underlying database, but it's good enough for our use here.
