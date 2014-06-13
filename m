From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [Announce] sg3_utils-1.39 available
Date: Fri, 13 Jun 2014 00:41:21 -0400
Message-ID: <539A80F1.40205@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:51486 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951AbaFMEl1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jun 2014 00:41:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>
Cc: =?ISO-8859-1?Q?Dan_Hor=E1k?= <dhorak@redhat.com>, Ritesh Raj Sarraf <rrs@researchut.com>, "Robin H. Johnson" <robbat2@gentoo.org>, Martin Pitt <mpitt@debian.org>, Hannes Reinecke <hare@suse.de>, linux-kernel <linux-kernel@vger.kernel.org>

sg3_utils is a package of command line utilities for sending
SCSI and some ATA commands to devices. This package targets
the Linux 3, 2.6 and 2.4 kernel series. It also has ports to
FreeBSD, Tru64, Solaris, and Windows (cygwin and MinGW).

There is usually around 6 months between versions of this
package but this time there is only 2.5 months due to the
volume of changes and additions, see the ChangeLog below.
This version tracks various changes made by www.t10.org
since April 2014.

For an overview of sg3_utils and downloads see this page:
     http://sg.danny.cz/sg/sg3_utils.html
The sg_ses utility (for enclosure devices) is discussed at:
     http://sg.danny.cz/sg/sg_ses.html
A full changelog can be found at:
     http://sg.danny.cz/sg/p/sg3_utils.ChangeLog

A release announcement will be sent to freecode.com .


Changelog for sg3_utils-1.39 [20140612] [svn: r588]
   - sg_rep_zones: new utility for ZBC REPORT ZONES
   - sg_reset_wp: new utility, ZBC RESET WRITE POINTER
   - sg_ses: add --eiioe=auto|force option
     - fix AES dpage element indexing problems
     - add --readonly option
   - sg_write_buffer: add --bpw=CS option to call
     write buffer multiple times for big blobs
   - sg_format: add --ip_def option to fully provision
   - sg_opcodes: add --mask option
   - sg_logs: add --in=FN option for log select params
     - add --filter=PARC (parameter code)
     - add --no_inq for suppress initial INQUIRY call
     - add --readonly option
   - sg_persist: add --readonly option, environment
     variable SG_PERSIST_IN_RDONLY sets ro on prin cmds
   - sg_inq: sync version descriptors dated 20105176
     - suppress dev-id VPD messages so they only appear
       when --verbose is given
     - add new SCSI_IDENT_*_ATA pair to --export output
   - sg_luns: add decoding for conglomerate LUNS
     - add --lu_cong option to simulate the LU_CONG bit
   - sg_vpd: add --vendor=VP option, re-order vendor
     specific pages, split lto into lto5 and lto6
     - add Supported block lengths and protection types
       page (sbc4r01)
     - add Block device characteristics extension
       page (sbc4r02)
   - sg_copy_results, sg_get_lba_status, sg_luns,
     sg_read_buffer, sg_readcap, sg_referrals, sg_rtpg,
     sg_sat_set_features, sg_sat_identify:
     add --readonly option
   - sginfo: strip trailing spaces from INQUIRY text
   - sg_rbuf: add --echo option (to use echo buffer)
   - sg_lib: add sanitize command service action names
     - add 'sense' categories for reservation conflict,
       data protect and protection information violations
     - add sg_get_category_sense_str() to API
     - change struct sg_simple_inquiry_resp::rmb to byte_1
     - add initial zbc service actions
     - dStrHex(Err): fix output truncation error
     - linux, sg: support SCSI_PT_FLAGS_QUEUE_AT_TAIL and
       SCSI_PT_FLAGS_QUEUE_AT_HEAD (block layer queueing)
   - sg_lib_data: sync asc/ascq codes with T10 20140516
     - sync operation code with T10 20140515
     - add id string for SPC-5
   - scripts/59-scsi-sg3_utils.rules: removed
     - functionality split into two scripts:
       55-scsi-sg3_id.rules + 58-scsi-sg3_symlink.rules
   - examples/sg_persist_tst.sh: add --exclusive option
   - win32: sg_scan, sg_ses and sg_log fixes
   - examples/sgq_dd: re-add old utility as example

Changelog for sg3_utils-1.38 [20140401] [svn: r563]
....

Doug Gilbert
