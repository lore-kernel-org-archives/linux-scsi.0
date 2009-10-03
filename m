From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [Announce] sg3_utils-1.28 available
Date: Fri, 02 Oct 2009 23:43:14 -0400
Message-ID: <4AC6C852.60400@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:58310 "EHLO elrond.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754475AbZJCDnS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Oct 2009 23:43:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>
Cc: =?ISO-8859-1?Q?Dan_Hor=E1k?= <dhorak@redhat.com>, Eric Schwartz <emschwar@debian.org>, "Robin H. Johnson" <robbat2@gentoo.org>, xiao li - Sun Microsystems - Beijing China <Xiao.L@Sun.COM>, Martin Pitt <mpitt@debian.org>, linux-kernel <linux-kernel@vger.kernel.org>

sg3_utils is a package of command line utilities for sending
SCSI and some ATA commands to devices. This package targets
the linux kernel (lk) 2.6 and lk 2.4 series. Also included are
ports to FreeBSD, Tru64, Solaris, and Windows (cygwin and mingw).

This version adds these utilities: sg_get_lba_status,
sg_read_block_limits and sg_unmap . Various changes made by
www.t10.org since April 2009 are reflected in this version.
A lot more thin provisioning support has been added. There
is a copy of ChangeLog below.

For an overview of sg3_utils and downloads see this page:
     http://sg.danny.cz/sg/sg3_utils.html
The sg_dd utility has its own page at:
     http://sg.danny.cz/sg/sg_dd.html
The SG_IO ioctl is discussed at:
     http://sg.danny.cz/sg/sg_io.html
A full changelog can be found at:
     http://sg.danny.cz/sg/p/sg3_utils.ChangeLog

A release announcement will be sent to freshmeat.net .

Changelog for sg3_utils-1.28 [20091002] [svn: r313]
   - sg_unmap: new utility for thin provisioning
     - add examples/sg_unmap_example.txt
   - sg_get_lba_status: new utility for thin provisioning
   - sg_read_block_limits: new utility for tape drives
   - sg_logs: add cache memory statistics log (sub)page
   - sg_vpd, sg_inq: extend Block limits VPD page (sbc3r19)
   - sg_vpd: add Thin provisioning VPD page (sbc3r20) and
             TapeAlert supported flags VPD page
   - sg_inq: note VPD page support better in sg_vpd
   - sg_persist: add transport specific transportID format
     - allow transportIDs to be read from named file
   - sg_opcodes: allow --opcode= option to take OP and SA
     values (comma seperated)
     - tweak print format, remove test code
   - sg_requests: remove test code in progress calculation
   - sg_reset: add target reset option
   - sg_luns: reduce default maxlen to 8192 (for FreeBSD)
   - sg_raw: extend max cdb length from 16 to 256 bytes
     - align heap allocs to page boundaries
   - sg_lib: sg_set_binary_mode() needs config.h included
     - add progress indication sense data descriptor (0xa)
     - change SG3_UTILS_* constants to SG_LIB_*
     - decode service actions within persistent reserve in/out
     - sync with spc4r21
   - sg_cmds_extra: add sg_ll_unmap() and sg_ll_get_lba_status()
   - sg_pt_linux: fix check condition but empty sense buffer; occurred
     when sg v3 node used and /usr/include/linux/bsg.h visible
     - major() macro grief, if present include <linux/kdev_t.h> and
       use MAJOR() instead
   - scripts/sas_disk_blink: moved from this package to sdparm
   - utils/hxascdmp: in Windows set binary mode on read files
   - examples/sg_persist_tst.sh: add PRIN read full status command
   - sg_raw,sg_write_buffer,sg_write_long,sg_write_same: in Windows
     set binary mode on read files
   - sg_pt_win32: default to non-direct variant of SPT interface
     - use './configure --enable-win32-spt-direct' to override
     - non-direct data length set to 16 KB, extended if required
   - debian: incorporate patch from debian sid

Changelog for sg3_utils-1.27 [20090411] [svn: r250]
....

Doug Gilbert
