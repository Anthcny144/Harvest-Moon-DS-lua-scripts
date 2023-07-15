# Farmland info
A script to clearly visualize the chunks & addresses of Farmlands

# How does it work
Farmlands in HMDS are divided in several chunks of rectangle shape. This script will fill them with crops and mark the top-left and bottom-right corners with a different crop, allowing the user to clearly see the start and end of each chunk<br><br>
Running the script will ask the user if they want to cover impossible tiles: they are tiles that are part of a chunk but not meant to be used (e.g in the left farmlands in town, round trees are part of chunks, despite them being in the "background")<br><br>
After covering the tiles, the script will keep running. At this point, each time you pick a crop of a chunk, the script will let you know the address of the chunk the crop you picked was from, and also its ID and size

# How to run
Simply download the code and run Script.lua<br>
Recommanded emulator: [Lastest DeSmuME](https://github.com/TASEmulators/desmume/releases/)

# Compatibility
Every HMDS / HMDSC version
