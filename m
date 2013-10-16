From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [Announce] sg3_utils-1.37 available
Date: Tue, 15 Oct 2013 21:35:24 -0400
Message-ID: <525DED5C.2010506@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>
Cc: =?ISO-8859-1?Q?Dan_Hor=E1k?= <dhorak@redhat.com>, Ritesh Raj Sarraf <rrs@researchut.com>, "Robin H. Johnson" <robbat2@gentoo.org>, Martin Pitt <mpitt@debian.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

sg3_utils is a package of command line utilities for sending
SCSI and some ATA commands to devices. This package targets
the Linux 3, 2.6 and 2.4 kernel series. It also has ports to
FreeBSD, Tru64, Solaris, and Windows (cygwin and MinGW).

This version contains many fixes, some code cleanup and some
small extensions. This version tracks various changes made
by www.t10.org since May 2013.

For an overview of sg3_utils and downloads see this page:
     http://sg.danny.cz/sg/sg3_utils.html
The sg_ses utility (for enclosure devices) is discussed at:
     http://sg.danny.cz/sg/sg_ses.html
The SG_IO ioctl is discussed at:
     http://sg.danny.cz/sg/sg_io.html
A full changelog can be found at:
     http://sg.danny.cz/sg/p/sg3_utils.ChangeLog

A release announcement will be sent to freecode.com .

Changelog for sg3_utils-1.37 [20131014] [svn: r522]
   - sg_compare_and_write: fix wrprotect setting
     - add --quiet option to suppress miscompare report
     - merge features from another implementation
   - sg_inq: fix referrals VPD page
     - dev_id VPD: T10 vendor id designator clean up
   - sg_logs: improve for tape drives, general cleanup
   - sg_persist: fix core dump on -Q option
   - sg_unmap: fix core dump on -g option
   - sg_vpd: dev_id VPD: T10 vendor id designator clean up
     - cleanup up dev_id NAA-3: locally assigned
   - sg_ses: add --nickname and --nickid options
     - eiioe added to additional element status page (ses3r6)
     - multiple --filter options to prune output
   - sg_verify: improve miscompare handling
     - rename --btychk=ndo option to --ndo=ndo (hide former)
     - add --quiet option
   - sg_xcopy: allow sg and bsg devices
     - fix for bpt going negative
     - limit each XCOPY(LID1) command to 65535 blocks
     - fix for seek in multi-segment copies
   - sg_sanitize: skip 15 second safety delay with --fail
   - sg_libs: extended copy opcode renamed (spc4r34)
     - sg_ll_receive_copy_results(): expand for all sa_s
     - add sg_get_sense_key()
     - add sg_ll_3party_copy_out()
     - add dStrHexErr(): ascii hex to stderr
     - add dStrHexStr(): ascii hex to string
     - add SG_LIB_CAT_MISCOMPARE to categories
     - clean header files
   - sg_pt_freebsd: sanity check on sense_resid; fix leaks
   - scripts/rescan-scsi-bus.sh KG's v1.57 + HR patch
     - improve wlun handling, detect updated and resized
       devices, better multipath support
   - Makefile.am cleanup
   - examples: add sg_tst_excl and sg_tst_excl2

Changelog for sg3_utils-1.36 [20130531] [svn: r497]
...

Doug Gilbert
