ioreg -n AppleSmartBattery -r | awk '$1~/Capacity/{c[$1]=$3} END{OFMT="%.2f%%"; max=c["\"MaxCapacity\""]; print (max>0? 100*c["\"CurrentCapacity\""]/max: "?")}'

# ███
# ██▉
# ██▊
# ██▋
# ██▌
# ██▍
# ██▎
# ██
# █▉
# █▊
# █▋
# █▌
# █▍
# █▎
# █▏
# █
# ▉
# ▊
# ▋
# ▌
# ▍
# ▎
# ▏
