node-mac-spotify
================

This is a module that binds the controlling functionality that Spotify exposes via Apple Events to node.js users.

##API

###Settings
####`.volume`
Set/get the playback volume.


####`.shuffling`
Enable/disable shuffling.


####`.repeating`
Enable/disable repeating.



###Track Control

####`play()` 
Begins audio playback.


####`pause()`
Pauses audio playback.


####`playpause()`
Toggles audio playback.


####`next()`
Skips to the next song in the current playlist/album.


####`previous()`
Returns to the previous song in the current playlist/album.


####`playTrack(*uri* [, *context* ])`
Plays the track at the given `uri`. An **optional** parameter, `context`, can be given.
