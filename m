From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [Announce] sg3_utils-1.41 available
Date: Tue, 07 Jul 2015 22:44:13 -0400
Message-ID: <559C8E7D.5010508@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:47636 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754091AbbGHCos (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Jul 2015 22:44:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>, Martin Pitt <mpitt@debian.org>
Cc: David Sommerseth <davids@redhat.com>, Hannes Reinecke <hare@suse.de>, Ritesh Raj Sarraf <rrs@researchut.com>, "Robin H. Johnson" <robbat2@gentoo.org>, linux-kernel <linux-kernel@vger.kernel.org>

sg3_utils is a package of command line utilities for sending
SCSI and some ATA commands to devices. This package targets
the Linux 4, 3, 2.6 and 2.4 kernel series. It has ports to
FreeBSD, Tru64, Solaris, and Windows (cygwin and MinGW).

There is one new utility (sg_zone) and additions to many
others, see the ChangeLog below. This version tracks various
changes made by www.t10.org since November 2014 until May
2015.

For an overview of sg3_utils and downloads see this page:
     http://sg.danny.cz/sg/sg3_utils.html
The sg_ses utility (for enclosure devices) is discussed at:
     http://sg.danny.cz/sg/sg_ses.html
A full changelog can be found at:
     http://sg.danny.cz/sg/p/sg3_utils.ChangeLog

Changelog for sg3_utils-1.41 [20150511] [svn: r644]
   - sg_zone: new utility for open, close and finish
     zone commands introduced in zbc-r02
   - sg_rep_zones and sg_reset_wp: change opcodes as
     indicated in zbc-r02
   - sg_read_buffer: add READ BUFFER(16) support (spc5r02)
   - sg_logs: add --enumerate and acronyms
     - allow decode from hex or binary in file
     - decode environmental reporting + limits lpages
   - sg_write_buffer: add --timeout=TO option
   - sg_lib interface: add sg_lib_pdt_decay(), TPROTO_PCIE
     plus support for zoning service actions
   - sg_lib: in Linux blocked devices yield ENXIO from
     ioctl(SG_IO), map to SG_LIB_CAT_NOT_READY
     - clean up sg_warnings_stream handling
   - sg_inq+sg_vpd: fix SCSI name string decoding in
     device identification VPD page (0x83)
     - increase sanity on Unit Serial number VPD page
     - improve rdac vpd page reporting (vendor)
   - sg_inq: improve NAA handling in dev_id VPD page
     - update version descriptor list to 20150126
   - sg_vpd: add atomic boundary values (sbc4r04)
     - block limits VPD page: fix unmap granularity
       alignment value; spc5r02 additions
   - sg_readcap: add support for ZBC's rc_basis field
   - sg_senddiag: fix bug with --raw option
     - add support for -HHH for output suitable for --raw
   - sg_ses: enclosure element: add failure and warning
     acronyms, fix warning indication output
     - additional element status dpage: add PCIe/NVMe
     - handle element descriptor names that count
       multiple trailing NULLs
   - rescan-scsi-bus.sh: add --issue-lip-wait option and
     improve error handling
     - improve dm-multipath handling
   - sg_modes: make '-HHH' output suitable as input to
     'sdparm --inhex='
   - sg_rdac: add '-6' option for mode sense/select(6)
     - add support for reporting more SCSI transports
       and accessing rdac extended mode page 0x2c
   - sg_write_same: cleanup, mainly man page
   - scsi_logging_level: replace use of tr command
   - examples/sg_tst_async: cleanup
   - examples/sg-simple_aio.c: remove
   - sg_lib_data: sync asc/ascq codes with T10 20150423
   - Makefile cleanup
   - autogen.sh: upgrade to buildconf 20091223 version

Changelog for sg3_utils-1.40 [20141110] [svn: r620]
...

Doug Gilbert
