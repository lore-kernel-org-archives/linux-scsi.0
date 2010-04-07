From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [Announce] sg3_utils-1.29 available
Date: Tue, 06 Apr 2010 23:04:24 -0400
Message-ID: <4BBBF638.1090102@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:41819 "EHLO elrond.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752951Ab0DGDEd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Apr 2010 23:04:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>
Cc: =?ISO-8859-1?Q?Dan_Hor=E1k?= <dhorak@redhat.com>, Eric Schwartz <emschwar@debian.org>, "Robin H. Johnson" <robbat2@gentoo.org>, Martin Pitt <mpitt@debian.org>, linux-kernel <linux-kernel@vger.kernel.org>

sg3_utils is a package of command line utilities for sending
SCSI and some ATA commands to devices. This package targets
the linux kernel (lk) 2.6 and lk 2.4 series. Also included are
ports to FreeBSD, Tru64, Solaris, and Windows (cygwin and mingw).

This version tracks various changes made by www.t10.org
since October 2009. More thin provisioning support has
been added. There is a copy of ChangeLog below.

For an overview of sg3_utils and downloads see this page:
     http://sg.danny.cz/sg/sg3_utils.html
The sg_dd utility has its own page at:
     http://sg.danny.cz/sg/sg_dd.html
The SG_IO ioctl is discussed at:
     http://sg.danny.cz/sg/sg_io.html
A full changelog can be found at:
     http://sg.danny.cz/sg/p/sg3_utils.ChangeLog

A release announcement will be sent to freshmeat.net .

Changelog for sg3_utils-1.29 [20100406] [svn: r334]
   - sg_rtpg: new logical block dependent state and bit (spc4r23)
   - sg_start: add '--readonly' option for ATA disks
   - sg_lib: update asc/ascq list to spc4r23
   - sg_inq: update version descriptor list to spc4r23
   - sg_vpd: block device characteristics page: fix form factor
     - update Extended Inquiry VPD page to spc4r23
     - update Block Limits VPD page to sbc3r22
     - update Thin Provisioning VPD page to sbc3r22
     - Automation device serial number and Data transfer device
       element VPD pages (ssc4r01)
     - add Referrals VPD page (sbc3r22)
   - sg_logs: add thin provisioning and solid state media log pages
     - addition of IBM LTO specific log pages
   - sg_modes: new page names from ssc4r01
   - sg_ses: sync with ses3r02 (SAS-2.1 connector types)
   - sg_unmap: add '--anchor' option (sbc3r22)
   - sg_write_same: add '--anchor' option (sbc3r22)
   - sg_pt interface: add set_scsi_pt_flags() to permit passing
     through SCSI_PT_FLAGS_QUEUE_AT_TAIL and AT_HEAD flags
   - add examples/sg_queue_tst+bsg_queue_tst for SG_FLAG_Q_AT_TAIL
   - add AM_MAINTAINER_MODE to configure.ac to lessen build issues
   - add BSD_LICENSE file to this and lib directories, refer to
     it from source and header files. Some source has GPL license

Changelog for sg3_utils-1.28 [20091002] [svn: r315]
...

Doug Gilbert
