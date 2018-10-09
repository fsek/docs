
Songbook
=========

This is the **best** and the most *important* page of the app.

=======================
Javascript Description
=======================

**songbook.js** contains the JS code for both the songbook page
**songbook.html** and for the individual song pages song.html.


JS for the songbook
--------------------
Upon initializing the songbook page the API-endpoint **/songs** (link
to the API description table) is accessed and the JSON object is
retrieved. The JSON contains the songs in alphabetical order with the
song id, text, author and category. When the data is retrieved the
function **initSongList** is called.

The **initSongList** function regroups the songs according to the
first letter and builds the html from the template of the songbook.
The first letter of the first song is stored in the first attribute
*firstLetter* of a JSON object. Then all the songs with the same first
letter are stored in an array which is then stored as the second
attribute of the JSON object. For every first letter, a JSON object is
created containing the actual letter and an array of the songs. These
JSON objects are then pushed into the array **songList**. The songList object is
structured in the following manner:

::

  [{firstLetter: A, songs: [song1, song2, ...]}, {firstLetter: B, ..}, ...]

**initSongList** then calls on the template **songbookTemplate** with the
**songList** as parameter an the template creates the html for the songbook
page. The letter index is then created using the Framework7 object
**listIndex**:

::

    var listIndex = app.listIndex.create({
      el: '.list-index',
      listEl: '#songbook-list',
      label: true,
    });


JS for the individual songs
-----------------------------
The song objects in the songbook list links to **song/id**. When the song page
is initialized, the API-endpoint **/songs/id** is called. This returns a JSON
with the song text and some additional info about the song. The template is then
created from the JSON information and added to the song page html.








