From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [Announce] sg3_utils-1.33 available
Date: Thu, 19 Jan 2012 13:52:40 -0500
Message-ID: <4F186678.9010303@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:49992 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932454Ab2ASSwt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Jan 2012 13:52:49 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>
Cc: =?ISO-8859-1?Q?Dan_Hor=E1k?= <dhorak@redhat.com>, Ritesh Raj Sarraf <rrs@researchut.com>, "Robin H. Johnson" <robbat2@gentoo.org>, Martin Pitt <mpitt@debian.org>, linux-kernel <linux-kernel@vger.kernel.org>, ronnie sahlberg <ronniesahlberg@gmail.com>

sg3_utils is a package of command line utilities for sending
SCSI and some ATA commands to devices. This package targets
the linux kernel (lk) 2.6 and lk 2.4 series. It also has
ports to FreeBSD, Tru64, Solaris, and Windows (cygwin and mingw).

This version reworks the sg_ses utility again. Real world testing
has shown up many shortcomings in the sg_ses code plus there are
plenty of (partially) broken SES device out there, some of which
can now be handled. This version tracks various changes made by
www.t10.org since July 2011.

For an overview of sg3_utils and downloads see this page:
     http://sg.danny.cz/sg/sg3_utils.html
A new page has been added to describe the latest rework of
the sg_ses utility (for enclosure devices):
     http://sg.danny.cz/sg/sg_ses.html
The SG_IO ioctl is discussed at:
     http://sg.danny.cz/sg/sg_io.html
A full changelog can be found at:
     http://sg.danny.cz/sg/p/sg3_utils.ChangeLog

A release announcement will be sent to freshmeat.net .

Changelog for sg3_utils-1.33 [20120118] [svn: r435]
   - sg_ses: major rework of indexes (again), now two level
   - sg_write_buffer: new --specific option for mode specific
     field; new mode 13 (spc4r32)
   - sg_vpd: add hp3par volume info vendor VPD page
     - fix 'scsi ports' [0x88] page problem
     - add 'sinq' pseudo page for standard inquiry response
     - add power consumption page
   - sg_format: add --poll= option for request sense polling
     - improve handling of disks > 2 TB and DIF (protection)
   - sg_logs: LB provision lpage extra (sbc3r28)
   - sg_modes: application tag mpage subcode 0xf0->0x2
   - sg_write_same: no prot fields when wrprotect=0
   - sg_get_lba_status: reflect change in sbc3r25 to Parameter
     Data Length response field (offset reduced from 8 to 4)
   - sg_inq, sg_vpd: sync with spc4r33
   - win32: change DataBufferOffset type per MSDN; caused
     problem with 64 bit machines (with buffered interface)
   - sg_luns: tweak documentation for vendor specific reports
   - add man pages for scsi_loging_level, scsi_mandat,
     scsi_satl and scsi_temperature

Changelog for sg3_utils-1.32 [20110730] [svn: r410]
   ...

Doug Gilbert
