#!/usr/bin/python
"""
Convert rmvb files to avi using mencoder.
Copyright (C) 2009  Andres Moreira

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
"""
import os
from optparse import OptionParser

class AudioCodecNotSupported(Exception):
    """Exception for handle audio codec not supported for this script."""
    pass
    
class VideoCodecNotSupported(Exception):
    """Exception for handle video codec not supported for this script."""
    pass

ENCODER = "mencoder"
CONTAINER = 'avi'

def get_audio_options(type, quality='normal'):
    """create audio options for mencoder from more simple ones"""

    quality = 'extreme' if quality =='high' else 'standard'
    codec = ''
    codec_options = ''
    if type == 'mp3':
        codec = 'mp3lame' #lame encoder
        codec_options = '-lameopts preset=%s' % quality
    elif type == 'pcm':
        codec = 'pcm'
    else:
        raise AudioCodecNotSupported("audio codec %s not supported." % type)

    if codec_options:
        return "-oac %s %s" % (codec, codec_options)
    else:
        return "-oac %s" % codec

def get_video_options(type, quality='normal', norm=None):
    """create video options for mencoder from more simple ones"""
    codec = ''
    codec_options = ''
    if type == 'divx':
        codec = 'lavc'
        if quality == 'normal':
            codec_options = '-lavcopts vcodec=mpeg4 -ffourcc DX50 -mc 0 -noskip'
        elif quality == 'high':
            codec_options = "-lavcopts"
            codec_options += " vcodec=mpeg4:vbitrate=1200:mbd=2:trell:v4mv"
            codec_options += " -ffourcc DX50 -mc 0 -noskip"
        else:
            codec_options = '-lavcopts vcodec=mpeg4 -ffourcc DX50 -mc 0 -noskip'
    elif type == 'xvid':
        codec = 'xvid'
        if quality == 'normal':
            codec_options = '-xvidencopts bitrate=1200'
        elif quality == 'high':
            codec_options = '-xvidencopts bitrate=1200:'
            codec_options += 'chroma_opt:vhq=4:bvhq=1:quant_type=mpeg'
        else:
            codec_options = '-xvidencopts bitrate=1200'
    else:
        raise VideoCodecNotSupported("video codec %s not supported." % type)

    if norm == 'pal':
        fps = '-ofps 25'
    elif norm == 'ntsc':
        fps = '-ofps 30000/1001'
    else:
        fps = ''
    if codec_options and fps:
        return "-ovc %s %s %s" % (codec, codec_options, fps)
    elif codec_options:
        return "-ovc %s %s" % (codec, codec_options)
    else:
        return "-ovc %s" % (codec)

def get_command(filename, video_type='xvid', video_options=None, 
                audio_type='mp3', audio_options=None, outputfile=None):
    """
    Returns a mencoder command from given the options in the arguments.
    """

    video_options = video_options or {'quality':'high'}
    audio_options = audio_options or {'quality':'high'}
    audio_args = get_audio_options(audio_type, **audio_options)
    video_args = get_video_options(video_type, **video_options)
    if not outputfile:
        ofname = os.path.basename(filename)
        ofname = ofname[:ofname.rindex('.')]
        outputfile = "%s.%s" % (ofname, CONTAINER)

    output_arg_file = "-o %s" % outputfile
    output_container_file = "-of %s" % CONTAINER
    output_args = '%s %s' % (output_container_file, output_arg_file)
    sprog =  "%s %s %s %s" % (filename, audio_args, video_args, output_args)
    return sprog


def main():
    """main program
    
    get the options from command line and convert it to mencoder fromat, 
    then execute mencoder with that options.
    
    python process will be replaced with the mencoder one."""
    
    description = "Convert rmvb files to avi using mencoder."
    parser = OptionParser(usage="%prog [options] inputfile", 
                          description=description)
    parser.add_option("--vf", metavar="FORMAT", 
                      default="xvid",
                      help="output video format. Options: xvid, divx")

    parser.add_option("--vq", metavar="QUALITY", 
                      default="high",
                      help="output video quality. Options: normal, high")

    parser.add_option("--af", metavar="FORMAT", 
                      default="mp3",
                      help="output audio format. Options: mp3, pcm")

    parser.add_option("--aq", metavar="QUALITY", 
                      default="high",
                      help="output audio quality. Options: normal, high")

    parser.add_option("--fps", metavar="FPS", 
                      default='default',
                      help="frames per second. Options: default, pal, ntsc")

    parser.add_option("-o", "--output", metavar="FILE",
                      help="output file")

    options, args = parser.parse_args()

    if args:
        filename = args[0]
        vtype = options.vf
        vopts = {
            'quality' : options.vq,
            'norm' : options.fps
        }
        atype = options.af
        aopts = {
            'quality' : options.aq
        }
        
        args = get_command(filename, vtype, vopts, atype, aopts, options.output)

        print "mencoder will be executed in this way:"
        print "  => %s %s" % (ENCODER, args)

        os.execvp(ENCODER, tuple([ENCODER] + args.split()))
    else:
        parser.print_help()
        return

if __name__ == '__main__':
    main()




