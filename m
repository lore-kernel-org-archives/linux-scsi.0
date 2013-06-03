From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [Announce] sg3_utils-1.36 available
Date: Sun, 02 Jun 2013 23:38:32 -0400
Message-ID: <51AC0FB8.8000908@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:36214 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750889Ab3FCDir (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 2 Jun 2013 23:38:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>
Cc: =?ISO-8859-1?Q?Dan_Hor=E1k?= <dhorak@redhat.com>, Ritesh Raj Sarraf <rrs@researchut.com>, "Robin H. Johnson" <robbat2@gentoo.org>, Martin Pitt <mpitt@debian.org>, linux-kernel <linux-kernel@vger.kernel.org>

sg3_utils is a package of command line utilities for sending
SCSI and some ATA commands to devices. This package targets
the Linux 3, 2.6 and 2.4 kernel series. It also has ports to
FreeBSD, Tru64, Solaris, and Windows (cygwin and mingw).

Mainly small changes and fixes in this version including
several contributed additions to sg_xcopy. There is also
improved handling of 64 bit LUNs which may facilitate full
64 bit LUN support being added to the Linux kernel. This
version tracks various changes made by www.t10.org since
January 2013.

For an overview of sg3_utils and downloads see this page:
     http://sg.danny.cz/sg/sg3_utils.html
The sg_ses utility (for enclosure devices) is discussed at:
     http://sg.danny.cz/sg/sg_ses.html
The SG_IO ioctl is discussed at:
     http://sg.danny.cz/sg/sg_io.html
A full changelog can be found at:
     http://sg.danny.cz/sg/p/sg3_utils.ChangeLog

A release announcement will be sent to freecode.com .

Changelog for sg3_utils-1.36 [20130531] [svn: r497]
   - sg_vpd: Protocol-specific port information VPD page
     for SAS SSP, persistent connection (spl3r2), power
     disable (spl3r3)
     - block device characteristics: add FUAB bit
   - sg_xcopy: handle more descriptor types; handle zero
     maximum segment length; allow list IDs to be disabled;
     improve skip/seek handling; allow xcopy on destination
   - sg_reset: and --no-esc option to stop reset escalation
     - clean up cli, add long option names
   - sg_luns: add --test=ALUN option for decoding LUNs
     - decoded luns output in decimal or hex (if -HH given)
     - add '--linux' option to show Linux LUN after T10
       representation, can map one to the other
   - sg_inq: add --vendor option to show standard inquiry's
     vendor specific fields in ASCII
     - take resid into account with response output
   - sg_sync: add --16 (for 16 byte command) and --timeout=
   - sg_logs: add data compression page (ssc4)
   - sg_sat_set_features: increase --lba from 1 to 4 bytes
   - sg_write_same: add --ndob option (sbc3r35d)
   - sg_map: mark as deprecated
   - sginfo: mark as deprecated, especially -l (list)
   - sg_lib: improve snprintf handling
   - sg_lib_data: sync asc/ascq codes with T10 20130117
   - sg_cmds (lib): if noisy given, give more UA info
   - make code more C++ friendly

Changelog for sg3_utils-1.35 [20130117] [svn: r476]
...

Doug Gilbert
