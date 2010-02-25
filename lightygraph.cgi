#!/usr/bin/perl -w

# lightygraph -- a lighttpd statistics rrdtool frontend
# copyright (c) 2008 Joe Nahmias <joe@nahmias.net>
# based on mailgraph by David Schweikert <dws@ee.ethz.ch>
# released under the GNU General Public License

use RRDs;
use POSIX qw(uname);

my $VERSION = "0.50";

my $host = (POSIX::uname())[1];
my $scriptname = 'lightygraph';
my $xpoints = 600;
my $ypoints = 350;
my $rrd = '/var/www/lighttpd.rrd';   # path to where the RRD database is
my $tmp_dir = '/var/cache/lighttpd'; # temporary directory where to store the images

my @graphs = (
	{ title => 'Last 4 Hours',   seconds => 60 * 60 *  4     ,   },
	{ title => 'Daily Graphs',   seconds => 60 * 60 * 24     ,   },
	{ title => 'Monthly Graphs', seconds => 60 * 60 * 24 * 30,   },
);

my %color = (         # rrggbb in hex
	areamin     => 'ffffff',
	instack     => 'f00000',
	minmax      => 'a0a0a0',
	incoming    => 'efb71d', 
	outstack    => '00f000',
	outgoing    => 'a0a735',
	reqstack    => '00f000',
	requests    => '00a735',
);

sub rrd_graph(@)
{
	my ($range, $file, $ypoints, @rrdargs) = @_;
	# choose carefully the end otherwise rrd will maybe pick the wrong RRA:
	my $date = localtime(time);
	$date =~ s|:|\\:|g unless $RRDs::VERSION < 1.199908;

	my ($graphret,$xs,$ys) = RRDs::graph($file,
		'--imgformat', 'PNG',
		'--width', $xpoints,
		'--height', $ypoints,
		'--start', "-$range",
		'--lazy',

		@rrdargs,

		'COMMENT:['.$date.']\r',
	);

	my $ERR=RRDs::error;
	die "ERROR: $ERR\n" if $ERR;
}

sub graph_traffic($$)
{
	my ($range, $file) = @_;
	rrd_graph($range, $file, $ypoints,

            "-v bytes",
	    "-t TrafficWebserver",
            "DEF:binraw=$rrd:InOctets:AVERAGE",
            "DEF:binmaxraw=$rrd:InOctets:MAX",
            "DEF:binminraw=$rrd:InOctets:MIN",
            "DEF:bout=$rrd:OutOctets:AVERAGE",
            "DEF:boutmax=$rrd:OutOctets:MAX",
            "DEF:boutmin=$rrd:OutOctets:MIN",
            "CDEF:bin=binraw,-1,*",
            "CDEF:binmax=binmaxraw,-1,*",
            "CDEF:binmin=binminraw,-1,*",
            "CDEF:binminmax=binmaxraw,binminraw,-",
            "CDEF:boutminmax=boutmax,boutmin,-",
            "AREA:binmin#$color{areamin}:",
            "STACK:binmax#$color{instack}:",
            "LINE1:binmin#$color{minmax}:",
            "LINE1:binmax#$color{minmax}:",
            "LINE2:bin#$color{incoming}:incoming",
            "GPRINT:bin:MIN:%.2lf",
            "GPRINT:bin:AVERAGE:%.2lf",
            "GPRINT:bin:MAX:%.2lf",
            "AREA:boutmin#$color{areamin}:",
            "STACK:boutminmax#$color{outstack}:",
            "LINE1:boutmin#$color{minmax}:",
            "LINE1:boutmax#$color{minmax}:",
            "LINE2:bout#$color{outgoing}:outgoing",
            "GPRINT:bout:MIN:%.2lf",
            "GPRINT:bout:AVERAGE:%.2lf",
            "GPRINT:bout:MAX:%.2lf",
	);
}

sub graph_requests($$)
{
	my ($range, $file) = @_;
	rrd_graph($range, $file, $ypoints,
            "-v req",
	    "-t RequestsperSecond",
	    "-u 1",
            "DEF:req=$rrd:Requests:AVERAGE",
            "DEF:reqmax=$rrd:Requests:MAX",
            "DEF:reqmin=$rrd:Requests:MIN",
            "CDEF:reqminmax=reqmax,reqmin,-",
            "AREA:reqmin#$color{areamin}:",
            "STACK:reqminmax#$color{reqstack}:",
            "LINE1:reqmin#$color{minmax}:",
            "LINE1:reqmax#$color{minmax}:",
            "LINE2:req#$color{requests}:requests",
	);
}

sub print_html()
{
	print "Content-Type: text/html\n\n";

	print <<HEADER;
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">
<HTML>
<HEAD>
<TITLE>Webserver Statistics for $host</TITLE>
<META HTTP-EQUIV="Refresh" CONTENT="300">
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
</HEAD>
<BODY BGCOLOR="#FFFFFF">
HEADER

	print "<H1>WebServer Statistics for $host</H1>\n";
	for my $n (0..$#graphs) {
		print '<div style="background: #dddddd; width: 632px">';
		print "<H2>$graphs[$n]{title}</H2>\n";
		print "</div>\n";
		print "<P><IMG BORDER=\"0\" SRC=\"$scriptname.cgi?${n}-t\" ALT=\"$scriptname\">\n";
		print "<P><IMG BORDER=\"0\" SRC=\"$scriptname.cgi?${n}-r\" ALT=\"$scriptname\">\n";
	}

	print "</BODY></HTML>\n";
}

sub send_image($)
{
	my ($file)= @_;

	-r $file or do {
		print "Content-type: text/plain\n\nERROR: can't find $file\n";
		exit 1;
	};

	print "Content-type: image/png\n";
	print "Content-length: ".((stat($file))[7])."\n";
	print "\n";
	open(IMG, $file) or die;
	my $data;
	print $data while read(IMG, $data, 16384)>0;
}

sub main()
{
	my $uri = $ENV{REQUEST_URI} || '';
	$uri =~ s/\/[^\/]+$//;
	$uri =~ s/\//,/g;
	$uri =~ s/(\~|\%7E)/tilde,/g;
	mkdir $tmp_dir, 0777 unless -d $tmp_dir;

	my $img = $ENV{QUERY_STRING};
	if(defined $img and $img =~ /\S/) {
		if($img =~ /^(\d+)-t$/) {
			my $file = "$tmp_dir/${scriptname}_traffic_$1.png";
			graph_traffic($graphs[$1]{seconds}, $file);
			send_image($file);
		}
		elsif($img =~ /^(\d+)-r$/) {
			my $file = "$tmp_dir/${scriptname}_requests_$1.png";
			graph_requests($graphs[$1]{seconds}, $file);
			send_image($file);
		}
		else {
			die "ERROR: invalid argument\n";
		}
	}
	else {
		print_html;
	}
}

main;
