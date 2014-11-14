From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [Announce] sg3_utils-1.40 available
Date: Thu, 13 Nov 2014 19:27:13 -0500
Message-ID: <54654C61.8070002@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>, Martin Pitt <mpitt@debian.org>
Cc: David Sommerseth <davids@redhat.com>, Hannes Reinecke <hare@suse.de>, Ritesh Raj Sarraf <rrs@researchut.com>, "Robin H. Johnson" <robbat2@gentoo.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

sg3_utils is a package of command line utilities for sending
SCSI and some ATA commands to devices. This package targets
the Linux 3, 2.6 and 2.4 kernel series. It has ports to
FreeBSD, Tru64, Solaris, and Windows (cygwin and MinGW).

There are three new utilities and major additions to several
others, see the ChangeLog below. This version tracks various
changes made by www.t10.org since June 2014.

For an overview of sg3_utils and downloads see this page:
     http://sg.danny.cz/sg/sg3_utils.html
The sg_ses utility (for enclosure devices) is discussed at:
     http://sg.danny.cz/sg/sg_ses.html
A full changelog can be found at:
     http://sg.danny.cz/sg/p/sg3_utils.ChangeLog


Changelog for sg3_utils-1.40 [20141110] [svn: r620]
   - sg_write_verify: new utility for WRITE AND VERIFY
   - sg_ses_microcode: new utility
   - sg_sat_read_gplog: new utility
   - sg_senddiag: add --maxlen= option
   - sg_copy_results: correct response length calculations
   - sg_format: make '-FFF' bypass mode sense/select
     - add --mode=MP to supply alternate mode page,
       default remains read-write error recovery mpage
     - output unit serial number and LU name prior to
   - sg_inq: expand Block limits VPD page output
     - fix --cmddt output if not supported by device
     - more sanity checks on vendor supplied fields
   - sg_vpd: add --all option
     - more TPC VPD page decoding
     - add zoned block device characteristics page
     - more sanity checks on vendor supplied fields
   - sg_ses: fix problem with --index=sse (and ssc)
     - mask status element before using as control
     - defeat previous item with --mask (ignore) option
     - SAS connector status element: add overcurrent bit
     - handle element descriptor names that count a
       trailing NULL
     - add --warn option mainly for broken joins
     - add optional descriptions to -ee output
     - sync with ses3r07
   - sg_sanitize: add --desc and --zero options
     - output unit serial number and LU name prior to
   - sg_rep_zones: corrections, sync with zbc-r01c
   - sg_persist: split help into two pages, '-hh' for 2nd
   - sg_logs: refine tape drive output
   - sg_raw: with -vvv decode T10 CDB name
     - do not output/print data-in if error
   - sg_opcodes: add --compact field
   - sg_senddiag: add --page=PG option
   - sg_reset: add words for EAGAIN from reset ioctl
   - sg_sat_*: mention t_type and multiple_count fields
   - win32: sg_scan: handle larger configurations
   - sg_lib: trim trailing spaces in dStrHex() and friends
   - sg_lib_data: sync asc/ascq codes with T10 20140924
     - clean up service action string functions
     - sg_ll_unmap_v2(): fix group number
     - sg_ll_inquiry(), sg_ll_mode_sense*(),
       sg_ll_log_sense(): use resid to clear unfilled
       data-in buffer
   - sg_unaligned.h: add header for building parameters
   - examples/sg_tst_async: new Linux sg test utility

Changelog for sg3_utils-1.39 [20140612] [svn: r588]
...

Doug Gilbert
