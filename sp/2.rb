load "~/github/petal-1.3.0/petal.rb"

set_volume! 2.0
set_mixer_control! amp: 1, amp_slide: 0
cps 1; d1; use_bpm get_bpm; live_loop :l0 do use_bpm get_bpm; sync :d0; end

live_loop :l5, sync: :l0 do
  hush
  stop
  
  use_random_seed 1
  with_fx :level, amp: 10 do
    with_pfx(window_size_list = [2.5], pitch_list = [2.5]) do
      d1 #"tech(5,16)", slow: 2, rate: -1, amp: 1, n: "irand 64", pan: "rand -0.5 0.5"
      d2 #"e(5,16,1)", slow: 2, rate: 1, amp: 1, n: "irand 64", pan: "rand -0.5 0.5"
      d3 #"jazz(#{[7, 9, 11].choose},16,2)", slow: 2, rate: 1, amp: 1, n: "irand 64", pan: "rand -0.5 0.5"
      d4 ":bd_haus(3, 16)", slow: 2, amp: 1
      d5 :bd_haus, slow: 4, amp: 1
      
      sleep 3
    end
  end
  
end
