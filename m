From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [Announce] sg3_utils-1.35 available
Date: Fri, 18 Jan 2013 00:25:21 -0500
Message-ID: <50F8DCC1.8030602@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>
Cc: =?ISO-8859-1?Q?Dan_Hor=E1k?= <dhorak@redhat.com>, Ritesh Raj Sarraf <rrs@researchut.com>, "Robin H. Johnson" <robbat2@gentoo.org>, Martin Pitt <mpitt@debian.org>, linux-kernel <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Kay Sievers <kay.sievers@vrfy.org>, "shahar.salzman@kaminario.com" <shahar.salzman@kaminario.com>
List-Id: linux-scsi@vger.kernel.org

sg3_utils is a package of command line utilities for sending
SCSI and some ATA commands to devices. This package targets
the linux kernel (lk) 3, 2.6 and lk 2.4 series. It also has
ports to FreeBSD, Tru64, Solaris, and Windows (cygwin and mingw).

This version adds sg_compare_and_write (contributed by
Shahar Salzman). Also Hannes Reinecke has done more work on
'sg_inq --export' to support udev. This version tracks various
changes made by www.t10.org since October 2012.

For an overview of sg3_utils and downloads see this page:
     http://sg.danny.cz/sg/sg3_utils.html
The sg_ses utility (for enclosure devices) is discussed at:
     http://sg.danny.cz/sg/sg_ses.html
The SG_IO ioctl is discussed at:
     http://sg.danny.cz/sg/sg_io.html
A full changelog can be found at:
     http://sg.danny.cz/sg/p/sg3_utils.ChangeLog

A release announcement will be sent to freecode.com .

Changelog for sg3_utils-1.35 [20130117] [svn: r476]
   - sg_compare_and_write: new utility
   - sg_inq+sg_vpd: block device characteristics VPD page:
     add product_type, WABEREQ, WACEREQ and VBULS fields
   - sg_inq: more --export option changes for udev
   - sg_vpd: add more rdac vendor specific vpd pages
   - sg_verify: add --ebytchk option for sbc3r34 changes
   - sg_stpg: --offline option: fix 'Invalid state 0xe'
   - sg_ses: Door Lock element changed to Door element and
     abbreviation changed from 'dl' to 'do' (ses3r05)
   - archive/rescan-scsi-bus.sh: upgrade to version 1.53hr
     - move rescan-scsi-bus.sh to scripts directory
   - sync to sbc3r34
   - sg_lib: sg_ll_verify10+16 expand BYTCHK to 2 bit field
   - sg_pt_win32, sg_scan(win32): changes for cygwin 1.7.17
   - clean up man page summary lines

Changelog for sg3_utils-1.34 [20121013] [svn: r461]
...

Doug Gilbert
