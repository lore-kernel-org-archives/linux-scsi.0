Return-Path: <SRS0=hRFu=4U=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DAC0C3F2CD
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Mar 2020 06:15:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 394B5215A4
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Mar 2020 06:15:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725840AbgCCGP3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Mar 2020 01:15:29 -0500
Received: from smtp.infotech.no ([82.134.31.41]:37148 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725554AbgCCGP3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 3 Mar 2020 01:15:29 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 669A6204238;
        Tue,  3 Mar 2020 07:15:26 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id vzGVcn-H6IgH; Tue,  3 Mar 2020 07:15:23 +0100 (CET)
Received: from [192.168.48.23] (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id CE81D204237;
        Tue,  3 Mar 2020 07:15:22 +0100 (CET)
To:     SCSI development list <linux-scsi@vger.kernel.org>
Reply-To: dgilbert@interlog.com
Cc:     Martin Pitt <mpitt@debian.org>,
        David Sommerseth <davids@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        Ritesh Raj Sarraf <rrs@researchut.com>,
        "Robin H. Johnson" <robbat2@gentoo.org>
From:   Douglas Gilbert <dgilbert@interlog.com>
Subject: [Announce] sg3_utils-1.45 available
Message-ID: <f534152a-0b08-019e-96a4-f7611a400635@interlog.com>
Date:   Tue, 3 Mar 2020 01:15:19 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

sg3_utils is a package of command line utilities for sending SCSI commands
to storage devices. It some contexts it can send ATA and NVMe commands.
The package targets the Linux 5, 4, 3, 2.6 and 2.4 kernel series. It has
ports to FreeBSD, Android, Solaris, and Windows (cygwin and MinGW).

For an overview of sg3_utils and downloads see this page:
     http://sg.danny.cz/sg/sg3_utils.html
The sg_ses utility (for enclosure devices) is discussed at:
     http://sg.danny.cz/sg/sg_ses.html
A full changelog can be found at:
     http://sg.danny.cz/sg/p/sg3_utils.ChangeLog
Hopefully this github mirror will be updated shortly:
     https://github.com/hreinecke/sg3_utils

Here is the top of that ChangeLog, stopping at the previous release:

Changelog for sg3_utils-1.45 [20200229] [svn: r843]
   - sg_get_elem_status: new utility [sbc4r16]
   - sg_ses: bug: --page= being overridden when --control and --data= also
     given; fix
     - document explicit Element type codes and example
     - rename 'SAS SlimLine' to SlimSAS [ses4r02]
     - add --inhex=FN, equivalent to --data=@FN, for compatibility with
       other utilities
     - 'fan speed factor' field added in 20-013r1
   - sg_opcodes: expand MLU (now 2 bits, spc5r20)
     - include RWCDLP field as extension of CDLP field (spc5r01)
   - sg_write_buffer: allow comma and period separated lists when input
     from stdin
   - sg_inq: update version descriptors to spc5r21
     - add some NVMe 1.4 snippets to ctl identify
   - sg_format: add --dcrt used twice (FOV=1 DCRT=0)
     - add support for FORMAT WITH PRESET (sbc4r18)
   - sg_raw: fix --send bug when using stdin
   - sg_vpd: 3pc VPD page add copy group descriptor
     - add --examine option
     - new zoned block device char. page (zbc2r04)
   - sg_read_buffer: decode read microcode status page
     - add --inhex=FN option
   - sg_request: add --error option, replaces opcode with 0xff (or skips call
     to pass-through)
   - sg_get_lba_status: add --inhex=FN option
   - sg_xcopy: add --fco (fast copy only) (spc5r20)
     - implement --app=1 (append) on regular OFILE type
   - sg_scan (win32): expand limits for big arrays
   - sg_modes: placeholders for Command duration limit  T2A and T2B mpages
     (sbc4r17)
     - improve zbc support (e.g. caching mpage)
   - sg_logs: add Command duration limits statistics lpage (spc6r01)
     - zoned block device statistics log page: shorten counter fields from
       8 to 4 bytes (zbc2r02)
       - new field in this log page (zbc2r04)
     - change '-ll' option to suppress subpages=0xff apart from page
       0x0,0xff. Used three times: list all pages and subpages names
       reported
   - sg_reassign: for defect list format 6 (vendor specific) don't try to decode
   - sg_rep_zones: expand some fields per zbc2r04
     - add --num= and --wp options
   - sg_verify: correct so issues VERIFY(16)
     - add --0 and --ff options and implement bytchk=3 properly
   - sg_write_same: add --ff for 0xff fill
   - sg_luns: report new "target commands" w-lun (19-117)
   - sg_dd: add --verify support
   - sgp_dd: support memory-mapped IO via mmap flag
   - inhex directory: new, contains ASCII hex files that can be used with
     the '--inhex=' option
   - sg_lib: add sg_t10_uuid_desig2str()
     - add sg_get_command_str and sg_print_command_len()
     - speed up sg_print_command()
     - sg_scsi_normalize_sense(): populate byte4,5,6
     - tweak sg_pt interface to better handle bidi
     - sg_cmds_process_resp(): two arguments removed
     - add ${PACKAGE_VERSION} to '.so' name
     - add sg_f2hex_arr()
     - update some tables for NVMe 1.4
     - sg_get_num()+sg_get_llnum(): add 'e' decoding, exabytes; allow
       addition (e.g. --count=3+1k)
     - asc/ascq match asc-num.txt @t10 20191014
     - new zbc2r04 service actions
   - sg_pt_freebsd: fixes for FreeBSD 12.0 release
   - scripts: update 54-before-scsi-sg3_id.rules, scsi-enable-target-scan.sh
     and 59-fc-wwpn-id.rules
   - linux: add nanosecond durations when SG3_UTILS_LINUX_NANO environment
     variable givenand Linux sg driver >= 4.0.30
   - rescan-scsi-bus: widen LUN 0 only scanning
     - multiple patches to sync with Suse
   - testing/sg_tst_async: fix free_list issue
   - testing/sg_tst_ioctl: for sg 4.0 driver
   - testing/sg_tst_bidi: for sg 4.0 driver
   - testing/sgh_dd: test request sharing, mreqs...
     - add --verify support
   - testing/sgs_dd: back from archive, for testing SIGPOLL (SIGIO) and
     realtime (RT) signals
   - testing/sg_chk_asc: allow LF and CR/LF in asc-num.txt
   - testing: 'make' now builds both C and C++ programs
   - sg_pt: add sg_get_opcode_translation() to replace global pointer to
     array: sg_opcode_info_arr[]
     - extend small SNTL to support read capacity
   - utils/hxascdmp: add -o=<offset> option
     - add -1, -2 and -q options
   - sg_io_linux (sg_lib): add sg_linux_sense_print()
   - sg_pt_linux: uses sg v4 interface if sg driver >= 4.0.0 . Force sg v3
     always by building with './configure --disable-linux-sgv4'
     - add sg_linux_get_sg_version() function
   - add: 'SPDX-License-Identifier: BSD-2-Clause' or a small number of
     'GPL-2.0-or-later'
   - gcc-9: suppress (pointless) warnings
   - automake: upgrade to version 1.16.1
   - autoconf: upgrade to version 2.69
   - sync with fixes from Redhat, via github

Changelog for sg3_utils-1.44 [20180912] [svn: r791]
....


Wow, almost 18 months since the last release. Will try to bring that back
to roughly six months.

Doug Gilbert


PS My subversion revision at the release point was 843, but the github mirror
may show revision 844. That last revision is the release tag.
