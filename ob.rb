#!/usr/bin/ruby

# Emit a generic BZW object: a type line, an arbitrary set of property
# lines, and a closing "end". A trailing blank line keeps the output
# readable and matches the spacing of the original template.
def bzw_object(io, type, *properties)
  io.puts type
  properties.each { |property| io.puts property }
  io.puts "end"
  io.puts
end

# A box obstacle. matref/phydrv are optional so the same helper covers
# both the solid stage boxes and the clear bounding walls.
def box(io, pos:, size:, matref: nil, phydrv: nil)
  properties = ["pos #{pos}", "size #{size}"]
  properties << "matref #{matref}" if matref
  properties << "phydrv #{phydrv}" if phydrv
  bzw_object(io, "box", *properties)
end

# A teleporter (in/out/win). rotation is optional.
def teleporter(io, name, position:, size:, border:, rotation: nil)
  properties = ["position #{position}", "size #{size}", "border #{border}"]
  properties << "rotation #{rotation}" if rotation
  bzw_object(io, "teleporter #{name}", *properties)
end

# A base flag/spawn.
def base(io, position:, size:, color:)
  bzw_object(io, "base", "position #{position}", "size #{size}", "color #{color}")
end

# A group instance of a previously defined stage.
def group(io, name, rot:, shift:)
  bzw_object(io, "group #{name}", "name #{name}", "rot #{rot}", "shift #{shift}")
end

# A teleporter link between two stages.
def link(io, from:, to:)
  bzw_object(io, "link", "from #{from}", "to #{to}")
end

# The four transparent walls that box a stage in. They only differ by
# pos/size, so build them from a table instead of repeating the call.
def clear_walls(io)
  [
    { pos: "78 0 0",    size: "3 250 400" },
    { pos: "-78 0 0",   size: "3 250 400" },
    { pos: "0 253 0",   size: "78 3 400" },
    { pos: "0 -253 0",  size: "78 3 400" },
  ].each { |wall| box(io, pos: wall[:pos], size: wall[:size], matref: "clear") }
end

File.open("include.bzw", "w") do |bzw|
  mxcnt = 14

  z = 0
  x = -465

  bzw_object(bzw, "material",
             "name clear",
             "diffuse 0 0 0 0",
             "nolighting",
             "nosorting",
             "noculling",
             "noradar")

  dir = "./obs/"
  files = Dir.foreach(dir).select { |f| File.file?("#{dir}/#{f}") }
  inc = files.count

  puts "#{files} #{inc}"

  cnt = 0
  while cnt <= mxcnt
    obs = rand(inc)

    bzw.puts "define stg-#{cnt}\n\n"
    bzw.puts "include ./obs/#{files[obs]}"

    box(bzw, pos: "0 0 0",    size: "75 150 5")
    box(bzw, pos: "0 200 0",  size: "75 50 5")
    box(bzw, pos: "0 -200 0", size: "75 50 5")

    puts cnt

    if cnt == 0
      base(bzw, position: "0 200 5", size: "15 15 2", color: 2)
    else
      teleporter(bzw, "in", position: "0 200 5", size: ".125 10 15", border: ".25", rotation: 90)
    end

    teleporter(bzw, "out", position: "0 -200 5", size: ".125 10 15", border: ".25", rotation: 90)
    clear_walls(bzw)
    bzw.puts "enddef # stg-#{cnt}"

    group(bzw, "stg-#{cnt}", rot: 0, shift: "#{x} 0 #{z}")

    if x == 465
      x = -465
      z += 150
    else
      x += 155
    end

    cnt += 1
  end

  cnt = 0
  while cnt < mxcnt
    pcnt = cnt + 1
    link(bzw, from: "stg-#{cnt}:out:*", to: "stg-#{pcnt}:in:b")
    cnt += 1
  end

  link(bzw, from: "stg-#{mxcnt}:out:*", to: "win:*")
end
