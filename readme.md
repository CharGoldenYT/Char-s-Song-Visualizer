# Char's Song Visualizer

## A .ogg player that let's you add custom visuals behind a track (NOT YET IMPLEMENTED)

# How to add custom assets

## Custom Songs

To make a custom song, simply drop an ogg file of the song, and a metadata file into `externSongs/` (`~/Music/CSV/externSongs` on Mac and optionally on Linux):

`example-song.json`
```json
{
    "name": "Example Song",
    "artists": [
        "Example Artist"
    ],
    "album": "Example Album",
    "path": "path-from-songs-folder"
}
```

## Custom Playlists

To make a new custom playlist you must place a new playlist file in `playlists/` (`~/Music/CSV/playlists/` on Mac and optionally on Linux): like so:

`example-list.pl`

```json
{
    "mmdf": {
        "data": [
            {
                "name": "Example Song1",
                "artists": [
                    "Example Artist"
                ],
                "album": "Example Album",
                "path": "path-from-songs-folder"
            },
            {
                "name": "Example Song2",
                "artists": [
                    "Example Artist"
                ],
                "album": "Example Album",
                "path": "path-from-songs-folder"
            }
        ]
    },
    "listName": "Example List",
    "listCreator": "Example List Creator"
}
```

## Custom Visualizers

Visualizers are not implemented at this time.

# Controls

By default the controls are as follows:

`Q`/`E` - Change Tabs

`W`/`S` `Up`/`Down` - Change selection

`A`/`D` `Left`/`Right` - Skip Back/Forward 10s

`Space`/`Enter` - Confirm/Pause

`Backspace`/`Escape` - Stop

`Shift+Confirm` - Loop Song/Playlist

`Tab+Confirm` - Shuffle Playlist

## Mouse Controls

Currently you can only click on the timebar to change what part of the song you are currently in.