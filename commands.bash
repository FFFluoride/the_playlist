# Playlists

# This is how I associate youtube's playlist ID's to easily rememberable playlist file names.

playlists=(
    PLEITERw4PaKFs_uS0MoXkIfGbsYJHmWVU:balatro.m3u
    PLyfXx1BeqwFbnI87AyqLP5XcEg1u5kydi:celeste.m3u
    PLyfXx1BeqwFZXtJPE153jA-8NJWz579Pb:hollow_knight.m3u
    PLyfXx1BeqwFYFwnXDZo6xYSIsek2x2fhp:silksong.m3u
    PLyfXx1BeqwFb9eMbR78HzJtvhAuGH2rnc:terraria.m3u
    PLyfXx1BeqwFY7_xMkP9BCAogmUQbwFBjc:calamity.m3u
    PLyfXx1BeqwFb0IcIT2_cbShbguqGOvnaq:calamity_infernum.m3u
    PLyfXx1BeqwFaO6xFIQXFhQTJtFdP4WYyc:baba.m3u
    PLyfXx1BeqwFakIcMEOb5L3hLLuTWHZhFv:deltarune.m3u
    PLyfXx1BeqwFZoI5JKqSOCYTq9_fxIqPPc:undertale.m3u
    PLyfXx1BeqwFYwjv_IHypwL_QeR4IT4rW_:isaac_rebirth.m3u
    PLyfXx1BeqwFYEsmSq2YcXYfPoSxhqUdKj:isaac_afterbirth.m3u
    PLyfXx1BeqwFYukH-L7NXfhom6UPaSb33N:isaac_repentance.m3u
    PLyfXx1BeqwFZfbk9ksALFm-Q6hmQPacQ1:isaac_antibirth.m3u
    PLyfXx1BeqwFZ3paVLhJwsHpuWM4zlhLPj:minecraft.m3u
    PLyfXx1BeqwFYtf2Dntv405dH8I9FP5GcV:stardew_valley.m3u
    PLyfXx1BeqwFZw1-JcUkkxHcodnwr_W6Nd:cassette_beasts.m3u
    PLyfXx1BeqwFYNtQ2sBVUvZ0_PUYvGLe_x:RoA.m3u
    PLyfXx1BeqwFYvPfUFBjkZvmpFYFbSJQ2R:rhythm_doctor.m3u
    PLyfXx1BeqwFbcG-8eBmiIbmDtNmn4tq2H:luck_be_a_landlord.m3u
    PLyfXx1BeqwFZcwV_yqpe5khtlKWGf0jM_:anime.m3u
    PLyfXx1BeqwFZzRwmxQ1To7HQN37pj1EAs:misc.m3u
)

# Generating the playlist files concurrently

# This is pretty gnarly by my standards.
# Basically, you make an array to sequence commands by looping once and then running the long running tasks in parallel by launching multiple subshells and using '&'.

# It's important that this runs in a subshell or else ctrl-c wouldn't kill all the processes.

commands=()

mkdir playlists

for playlist_item in ${playlists[@]}; do
    commands+=("echo \"Generating $(echo ${playlist_item##*:})\" & yt-dlp --restrict-filenames -o '../pool/%(title)s.opus' --get-filename \" \$(echo ${playlist_item##:*})\" > \"$(echo playlists/${playlist_item##*:})\" &")
done

(trap 'kill 0' SIGINT; eval ${commands[*]} wait)

# Generating custom playlists

# This simply generates the everything playlist which represents all the songs.

# More playlists coming soon...

cat playlists/celeste.m3u playlists/hollow_knight.m3u playlists/terraria.m3u playlists/calamity_infernum.m3u playlists/baba.m3u playlists/deltarune.m3u playlists/undertale.m3u playlists/isaac_rebirth.m3u playlists/isaac_afterbirth.m3u playlists/isaac_repentance.m3u playlists/isaac_antibirth.m3u playlists/minecraft.m3u playlists/stardew_valley.m3u playlists/cassette_beasts.m3u playlists/RoA.m3u playlists/rhythm_doctor.m3u > playlists/everything.m3u

# Slowing down balatro tracks

# I wanted to sequence this, however, I couldn't get this to work for whatever reason, it seemed to hang. It's only 5 tracks though, so it's not really a big issue.

# Tracks are slowed down to 75% of of their original speed, just like in the game.

handle_balatro () {
    mkdir -p "pool/tmp"
    cd "pool/tmp"
    echo "$(echo ${1##:*})"
    yt-dlp -x --audio-quality 0 --audio-format opus --restrict-filenames -o '%(title)s' "$(echo ${1##:*})";
    balatro_list="$(ls -1)"
    for track in $balatro_list; do
	echo "track: ($track)"
	ffmpeg -y -i "$track" -strict -2 -filter:a "atempo=0.75" -vn "../$track" &
    done

    cd "../.."
    rm "pool/tmp" -r
}

# Downloading all the playlist songs in parallel

# Again, I sequence operations, then run them all at once.

commands=()

for playlist_item in ${playlists[@]}; do
    if [ "balatro.m3u" = "$(echo ${playlist_item##*:})" ]; then
	commands+=("echo \"\" & handle_balatro \"$playlist_item\" &")
    else
	commands+=("echo \"Downloading: $(echo ${playlist_item##:*})\" & yt-dlp -x --audio-quality 0 --audio-format opus --restrict-filenames -o 'pool/%(title)s' \"$(echo ${playlist_item##:*})\" &")
    fi
done;

(trap 'kill 0' SIGINT; eval ${commands[*]} wait)
