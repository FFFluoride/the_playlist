playlists=(
    PLY9u9wC7ApRJk-tG4_pBtH6ubEJ7svnOB:celeste.m3u
    PLmOldskd2VbL7_t-NE9p6rEboq_v0AHko:hollow_knight.m3u
    PLbJE2f8Bl_gRq7g69Z4xfHV7Je-WWvpdJ:terraria.m3u
    PLsuCmTriuYXdOYZVaKyex5lIy3lT9K_PW:calamity.m3u
    PLfA6eOuWprRO33noGigJRXO1WXbkfmIlV:calamity_infernum.m3u
    PLMoZgWjm14OF2AWFfPc3cyQH7T2SC89jo:baba.m3u
    PLEUKcNuP7bDX9RoW3HqYR6EFvWZh12upZ:deltarune.m3u
    PLpJl5XaLHtLX-pDk4kctGxtF4nq6BIyjg:undertale.m3u
    PLhPp-QAUKF_iiixYtOGmynw-BMEju-EWo:isaac_rebirth.m3u
    PLyfXx1BeqwFa91omolDHEBUUC2Ip8f0l_:isaac_afterbirth.m3u
    PL_sXFbaP261ituF7mOuSGHhfmn9G6GIwf:isaac_repentance.m3u
    PLrWR7klg98H0DbavfBz66OJO_E3wxKVSZ:isaac_antibirth.m3u
    PLefKpFQ8Pvy5aCLAGHD8Zmzsdljos-t2l:minecraft.m3u
    PLoku_1Va0MjwRzYb1yfBS3Ob5eyKbBi2p:stardew_valley.m3u
    PLKDOdCjxOjzL6dnS9DsU4aNYU0ignNtWD:cassette_beasts.m3u
    PLCPLpSD-PMt7l7ZYcdLgBVH7VqmL-VC07:RoA.m3u
    PLHVUN_wezMf9LHGahDuuIiPlog4LI9J8k:rhythm_doctor.m3u
)

for playlist_item in ${playlists[@]}; do
    yt-dlp --restrict-filenames -o 'pool/%(title)s.opus' --get-filename "$(echo ${playlist_item##:*})" > "$(echo ${playlist_item##*:})"
done

notify-send "Finished generating all playlists"