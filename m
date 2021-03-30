Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54E81C433C1
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 02:04:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1CAEA61989
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 02:04:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbhC3CE1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Mar 2021 22:04:27 -0400
Received: from mail-1.ca.inter.net ([208.85.220.69]:54394 "EHLO
        mail-1.ca.inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230391AbhC3CEX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Mar 2021 22:04:23 -0400
Received: from localhost (offload-3.ca.inter.net [208.85.220.70])
        by mail-1.ca.inter.net (Postfix) with ESMTP id 9B9832EA05F;
        Mon, 29 Mar 2021 22:04:22 -0400 (EDT)
Received: from mail-1.ca.inter.net ([208.85.220.69])
        by localhost (offload-3.ca.inter.net [208.85.220.70]) (amavisd-new, port 10024)
        with ESMTP id 72nIxq-x7jFJ; Mon, 29 Mar 2021 21:46:06 -0400 (EDT)
Received: from [192.168.48.23] (host-45-58-219-4.dyn.295.ca [45.58.219.4])
        (using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail-1.ca.inter.net (Postfix) with ESMTPSA id E13A12EA050;
        Mon, 29 Mar 2021 22:04:20 -0400 (EDT)
Reply-To: dgilbert@interlog.com
From:   Douglas Gilbert <dgilbert@interlog.com>
Subject: [Announce] sg3_utils-1.46 available
To:     SCSI development list <linux-scsi@vger.kernel.org>
Cc:     =?UTF-8?B?VG9tw6HFoSBCxb5hdGVr?= <tbzatek@redhat.com>,
        Martin Pitt <mpitt@debian.org>, Hannes Reinecke <hare@suse.de>,
        Ritesh Raj Sarraf <rrs@researchut.com>,
        "Robin H. Johnson" <robbat2@gentoo.org>
Message-ID: <c54c62ff-33fd-267f-6828-4636e9968cf4@interlog.com>
Date:   Mon, 29 Mar 2021 22:04:20 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

sg3_utils is a package of command line utilities for sending SCSI commands
to storage devices. It some contexts it can send ATA and NVMe commands.
The package targets the Linux 5, 4, 3, 2.6 and 2.4 kernel series. It has
ports to FreeBSD, Android, Solaris, and Windows (cygwin and MinGW).

For an overview of sg3_utils and downloads see either of these pages:
     http://sg.danny.cz/sg/sg3_utils.html
     https://doug-gilbert.github.io/sg3_utils.html
The sg_ses utility (for enclosure devices) is discussed at:
     http://sg.danny.cz/sg/sg_ses.html
A full changelog can be found at:
     http://sg.danny.cz/sg/p/sg3_utils.ChangeLog
     https://doug-gilbert.github.io/p/sg3_utils.ChangeLog
This github mirror needs to be updated:
     https://github.com/hreinecke/sg3_utils
Plus the author's own github mirror:
     https://github.com/doug-gilbert/sg3_utils

That last mirror is up-to-date and has git tags going back to "r1.20"
which is sg3_utils 1.20 released nearly 15 years ago.


Here is the top of that ChangeLog, stopping at the previous release:

Changelog for released sg3_utils-1.46 [20210329] [svn: r891]
   - sg_rep_pip: new utility: report provisioning initialization
     pattern command
   - sg_turs: estimated time-to-ready [spc6r03]
     - add --delay=MS option
   - sg_requests: substantial cleanup
   - sg_vpd: add Format presets and Concurrent positioning ranges
     - add hot-pluggable field in standard Inquiry [spc6r05]
     - fix vendor struct opts_t alignment
   - sg_inq: add hot-pluggable field in standard Inquiry
   - sg_dd: --verify : separate category for miscompare errors
     - --verify : oflag=coe continue on miscompares, counts them
     - add cdl= operand for command duration limit indexes
     - add oflag=nocreat and conv=nocreat : OFILE must exist
     - add iflag=00, ff, random flags
     - setup conditional auto rule for getrandom()
     - add command timeout after comma in time= operand
   - sg_get_elem_status: add ralwd bit sbc4r20a
   - sg_write_x: add dld bits to write(32) [sbc4r19a]
   - sg_rep_zones: print invalid write pointer LBA as -1 rather
     than 16 "f"s
   - sg_opcodes: improve handling of RWCDLP field
   - sg_ses: use fan speed factor field for calculation [ses4r04]
     - add --all (-a) option, same action as --join
   - sg_compare_and_write: add examples section to its manpage
   - sg_modes: document '-s' option (same as '-6')
   - sg_sanitize + sg_format: when --verbose given once report
     probable success; without --verbose 'no news is good news'
   - sg_zone: add Remove element and modify zones command
   - sg_raw: increase maximum data-in and data-out buffer size
     from 64 KB to 1 MB
     - fix --cmdfile= handling
     - add --nvm option to send commands from the NVM command set
     - add --cmdset option to bypass cdb heuristic
     - add --scan= first_opcode,last_opcode
   - sg_pt_freebsd: allow device names without leading /dev/
     thus fix for regression introduced in rev 731 (ver: 1.43)
   - sg_pt_solaris+sg_pt_osf1: fix problem with clear_scsi_pt_obj()
     which needs to remember is_nvme and dev_fd values
   - sg_lib: add ZBC (2020) feature set entries
   - sg_lib: restore elements and rebuild command added
   - sg_lib,sg_pt: add partial_clear_scsi_pt_obj(),
     get_scsi_pt_cdb_len() and get_scsi_pt_cdb_buf()
     - add do_nvm_pt() for the NVM (sub-)command set
     - tweak transport error handling in Linux
   - sg_lib: Linux NVMe SNTL: add read, write and verify;
     synchronize cache and write same translations
     - add dummy start stop unit and test unit ready commands
     - wire cache mpage's WCE to nvme 'volatile write cache'
     - fix crash in sg_f2hex_arr() when fname not found
   - sg_lib: reprint cdb with illegal request sense key
     - asc/ascq match asc-num.txt @t10 20200708 [spc6r02]
   - gcc-10: suppress warnings
   - autoconf: upgrade version 2.69 to 2.70
   - remove space from end of source lines for git-svn
   - testing/sg_mrq_testing: new, for blocking mrq usage
   - testing/sgs_dd: add evfd flags and eventfd processing
   - testing: remove master-slave terminology for sgv4
   - examples: add nvme_read_ctl.hex and nvme_write_ctl.hex

Changelog for released sg3_utils-1.45 [20200229] [svn: r843]
....

Doug Gilbert
