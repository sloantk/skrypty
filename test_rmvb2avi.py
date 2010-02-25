from unittest import TestCase
from rmvb2avi import get_command

OUTPUT1 = 'file.rmvb -oac mp3lame -lameopts preset=extreme -ovc xvid -xvidencopts bitrate=1200:chroma_opt:vhq=4:bvhq=1:quant_type=mpeg -of avi -o file.avi'
OUTPUT2 = 'file.rmvb -oac mp3lame -lameopts preset=extreme -ovc xvid -xvidencopts bitrate=1200:chroma_opt:vhq=4:bvhq=1:quant_type=mpeg -ofps 25 -of avi -o file.avi'
OUTPUT3 = 'file.rmvb -oac mp3lame -lameopts preset=extreme -ovc xvid -xvidencopts bitrate=1200 -ofps 30000/1001 -of avi -o file.avi'
OUTPUT4 = 'file.rmvb -oac mp3lame -lameopts preset=standard -ovc xvid -xvidencopts bitrate=1200:chroma_opt:vhq=4:bvhq=1:quant_type=mpeg -of avi -o file.avi'
OUTPUT5 = 'file.rmvb -oac mp3lame -lameopts preset=standard -ovc xvid -xvidencopts bitrate=1200:chroma_opt:vhq=4:bvhq=1:quant_type=mpeg -ofps 25 -of avi -o file.avi'
OUTPUT6 = 'file.rmvb -oac mp3lame -lameopts preset=standard -ovc xvid -xvidencopts bitrate=1200:chroma_opt:vhq=4:bvhq=1:quant_type=mpeg -ofps 30000/1001 -of avi -o file.avi'
OUTPUT7 = 'file.rmvb -oac mp3lame -lameopts preset=extreme -ovc lavc -lavcopts vcodec=mpeg4:vbitrate=1200:mbd=2:trell:v4mv -ffourcc DX50 -mc 0 -noskip -of avi -o file.avi'
OUTPUT8 = 'file.rmvb -oac mp3lame -lameopts preset=extreme -ovc lavc -lavcopts vcodec=mpeg4:vbitrate=1200:mbd=2:trell:v4mv -ffourcc DX50 -mc 0 -noskip -ofps 25 -of avi -o file.avi'
OUTPUT9 = 'file.rmvb -oac mp3lame -lameopts preset=extreme -ovc lavc -lavcopts vcodec=mpeg4 -ffourcc DX50 -mc 0 -noskip -ofps 30000/1001 -of avi -o file.avi'
OUTPUT10 = 'file.rmvb -oac pcm -ovc xvid -xvidencopts bitrate=1200:chroma_opt:vhq=4:bvhq=1:quant_type=mpeg -of avi -o file.avi'

class Rmvb2aviTestCase(TestCase):

    def test_get_command(self):
        self.assertEquals(get_command('file.rmvb'), OUTPUT1)
        self.assertEquals(get_command('file.rmvb', video_options={'quality':'high', 'norm':'pal'}), OUTPUT2)
        self.assertEquals(get_command('file.rmvb', video_options={'quality':'normal', 'norm':'ntsc'}), OUTPUT3)
        self.assertEquals(get_command('file.rmvb', audio_options={'quality':'normal'}), OUTPUT4)
        self.assertEquals(get_command('file.rmvb', video_options={'quality':'high', 'norm':'pal'}, audio_options={'quality':'normal'}), OUTPUT5)
        self.assertEquals(get_command('file.rmvb', video_options={'quality':'high', 'norm':'ntsc'}, audio_options={'quality':'normal'}), OUTPUT6)
        self.assertEquals(get_command('file.rmvb', video_type='divx'), OUTPUT7)
        self.assertEquals(get_command('file.rmvb', video_type='divx', video_options={'quality':'high', 'norm':'pal'}), OUTPUT8)
        self.assertEquals(get_command('file.rmvb', video_type='divx', video_options={'quality':'normal', 'norm':'ntsc'}), OUTPUT9)
        self.assertEquals(get_command('file.rmvb', audio_type='pcm'), OUTPUT10)
