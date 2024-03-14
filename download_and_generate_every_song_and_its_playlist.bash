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

for playlist_item in ${playlists[@]}; do
    echo "Generating $(echo ${playlist_item##*:})"
    yt-dlp --restrict-filenames -o 'pool/%(title)s.opus' --get-filename "$(echo ${playlist_item##:*})" > "$(echo ${playlist_item##*:})"
done

notify-send "Finished generating all playlists"

balatro_name="balatro.m3u"

for playlist_item in ${playlists[@]}; do
    if [ "$balatro_name" = "$(echo ${playlist_item##*:})" ]; then
	mkdir -p "pool/tmp"
	cd "pool/tmp"
	echo "$(echo ${playlist_item##:*})"
	yt-dlp -x --audio-quality 0 --restrict-filenames -o '%(title)s' "$(echo ${playlist_item##:*})";
	balatro_list="$(ls -1)"
	for track in $balatro_list; do
	    echo "track: ($track)"
	    ffmpeg -y -i "$track" -filter:a "atempo=0.75" -vn "../$track"
	done
	cd "../.."
	rm "pool/tmp" -rf
    else
	echo "Downloading: $(echo ${playlist_item##:*})"
	yt-dlp -x --audio-quality 0 --restrict-filenames -o 'pool/%(title)s' "$(echo ${playlist_item##:*})";
    fi
done;
