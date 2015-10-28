-- Music module

music = { }
music.dir = "assets/music/"

music.list = lfs.getDirectoryItems(music.dir) -- Causes music to be initialized on load


-- Re-initialize the music module by loading up a list of the items in the 'music' folder
function music.init()
  music.list = lfs.getDirectoryItems(music.dir)
end



-- Plays a specific track as designated by 'name' (must include file extension) as found in 'music' folder
function music.request(name)
  if music.current ~= nil then
    la.stop(music.current)
  end
  if lfs.exists(music.dir..name) then
    music.current = la.newSource(music.dir..name)
    la.play(music.current)
  else
    print("No song found...")
  end
end



-- Plays a random track
function music.random()
  if music.current ~= nil then
    la.stop(music.current)
  end
  print("Randomizing song...")
  math.randomseed(lt.getDelta())
  local title = music.list[math.random(1, #music.list)]
  print("Now playing: "..string.sub(title, 1, -5))
  music.title = string.sub(title, 1, -5)
  music.current = la.newSource("assets/music/"..title, "stream")
  la.play(music.current)
  music.new = nil
end



-- Plays next track, or random if no sequence is set
function music.next()
  if music.new == nil then
    music.random()
    return
  end
  if music.current ~= nil then
    la.stop(music.current)
  end
  print("Now playing: "..music.new)
  music.title = music.new
  if lfs.exists("assets/music/"..music.new..".ogg") then
    currentSong = la.newSource("assets/music/"..music.new..".ogg", "stream")
  elseif lfs.exists("assets/music/"..music.new..".mp3") then
    currentSong = la.newSource("assets/music/"..music.new..".mp3", "stream")
  end
  la.play(music.current)
  music.new = nil
end
