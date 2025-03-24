# Playlists

# This is how I associate youtube's playlist ID's to easily rememberable playlist file names.

playlists=(
    PLEITERw4PaKFs_uS0MoXkIfGbsYJHmWVU:balatro.m3u
    PLY9u9wC7ApRJk-tG4_pBtH6ubEJ7svnOB:celeste.m3u
    PLmOldskd2VbL7_t-NE9p6rEboq_v0AHko:hollow_knight.m3u
    PLbJE2f8Bl_gRq7g69Z4xfHV7Je-WWvpdJ:terraria.m3u
    PLsuCmTriuYXdOYZVaKyex5lIy3lT9K_PW:calamity.m3u
    PLfA6eOuWprRO33noGigJRXO1WXbkfmIlV:calamity_infernum.m3u
    PLMoZgWjm14OF2AWFfPc3cyQH7T2SC89jo:baba.m3u
    PLEUKcNuP7bDX9RoW3HqYR6EFvWZh12upZ:deltarune.m3u
    PLpJl5XaLHtLX-pDk4kctGxtF4nq6BIyjg:undertale.m3u
    PLhPp-QAUKF_iiixYtOGmynw-BMEju-EWo:isaac_rebirth.m3u
    PLhPp-QAUKF_gJ9eB-wSlfliMT_6ymDuiI:isaac_afterbirth.m3u
    PL_sXFbaP261h0WAWyJWKHbLa_haABQHBt:isaac_repentance.m3u
    PLrWR7klg98H0DbavfBz66OJO_E3wxKVSZ:isaac_antibirth.m3u
    PLNG8gFz9vUpsLXnWdCEf0svaFEfbY-kHh:minecraft.m3u
    PLyfXx1BeqwFbl5jg6swxk1XonI-4ldG9X:stardew_valley.m3u
    PLKDOdCjxOjzL6dnS9DsU4aNYU0ignNtWD:cassette_beasts.m3u
    PLTsWV3v1dCwpsDgjj2MLiBugQGH_H8D09:RoA.m3u
    PLHVUN_wezMf9LHGahDuuIiPlog4LI9J8k:rhythm_doctor.m3u
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

cat celeste.m3u hollow_knight.m3u terraria.m3u calamity_infernum.m3u baba.m3u deltarune.m3u undertale.m3u isaac_rebirth.m3u isaac_afterbirth.m3u isaac_repentance.m3u isaac_antibirth.m3u minecraft.m3u stardew_valley.m3u cassette_beasts.m3u RoA.m3u rhythm_doctor.m3u > playlist/everything.m3u

# Slowing down balatro tracks

# I wanted to sequence this, however, I couldn't get this to work for whatever reason, it seemed to hang. It's only 5 tracks though, so it's not really a big issue.

# Tracks are slowed down to 75% of of their original speed, just like in the game.

handle_balatro () {
    mkdir -p "pool/tmp"
    cd "pool/tmp"
    echo "$(echo ${1##:*})"
    yt-dlp -x --audio-quality 0 --restrict-filenames -o '%(title)s' "$(echo ${1##:*})";
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
	commands+=("echo \"Downloading: $(echo ${playlist_item##:*})\" & yt-dlp -x --audio-quality 0 --restrict-filenames -o 'pool/%(title)s' \"$(echo ${playlist_item##:*})\" &")
    fi
done;

(trap 'kill 0' SIGINT; eval ${commands[*]} wait)
