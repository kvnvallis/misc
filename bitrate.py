#!/usr/bin/env python
# Calculate target bitrate to fit files on disc

# NOTE: Two-pass encoding will only produce approximate file size, so leave
# yourself some room. Subtract 100 from the target bitrate before passing it to
# ffmpeg.

# Useage:
#
#    $ python -i myscript.py 
#    Target bitrate: 4034.857142857143
#    >>> durations=[(30,0)] * 5
#    >>> main()
#    Target bitrate: 3736.0000000000005
#
# Optionally check percentages and file sizes
#
#    >>> durations = [(44,11),(15,0),(58,0),(29,5)]
#    >>> main()
#    Target bitrate: 3842.7930720145855
#    >>> calc_percent()
#    [0.302073837739289, 0.10255241567912489, 0.39653600729261623, 0.19883773928896992]
#    >>> dvd_size()
#    [1421.8615542388332, 482.7142206016409, 1866.4949863263446, 935.9292388331814]


# audio bitrate in kbps for output file
# recommended 224k for dvd 2 channel audio, 448k 5.1 channel
abr = 448

# play time for all files on disc in (minutes, seconds)
durations = [(46,37), (28,19), (26,35), (38,16), (43,30)]

# for files of the same duration
#durations = [(23,23)] * 7


def to_kilobits(megabytes):
    return megabytes * 8000

def to_seconds(time_tuple):
    """minutes to seconds plus remaining seconds"""
    minutes = time_tuple[0]
    seconds = time_tuple[1]
    return minutes * 60 + seconds

def calc_bitrate(kilobits, duration):
    return kilobits / duration

def target_bitrate(mb, dur, abr):
    duration = to_seconds(dur)
    file_size = to_kilobits(mb)
    audio_size = duration * abr
    video_size = file_size - audio_size
    print("Target bitrate:", 
        calc_bitrate(video_size, duration)
    )

def calc_percent():
    dur_seconds = [ to_seconds(dur) for dur in durations ]
    total = sum(dur_seconds)
    return [ dur / total for dur in dur_seconds ]

def dvd_size():
    """List of file sizes in megabytes"""
    percentages = calc_percent()
    return [ 4707 * perc for perc in percentages ]

def main():
    sizes = dvd_size()
    # index used for dur and mb must be the same
    index = 0
    # duration of file used to calculate bitrate
    dur = durations[index]
    # target size of video in megabytes
    mb = sizes[index]
    target_bitrate(mb, dur, abr)

main()
