# Char's Song Visualizer

## A .ogg player that let's you add custom visuals behind a track (NOT YET IMPLEMENTED)

# How to add custom assets

## Custom Songs

To make a custom song, simply drop an ogg file of the song, and a metadata file into `externSongs/`:

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

Custom playlists are not implemented at this time.

## Custom Visualizers

Visualizers are not implemented at this time.

# Controls

By default the controls are as follows:

`W`/`S` `Up`/`Down` - Change selection

`A`/`D` `Left`/`Right` - Skip Back/Forward 10s

`Space`/`Enter` - Confirm/Pause

`Backspace`/`Escape` - Stop

`Shift+Confirm` - Loop Song

## Mouse Controls

Currently you can only click on the timebar to change what part of the song you are currently in.