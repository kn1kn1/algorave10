
live_loop :cc1 do
  ##| stop
  use_synth :fm
  8.times do |i|
    play chord(:b2, [:m11, :m9, :M, :M7].choose),
      attack: [1, 0.75, 1.25, 1.5, 2].choose, cutoff: 80,
      amp: 0.75, pan: rrand(-0.2, 0.2)
    sleep 1
  end
end

live_loop :cc2 do
  stop
  use_synth :saw
  16.times do |i|
    sleep [0.25, 0.5, 0.75, 1, 1.25].choose
    play chord([:b2, :e2, :b4, :e4].choose, :M).choose,
      amp: 0.5, pan: rrand(-0.2, 0.2),
      attack: 0.25, release: rrand(1.5, 3)
  end
end

live_loop :cc3 do
  stop
  use_synth :beep
  12.times do |i|
    sleep [0.25, 0.5, 0.75, 1, 1.25].choose
    play chord([:b3, :b4, :e3, :e4].choose, :M).choose,
      amp: 0.5, pan: rrand(-0.2, 0.2),
      attack: 0.25, release: rrand(1.5, 3)
  end
end

