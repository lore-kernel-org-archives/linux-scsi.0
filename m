From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [Announce] sg3_utils-1.30 available
Date: Fri, 12 Nov 2010 09:01:07 -0500
Message-ID: <4CDD48A3.7030506@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:56545 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932094Ab0KLOBV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Nov 2010 09:01:21 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>
Cc: =?ISO-8859-1?Q?Dan_Hor=E1k?= <dhorak@redhat.com>, Ritesh Raj Sarraf <rrs@researchut.com>, "Robin H. Johnson" <robbat2@gentoo.org>, Martin Pitt <mpitt@debian.org>, linux-kernel <linux-kernel@vger.kernel.org>

sg3_utils is a package of command line utilities for sending
SCSI and some ATA commands to devices. This package targets
the linux kernel (lk) 2.6 and lk 2.4 series. It also has
ports to FreeBSD, Tru64, Solaris, and Windows (cygwin and mingw).

This version tracks various changes made by www.t10.org
since April 2010. Note that "thin provisioning" has been
renamed to "logical block provisioning". There is a copy of
ChangeLog below.

For an overview of sg3_utils and downloads see this page:
     http://sg.danny.cz/sg/sg3_utils.html
The sg_dd utility has its own page at:
     http://sg.danny.cz/sg/sg_dd.html
The SG_IO ioctl is discussed at:
     http://sg.danny.cz/sg/sg_io.html
A full changelog can be found at:
     http://sg.danny.cz/sg/p/sg3_utils.ChangeLog

A release announcement will be sent to freshmeat.net .

Changelog for sg3_utils-1.30 [20101111] [svn: r363]
   - sg_referrals: new utility for REPORT REFERRALS
   - sbc3r25 renames 'thin' provisioning' to 'logical block
     provisioning': changes in sg_format, sg_inq, sg_logs,
     sg_modes, sg_readcap, sg_vpd
   - sg_inq: update version descriptor list to spc4r27
     - extended inquiry vpd page add extended self test
       completion minutes field
   - sg_lib: sync asc/ascq list to spc4r27
     - dStrHex(): trim excess trailing spaces
   - sg_read_long: add --readonly option (open() is rw)
   - sg_raw: add --readonly option (open() is rw)
     - allow bidirectional commands
   - sg_vpd: rdac vendor page [0xc8] parse corrections
     - extended inquiry vpd page add extended self test
       completion minutes field
   - sg_ses: expand --date (in) buffer to 2048 bytes
   - sg_opcodes: add extended parameter data for TMFs (spc4r26)
   - sg_dd: clean count calculation, document nocache flag
     - treat bsg devices as implicit sg_io
   - sg_write_same: if READ CAPACITY(16) fails try 10 byte variant
     - anticipate approval of proposal to allow UNMAP and ANCHOR
       bits to be set on WRITE SAME(10) with '--10' option
   - sg3_utils man page: sections added for OS device names

Changelog for sg3_utils-1.29 [20100406] [svn: r334]
...

Doug Gilbert
