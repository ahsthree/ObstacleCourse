#!/usr/bin/ruby


File.open("include.bzw","w") do |bzw|
cnt=0
mxcnt=14

z=0
x=-465


bzw.puts "material\nname clear\ndiffuse 0 0 0 0\nnolighting\nnosorting\nnoculling\nnoradar\nend"
files=Array.new

dir="./obs/"

files = Dir.foreach(dir).select { |x| File.file?("#{dir}/#{x}") }

inc=files.count

puts "#{files} #{inc}"

while cnt <= mxcnt

obs=rand(inc)



bzw.puts "define stg-#{cnt}\n\n"
bzw.puts "include ./obs/#{files[obs]}\n"

bzw.puts "box\npos 0 0 0\n size 75 150 5\nend\n\n"
bzw.puts "box\n pos 0 200 0\nsize 75 50 5\nend\n\n"
bzw.puts "box\n pos 0 -200 0\nsize 75 50 5\nend\n\n"

puts cnt

if cnt == 0

bzw.puts "base\n position 0 200 5\nsize 15 15 2\ncolor 2\nend\n\n"


else

bzw.puts "teleporter in\nposition 0 200 5\nsize .125 10 15\nborder .25\nrotation 90\nend\n\n"

end

bzw.puts "teleporter out\nposition 0 -200 5\nsize .125 10 15\nborder .25\nrotation 90\nend\n\n"
bzw.puts "box\npos 78 0 0\nsize 3 250 400\nmatref clear\nend\n"
bzw.puts "box\npos -78 0 0\nsize 3 250 400\nmatref clear\nend\n"
bzw.puts "box\npos 0 253 0\nsize 78 3 400\nmatref clear\nend\n\n"
bzw.puts "box\npos 0 -253 0\nsize 78 3 400\nmatref clear\nend\n\n"
bzw.puts "enddef # stg-#{cnt}"















zz=z+5

bzw.puts "group stg-#{cnt}\nname stg-#{cnt}\nrot 0\nshift #{x} 0 #{z}\nend\n\n "



if x == 465

  x=-465
z+=150

else

x+=155

end



cnt+=1

end

cnt=0


while cnt < mxcnt

pcnt=cnt+1

bzw.puts "link\n from stg-#{cnt}:out:*\nto stg-#{pcnt}:in:b\nend\n\n"



cnt+=1

end

bzw.puts "link\nfrom stg-#{mxcnt}:out:*\nto win:*\nend\n\n"


end
