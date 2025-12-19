# Collecting playlists
# Queue up commands that download video titles and attatch the m4a file extension and put in an m3u file in the appropriate place

download_playlists_function='yt-dlp --restrict-filenames -o '"'"'../pool/%(title)s.m4a'"'"' --get-filename'
unset playlists
declare -A playlists
playlists['balatro']='PLEITERw4PaKFs_uS0MoXkIfGbsYJHmWVU'
playlists['silksong']='PLyfXx1BeqwFYFwnXDZo6xYSIsek2x2fhp'
playlists['celeste']='PLyfXx1BeqwFbnI87AyqLP5XcEg1u5kydi'
playlists['hollow_knight']='PLyfXx1BeqwFZXtJPE153jA-8NJWz579Pb'
playlists['terraria']='PLyfXx1BeqwFb9eMbR78HzJtvhAuGH2rnc'
playlists['calamity']='PLyfXx1BeqwFY7_xMkP9BCAogmUQbwFBjc'
playlists['calamity_infernum']='PLyfXx1BeqwFb0IcIT2_cbShbguqGOvnaq'
playlists['baba']='PLyfXx1BeqwFaO6xFIQXFhQTJtFdP4WYyc'
playlists['deltarune']='PLyfXx1BeqwFakIcMEOb5L3hLLuTWHZhFv'
playlists['undertale']='PLyfXx1BeqwFZoI5JKqSOCYTq9_fxIqPPc'
playlists['isaac_rebirth']='PLyfXx1BeqwFYwjv_IHypwL_QeR4IT4rW_'
playlists['isaac_afterbirth']='PLyfXx1BeqwFYEsmSq2YcXYfPoSxhqUdKj'
playlists['isaac_repentance']='PLyfXx1BeqwFYukH-L7NXfhom6UPaSb33N'
playlists['isaac_antibirth']='PLyfXx1BeqwFZfbk9ksALFm-Q6hmQPacQ1'
playlists['minecraft']='PLyfXx1BeqwFZ3paVLhJwsHpuWM4zlhLPj'
playlists['stardew_valley']='PLyfXx1BeqwFYtf2Dntv405dH8I9FP5GcV'
playlists['cassette_beasts']='PLyfXx1BeqwFZw1-JcUkkxHcodnwr_W6Nd'
playlists['RoA']='PLyfXx1BeqwFYNtQ2sBVUvZ0_PUYvGLe_x'
playlists['rhythm_doctor']='PLyfXx1BeqwFYvPfUFBjkZvmpFYFbSJQ2R'
playlists['luck_be_a_landlord']='PLyfXx1BeqwFbcG-8eBmiIbmDtNmn4tq2H'
playlists['anime']='PLyfXx1BeqwFZcwV_yqpe5khtlKWGf0jM_'
playlists['misc']='PLyfXx1BeqwFZzRwmxQ1To7HQN37pj1EAs'

commands=()

mkdir playlists

for playlist_name in ${!playlists[@]}; do
    echo "[THE PLAYLIST] Added $playlist_name to queue"
    commands+=("($download_playlists_function ${playlists[$playlist_name]} > playlists/${playlist_name}.m3u && echo \"[THE PLAYLIST] Generated \\\"$playlist_name\\\" playlist\") &")
done

# Downloading Audio
# Queue up commands that download audio from playlists

download_audio_pl='yt-dlp -t aac --restrict-filenames -o '"'"'pool/%(title)s'"'"''

for playlist_name in ${!playlists[@]}; do
    echo "[THE PLAYLIST] Queued up $playlist_name playlist"
    commands+=("($download_audio_pl ${playlists[$playlist_name]} && echo \"[THE PLAYLIST] Finished Downloading $playlist_name\") &")
done

# Executing commands
# Up to this point we've built up a queue of commands. The commands get executed in a parallel way and in a way that when you press =C-c= (Ctrl-C) in the terminal, it exits propperly. This way also insures the terminal doesn't hang (pretty nifty eh?)

(trap 'kill 0' SIGINT; eval ${commands[*]} wait)

# Custom Playlists
# Generates the *everything* playlist

rm -f playlists/everything.m3u
cat playlists/* > playlists/everything.m3u


# Generates the "isaac" playlist

rm playlists/isaac
cat playlists/isaac* > playlists/isaac
