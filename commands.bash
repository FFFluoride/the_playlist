# Playlists
# Emacs declares an associative array based on the table of playlists

# This is pretty gnarly by my standards.
# Basically, you make an array to sequence commands by looping once and then running the long running tasks in parallel by launching multiple subshells and using '&'.

# It's important that this runs in a subshell or else ctrl-c wouldn't kill all the processes.

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
      commands+=("echo \"Generating \\\"$playlist_name\\\" playlist\" & yt-dlp --restrict-filenames -o '../pool/%(title)s.opus' --get-filename \"${playlists[$playlist_name]}\" > \"$(echo playlists/${playlist_name}.m3u)\" &")
  done

(trap 'kill 0' SIGINT; eval ${commands[*]} wait)

# Generating custom playlists

# This simply generates the everything playlist which represents all the songs.

# More playlists coming soon...

playlist_keys=(${!playlists[@]})
eval "cat ${playlist_keys[@]//*/playlists\/&.m3u} > playlists/everything.m3u"

# Slowing down balatro tracks

# I wanted to sequence this, however, I couldn't get this to work for whatever reason, it seemed to hang. It's only 5 tracks though, so it's not really a big issue.

# Tracks are slowed down to 75% of of their original speed, just like in the game.

handle_balatro () {
    mkdir -p "pool/tmp"
    cd "pool/tmp"
    echo "$1"
    yt-dlp -x --audio-quality 0 --audio-format opus --restrict-filenames -o '%(title)s' "${playlists[$1]}";
    balatro_list=($(ls))
    for track in ${balatro_list[@]}; do
	  echo "track: ($track)"
	  ffmpeg -y -i "$track" -strict -2 -filter:a "atempo=0.75" -vn "../$track"
    done

    cd "../.."
    rm "pool/tmp" -r
}

# Downloading all the playlist songs in parallel

# Again, I sequence operations, then run them all at once.

commands=()

for playlist_key in ${!playlists[@]}; do
    if [ "balatro" = "$playlist_key" ]; then
	  commands+=("echo \"Handling balatro\" & handle_balatro \"$playlist_key\" & ")
    else
	  commands+=("echo \"Downloading: \"$playlist_key\"\" & yt-dlp -x --audio-quality 0 --audio-format opus --restrict-filenames -o 'pool/%(title)s' \"${playlists[$playlist_key]}\" &")
    fi
done;

(trap 'kill 0' SIGINT; eval ${commands[*]} wait)
