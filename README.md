# README

## New Folder which will be nested
curl -X POST -F "title=folder_name" -F "path=/root…/parent" http://localhost:3000/folders

## New root folder
curl -X POST -F "title=folder_name"  http://localhost:3000/folders

## New Note
curl -X POST -F "path=folder/path" -F "title=my_note" -F "content=content of note" http://localhost:3000/notes

## View note
curl -X GET http://localhost:3000/notes/name_of_note

## Move note
curl -X PATCH -F  "title=root_note" -F "from=path" -F "to=path" http://localhost:3000/notes/move


# Explanations:

## Why not use nested resources?
Would complicate URL structure send requests to

## Why use names in url structures?
More user friendly -> doesn’t expose backend
Caveat -> everything has to be unique in name
