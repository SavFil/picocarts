pico-8 cartridge // http://www.pico-8.com
version 36
__lua__
function _init()
	cls(0)
 m_timer=0
 mode="start"
 
 stars={}
 for i=1,100 do
  add(stars,{x=rnd(128),
  											y=rnd(128),
  											spd=rnd(1.5)+.5})
 end
end

function _update()
 if mode=="game" then
 	update_game() 
 elseif mode=="start" then
  update_start()
 elseif mode=="over" then
  update_over()
 elseif mode=="menu" then
  update_menu()
 end
end

function _draw()
 
 if mode=="game" then
 	draw_game() 
 elseif mode=="start" then
  draw_start()
 elseif mode=="over" then
  draw_over()
 elseif mode=="menu" then
  draw_menu()
 end
end

function start_game()
 p={x=60,y=130,sx=0,sy=-0.5,i=2}
 bt={{typ=0,sx=0,sy=-2,icn=9,d=16,m=6,frm=5,mlt=1},
    {typ=1,sx=0,sy=-6,icn=14,d=8,m=3,frm=5,mlt=1},
    {typ=2,sx=0,sy=0,icn=27,d=10,m=3,frm=5,mlt=10},
    {typ=3,sx=0,sy=0,icn=27,d=10,m=3,frm=1,mlt=100}
    }
 bp=1
 bulets={}
 
 squad={p,
 						{x=40,y=140,sx=0,sy=-0.5,i=34},
 						{x=80,y=140,sx=0,sy=-0.5,i=34},
 						{x=20,y=150,sx=0,sy=-0.5,i=34},
 						{x=100,y=150,sx=0,sy=-0.5,i=34}
 					 	}
 					 	
 mobt={{icn=64,frm=5}}
 mp=1
 mobs={}
 aintro=10
 shoot_timer=0
 
 
 f={icn=4,ai=4,frm=5}
	
	muzzle=0 

 score="おまえわもしえいる"
 lives=3
 bombs=2
 
 
 mode="game"
end
-->8
--tools

function draw_starfield()
 for s in all(stars) do
  local scol=s.spd>1.25and 12
  										or s.spd>1and 13
  										or 1
   
  if s.spd<1.5 then
   pset(s.x,s.y,scol)
  else
   line(s.x,s.y,s.x,s.y+2,14)
  end
 end
end

function animatestars(f)
 if(f==nil)f=1
 for s in all(stars) do
  s.y+=s.spd*f
  if(s.y>128)s.y-=128
 end
end

function shoot(_b)
 local b=bt[_b]
 sfx(b.typ)  
 muzzle=b.m
 shoot_timer=b.d
 local r=90
 local s=-1
 if b.frm>1 then
 for i=0,b.mlt-1 do
  local t={}
  s=-1*s
  r+=s*i*20
  
   for k,v in pairs(b) do
	  t[k]=v
	 end
	 t.x=p.x
	 t.y=p.y-8
	 t.ai=b.icn
	 t.sx=0
	 if b.mlt>1 then
	  t.sx=cos(r/360)
	  t.sy=sin(r/360)
	 end
	 add(bulets,t)
	end
	elseif b.frm==1 then
	 for i=b.mlt,b.mlt+b.mlt do
		 local z={}

	  objcopy(b,z)
   
		 z.x=p.x
		 z.y=p.y-8
		 z.ai=b.icn
	  z.sx=cos((i*10)%360/360)*i/b.mlt
   z.sy=sin((i*10)%360/360)*i/b.mlt
	  add(bulets,z)
	 end
	end
end

function blink()
 return flr(-cos(t()*1.5)+0.2)+6
end

function draw_logo(i,x,y)
 sx,sy=(i%16)*8,flr(i\16)*8
 sspr(sx,sy,88,32,x,y)
end

function printc(_str,_y,_c)
 len=#_str
 where=63-(len*2)
 if (where<0) where=0
 print(_str,where,_y,_c)
end

function mob_spawner(_mp,_x,_y)
  local m={}
  objcopy(mobt[_mp],m)
  m.x=_x
  m.y=_y
  m.sx=0
  m.sy=1+rnd()
  m.ai=m.icn
  add(mobs,m)
end

function objcopy(_a,_b)
 for k,v in pairs(_a) do
	 _b[k]=v
	end
end
-->8
--update

function update_game()
 p.sx=0
 p.sy=0
 p.i=2
 if #mobs==0 then
 for i=1,8 do
  mob_spawner(mp,rnd(120),-8)
 end
 end
 --animate flame
 animate(f,7)

 
 --animate muzzle flash
 muzzle-=1
 
 shoot_timer=max(shoot_timer-1,0)
 
 --controls
 if (btn(0)) then
  p.sx=-1
  p.i=1
 end
 
 if (btn(1)) then
  p.sx=1
  p.i=3
 end
 
 if (btn(2)) then
  p.sy=-1
 end
 
 if (btn(3)) then
  p.sy=1
 end
 
 if btnp(4) then
  bp=1+bp%#bt
 end 
 
 if (btn(5)and shoot_timer<=0)shoot(bp)
  
 
 --collisions
 if (p.x < -7) then
 	p.x=127
 end
 
 if (p.x > 127) then
 	p.x=0
 end

 if (p.y < -7) then
 	p.y=127
 end
 
 if (p.y > 127) then
 	p.y=0
 end 
 
 --steps
 p.x+=p.sx
 p.y+=p.sy

 animatestars()
 
 update_objects(mobs)
 update_objects(bulets)
end

 function update_start()
 animatestars(10)
  if btnp(4) or btnp(5) then
  start_game()
  end
end

function update_over()
 if btnp(4) then
  mode="start"
 end
end


function update_menu()
 aintro=10-m_timer*0.06
 animatestars(max(1,aintro));
 
 for s in all(squad) do
  s.y+=s.sy
  s.x+=s.sx
  -- halt squad
  if (p.y==60) p.sy=0 
 end
 
 if (m_timer>160) aflame()
 
 if m_timer>200 then
  for i=2,#squad do
   local s=squad[i]
	  s.sx=i%2==0and-1or 1
	  s.i=i%2==0and 33 or 35
  end
 end 
 
 m_timer+=1
 if m_timer>250 then
  mode="game"
  m_timer=0
 end
end

function animate(o,t)
 o.ai=o.icn+time()*t%o.frm
end

function update_objects(objects)
	for b in all(objects) do
	  --animate objects
	  animate(b,4)
	  --move objects
	  b.x+=b.sx
	  b.y+=b.sy
	  --clean objects
	  if b.x<-8or b.x>129
	     or b.y<-8or b.y>129then
	   del(objects,b)
	  end
	 end
end
-->8
--draw

function draw_game()
 cls(0)
	draw_starfield()
	spr(p.i,p.x,p.y)
	spr(f.ai,p.x,p.y+8)
 
 draw_objects(mobs)
 draw_objects(bulets)
 
 
 circfill(p.x+3,p.y-2,muzzle,7)

 print("score: "..score,40,2,12)
 
 for i=1,3 do
  if lives>=i then
   spr(25,i*9-8,1)
  else
   spr(26,i*9-8,1)
  end
 end
 
-- print("type:",92,122)
-- spr(47+bp,113,120)
-- for i=1,3 do
--  if bombs>=i then
--   spr(27,i*9+90,1)
--  else
--   spr(28,i*9+90,1)
--  end
-- end
-- print(bp,64,64,7)
end

function draw_start()
 cls(0)
 draw_starfield()
 draw_logo(128,20,30)
 print("press 🅾️/❎ to start",22,80+blink(),blink())
-- print(rnd())
end

function draw_over()
 cls(1)
 print("game over",34,40,2)
 print("press 🅾️/❎ to restart",22,80,7)
end

function draw_menu()
 cls(0)
 draw_starfield()
 for c in all(squad) do
  local yoff,_yoff=c.y+5,c.y+20+max(-17,-m_timer*0.1)
  if m_timer<160 then
	  local tail={0,1,13,12,7,7,12,13,1} 
	  -- draw warp-tail
	  for i=0,7 do  
		  line(c.x+i,yoff,c.x+i,_yoff,tail[i+2])
	  end
	  spr(32,c.x,_yoff+1)
  else
  -- draw flame
	  spr(f.icon,c.x,c.y+8)	  
	 end
	 -- draw ship
	 spr(c.i,c.x,c.y)
 end
 
 -- draw ui
 if m_timer<160 then
	 printc("disengaging warp-drive",30,blink())
 elseif m_timer>170 then
	  printc("get ready commander",30,blink())
	  printc("level 1",38,8)
	end
end

function draw_objects(objects)
	for b in all(objects) do
  spr(b.ai,b.x,b.y)
 end
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000dccd00000dd00001dccd10000dd00000dccd000007700000770000
00000000000d60000006d0000006d0000007c0000000000000000000000000000000000002c77c2002dccd201dccccd102dccd2002c77c200006600000660000
0070070000d7160000671d0000671100000000000007c00000000000000000000007c00002c77c200dc77cd0dcc77ccd0dc77cd002c77c200000000000000000
000770000d311b6006b11bd006b1151000000000000000000007c0000007c0000000000002c77c20dcc77ccdcc7777ccdcc77ccd02c77c200007700000007700
00077000d33d3bb66bbd3bbd6b3dd551000000000000000000000000000000000000000002c77c20dcc77ccdcc7777ccdcc77ccd02c77c200006600000006600
00700700d3dd36b66b6d36bd6bd33d51000000000000000000000000000000000000000002c77c200dc77cd0dcc77ccd0dc77cd002c77c200000000000000000
000000000dd00d6006d006d006500d10000000000000000000000000000000000000000000dccd0002dccd201dccccd102dccd2000dccd000007700000770000
000000000000000000000000000000000000000000000000000000000000000000000000002dd200000dd00001dccd10000dd000002dd2000006600000660000
000770000000770000077000000100000001000000011000000010000000100000000000088008800880088000dd2100001d7d0000d7d10000167d0000d7d100
000660000000660000066000000900000009100000196100000190000000900000000000888888888008800801ddd21001d67d1001d76d100167761001d76d10
000000000000000000000000009910000099d10001d99d10001d99000001990000000000888888888000000811dddddddd6776d11d6776ddd67777611d6776dd
00077000007700000007700000d8210001dd8210128dd8210128dd1000128d000000000088888888800000082ddddddd7777776dd67777777777777dd6777777
00066000006600000006600001e8220002ee8220228ee8220228ee2000228e10000000000888888008000080ddddddd2d67777777777776d677777777777776d
00000000000000000000000001ee220002eed22022deed22022dee200022ee10000000000088880000800800dddddd211d6776dddd6776d11677776ddd6776d1
000770000000770000077000001111000111d21012d11d21012d111000111100000000000008800000088000012ddd1001d76d1001d67d100167761001d67d10
00066000000066000006600000101000001011000110011000110100000101000000000000000000000000000012dd0000d7d100001d7d0000d76100001d7d00
1dc77cd1000000000000000000000000000651000000000000076000000a9000000c100000082000000000000000000000000000008100800000000000000000
01dccd10000670000006500000065000007e2510000000000071150000a11400007551000080010000065100000d600000000000810996000000000000000000
001dd10000526700007225000066250006e222510000000070711505a0a1140970755101808001080072251000d716000000000011a1a1100000000000000000
000110000562e770067e255006662510662662560000000070711505a0a114097075510180800108067e25510d311b600000000011a77a980000000000000000
000000001566676766676655656555117676665600000000070650600a0940a0070c10c00802108066676655d33d3bb60000000089a77a010000000000000000
000000001567766766566555655665117067651600000000077665600aa994a00c7cc1c00882218066566555d36d36b60000000008111a110000000000000000
00000000015007600750075006500110700661060000000076766565a9a994a97c7cc1c182822181075107510dd00d6000000000109aa9010000000000000000
00000000000000000000000000000000000761000000000076065065a90940a97c0c10c182021081000000000000000000000000080111800000000000000000
000000000000000000076100000a910000000000000000000000000000094000000d100000000000000000000000000000000000000000000000000000000000
001dd1000000000070076106a00a9109070760500000000000000000009112000070010000000000000a41000009200000042000000210000000000000000000
01dccd100000000070676516a09a941907766561000000000000000090911204707001010000000000acc4100093320000422100002221000000000000000000
0dc77cd067067067767bb656a9add949667ab656000000000000000090911204707001010000000009a7c4410497322002462110012521100000000000000000
0dc77cd067067067667ab65699afd949767bb656000000000000000009042090070d10d000000000999a99444449442222242211111211110000000000000000
01dccd1000000000077665610aa99491706765160000000000000000099442900d7dd1d000000000994994444424422222122111111111110000000000000000
001dd10000000000070760500a0a9040700661060000000000000000949442947d7dd1d1000000000a410a410921092004110410021102100000000000000000
00000000000000000000000000000000000761000000000000000000940420947d0d10d100000000000000000000000000000000000000000000000000000000
de2002edd820028d182002811e2002e1182002810000000000000000000000000000000000000000000000000000000000000000000101800180000000000000
1e8228e10d8228e08d8228e88d8228d88d8228e80000000000000000000000000000000000000000000000000000000000000000181188888881011000000000
d018810dd018810dd018810dd018810dd018810d0000000000000000000000000000000000000000000000000000000000000001888889889889888100000000
00011000000110000801108000011000080110800000000000000000000000000000000000000000000000000000000000000118889899a99a98889811000000
08211280182112811e2aa2e1082aa2801e2aa2e1000000000000000000000000000000000000000000000000000000000000188989a9aaaaaaa99a9888100000
1e8aa8e1ee8aa8eee08ee80e1e8ee8e1e08ee80e000000000000000000000000000000000000000000000000000000000000188a9aaaa7aa7aaaaaa988100000
e00ee00ed00ee00dd008800de002200ed002200d000000000000000000000000000000000000000000000000000000000011889aaaa77a777a7aa7aaa9810000
d002200d0002200000022000000000000000000000000000000000000000000000000000000000000000000000000000001198aaa7a7777777777aaa98880000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000018889aa777777777777777aa9881000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011889aaa7777777777777a7a9981000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001899aa7777777777777777aaa881000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011889aaa7777777777777777aa988000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001888aa77777777777777777a7a998110
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011899aa77777777777777777aa988810
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011889aa77777777777777777aaa88100
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001888aaa7777777777777777aaa988100
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011889a7a77777777777777777a998810
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011889aa77777777777777777aaa88100
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011889aa7777777777777777a9888100
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000018889a7a77777777777777aa9981000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001189aaa77777777777777a7aa888100
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011889aaa77a777777777aaa9810000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001189aaaa7a77777a7a7aaa98810000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011899aaaaa7a7a7aaaa9a98880000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000818889a9aaaaaaaa998881100000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000018888989a99a998898880000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000018188888989888888110000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001181888888881181000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011811810180010000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001100010000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
08888888888880000888888888800888888888800008888888888000000888888880000000000000000000000000000000000000000000000000000000000000
08888888888880000888888888800888888888800008888888888000000888888880000000000000000000000000000000000000000000000000000000000000
00000008800000088880000000000008800008888000088000088880088880000888800000000000000000000000000000000000000000000000000000000000
00000008800000088880000000000008800008888000088000088880088880000888800000000000000000000000000000000000000000000000000000000000
00000888800000000888888880000888888888800008888888888000088888888888800000000000000000000000000000000000000000000000000000000000
00000888800000000888888880000888888888800008888888888000088888888888800000000000000000000000000000000000000000000000000000000000
00000008800000088880000000000008800008888000088000088880088880000008800000000000000000000000000000000000000000000000000000000000
00000008800000088880000000000008800008888000088000088880088880000008800000000000000000000000000000000000000000000000000000000000
00000888800000000888888888800888800008800008888000088000000880000008800000000000000000000000000000000000000000000000000000000000
00000888800000000888888888800888800008800008888000088000000880000008800000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000055599999999999999955555555555599999999999999955555599999955555599999955500000000000000000000000000000000000000000000
00000000000055599999999999999955555555555599999999999999955555599999955555599999955500000000000000000000000000000000000000000000
00000000000055599999999999999955555555555599999999999999955555599999955555599999955500000000000000000000000000000000000000000000
00000000000055500099900000099999955555599999900000000000000055555599999999999900000000000000000000000000000000000000000000000000
00000000000055500099900000099999955555599999900000000000000055555599999999999900000000000000000000000000000000000000000000000000
00000000000055500099900000099999955555599999900000000000000055555599999999999900000000000000000000000000000000000000000000000000
00000000000055599999999999999900000055500099999999999955555555555555599999900000055500000000000000000000000000000000000000000000
00000000000055599999999999999900000055500099999999999955555555555555599999900000055500000000000000000000000000000000000000000000
00000000000055599999999999999900000055500099999999999955555555555555599999900000055500000000000000000000000000000000000000000000
00000000000055500099900000099999955555599999900000000000055555555599999999999955555500000000000000000000000000000000000000000000
00000000000055500099900000099999955555599999900000000000055555555599999999999955555500000000000000000000000000000000000000000000
00000000000055500099900000099999955555599999900000000000055555555599999999999955555500000000000000000000000000000000000000000000
00000000000055599999900055599900000055555599999999999999955555599999900000099999955500000000000000000000000000000000000000000000
00000000000055599999900055599900000055555599999999999999955555599999900000099999955500000000000000000000000000000000000000000000
00000000000055599999900055599900000055555599999999999999955555599999900000099999955500000000000000000000000000000000000000000000
00000000000055555500000055555500000055555555500000000000000055555500000055555500000000000000000000000000000000000000000000000000
00000000000055555500000055555500000055555555500000000000000055555500000055555500000000000000000000000000000000000000000000000000
00000000000055555500000055555500000055555555500000000000000055555500000055555500000000000000000000000000000000000000000000000000
1248ef70124def7012549f70153db67015d670000066cd000066cd000d7f94000000000000000000000000000000000000000000000000000000000000000000
12549af7124def7012549f70153db67015d6700006666cd006776cd067f6f9000000000000000000000000000000000000000000000000000000000000000000
153dba70124def7012549f70153db67015d6700066766ccd67776cc17f611d000000000000000000000000000000000000000000000000000000000000000000
15dc6700124def7012549f70153db67015d6700066666ccd66766cd1f6d005000000000000000000000000000000000000000000000000000000000000000000
00000000124def7012549f70153db67015d67000c666cccdc666cd51ffd00d000000000000000000000000000000000000000000000000000000000000000000
00000000124def7012549f70153db67015d67000ccccccddccccc5159f6d19000000000000000000000000000000000000000000000000000000000000000000
00000000124def7012549f70153db67015d670000dcccdd00dc51150099999000000000000000000000000000000000000000000000000000000000000000000
00000000124def7012549f70153db67015d6700000dddd0000dd5500004444000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000600000000d0000006d000000d0000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000006d50000005760000671d0000611000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000006b13500005d1b6006b11bd006b1d100000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000006bb3351005db3bb66bbd3bbd6bd3d510000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000006b33551005db3bb66b6d36bd6bd3d510000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000650510000560b6006d006d006106100000000000000000000000000000000000000000000000000000000000000000000000000
__label__
0000000000000000000000000000000000e000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000
0088008800088008800088008800000000e000000000000000000000000000000000000000000000000000000000000000000001980000001980000810080000
0888888880888888880888888880000000e000000cc00cc00cc0ccc0ccc000000000ccc0ccc0ccc0ccc0ccc000000000000000108a90000108a9081099100000
0888888880888888880888888880000000000000c000c000c0c0c0c0c0000c00000000c0c0c0c0c0c0c0c0c00000000000000111180000111180011a1a110000
0888888880888888880888888880000000000000ccc0c000c0c0cc00cc00000000000cc0c0c0c0c0c0c0c0c00000000000001116110001116110011a77a98000
008888880008888880008888880000000000000000c0c000c0c0c0c0c0000c00000000c0c0c0c0c0c0c0c0c00000000000011111611011111611089a77a01000
0008888000008888000008888000000000000000cc000cc0cc00c0c0ccc000000000ccc0ccc0ccc0ccc0ccc00000000000016111161016111161008111a11000
000088000000088000000088000000000000000000000000000000000000000000000000000000000000000000000000000016111100016111100109aa901000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000111100000111100008011180000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000c0000000000000
000000000000000000000e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000e0000000000000000000000000000000000000000000000000000000000000e00000000000000000000000000000000000000000000
000000000000000000000e0000000000000000000000000000000000000000000000000000000000000e0000000000000000000000e0000000000000c0000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000e0000000000000000000000e000000000000000000000
000000000000000000000000000000000000000000000000000000000000000c0000000000e000000000000000000000000e000000e000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000001000e000000000000000000000000e0000000000000000000000000000
00000000000001000000c00000000000000000000000000000000000000000000000000000e000000000000000000000000e0000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000e000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000e000000000000000000000e00000000000000000000000
0000000000000000000000000000000000000010000000000000000000000000000000000000000000e000000000000000000000e00000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e00000000000000000000000
0000000000100000000000000000000000000000000000000010000e000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000e0000000000000000000000000000000000000000000000000000000000000000000d0100
0000000000000000000000000000000000000000000000000000000e000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000c0000000000000000000
0000000000000000000000e0000000000000000000000000000000000e000000000000000000000000000000e000000000000000000000000000000000000000
0000000000000000000001e0000000000000000000000000000000000e000000000000000000000000010000e000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000e000000000000000000000000000000e000000000000000000000000000000000000000
000000000000000000000000000000000c00000000000000000000000000000000000000e0000c00000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000e00000d0000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000e0000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e00000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000e0000000000000000000000000000000000e00000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000e00000000000000d0000000000000000000e00000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000e1000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000c000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000d000000000000000000000001000000000000000000000000000000000000000000000000000e000000000000
0000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000e000000000000
0000000000000000000000000000000000000000000e000000000000000000000000000000100000000000000000000000000000c0000000000e000000000000
0000000000000000000000000000000000000000000e00000000000000000000000000000d0000000000000000000000000000000000000000000e0000000000
0000000000e00000000000000000000000000000000e00000000000000000000000000000000000000000000000000000000000000000000e0000e0000000000
0000000000e000000000000000000000000000000000000000000000000000000000000000000000000000000d0000000000000000000000e0000e0000000000
0000000000e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000c0000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000
000000000000000000c0000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000
00000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000e000000000000000000000000e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000e000000000000000000000000e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000e0000000000000000000000000000000000000000000000000000c00000c00000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d0000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000
00000000000000c0000000000000000000000000000000000000000000000000000000000000c000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e0000000000000000
000000000000000000000000000000000000000000000e000000e00000000000000000000000000000e0000000000000000000000000000e0000000000000000
000000000000000000000000000000000000000000000e000000e000000000100000e0000000000000e0000000000000000000000000000e0000000000000000
e00000000000000000000000000000000000000000000e000000e000000000000000e0000000000000e000000000000000000000000000000000000000000000
e0000000000000000000000000000000000000000000000000000000000000000000e00000000000000000000000000000000000000000000000000000000000
e000000000000000000000000000000000000000000000000d000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000c00000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000c00000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000d000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000e00000000000000000000000000e000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000e00000000000000000000000000e00000d000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000e00000000000000000000000000e000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
e00000000000000000000000000000000000000000000000000000001100000000000e00000000000000000000c0000000000000000000000000000000000000
e00000000000000000000000000000000000000c00000000000000019610000000000e0000000000000000000000000000000000000000000000000000000000
e000000000000000000000000000000000000000000000000000001d99d1000000000e0000000000000000000000e00000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000128dd8210000000000000000000000000000000e00000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000228ee8220000000000000000000000000000000e00000000000000000000000000000000000
0000000000000000000001000000000000000000000000000000022deed220000000000000000000000000000000000100000000000000000000000000000000
0000001000000000000000000000000000000000000000000000012d11d210000000000000000000000000000000000000e00000000000000000000000000000
0000000000000000000000000000000000000000000000000000001100110000000000000000000000000000000000e000e00000000000000000001000000000
0000000000000000000000000000000000000d00000000000000000000000000000000000000000000000000000000e000e00000000000000000000000000000
00000000000000000000000000000e0000000000000000000000000099000000000000000000000000000000000000e000000000000000000000000000000000
00000000000000000000000000000e00000000000000000000000029aa9000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000e0000000000000000000000000077000000000000000000000000000000000000000000e000000000000000000000000000
0000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

__sfx__
00010000305502c55026550235501d550195501555012550105500f5500c5500a55009550085500755007550065500750008500045000b5000f500125001f5003050000000000000000000000000000000000000
000100001355013550135500000000000000001355013550135500000000000000000000013550135501355000000000000000000000000000000000000000000000000000000000000000000000000000000000
00010000296502665022650216500d650176500b6500d6500a6500b65003650086501b5501a550086500365003650076500365006650066500665005650056101e5001f500275002750026500285002c50031500
00010000216501e6501a650196500965010650086500a650066500865002650056501665012650056500165000650046500065003650036500365002650016101e5001f500275002750026500285002c50031500
