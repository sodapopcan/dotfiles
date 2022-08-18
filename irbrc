pwd = Dir.pwd
local_irbrc = "#{pwd}/.irbrc"
load local_irbrc if File.exist?(local_irbrc)

IRB.conf[:SAVE_HISTORY] = 1000
IRB.conf[:HISTORY_FILE] = "#{pwd}/.irb_history"
IRB.conf[:USE_AUTOCOMPLETE] = false
