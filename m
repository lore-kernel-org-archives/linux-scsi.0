From: Douglas Gilbert <dougg@torque.net>
Subject: sg3_utils-1.08 released
Date: Wed, 01 Sep 2004 16:13:58 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <413568A6.2040202@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from borg.st.net.au ([65.23.158.22]:33228 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S268716AbUIAGOm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Sep 2004 02:14:42 -0400
Received: from [192.168.48.80] (dsl-51.130.240.220.lns02-wick-bne.dsl.comindico.com.au [220.240.130.51])
	by borg.st.net.au (Postfix) with ESMTP id E53BC394515
	for <linux-scsi@vger.kernel.org>; Wed,  1 Sep 2004 16:14:36 +1000 (EST)
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>

Tarball, rpm and deb can be found on http://www.torque.net/sg .
Summary of sg3_utils, sg_utils and other packages are on
this page: http://www.torque.net/sg/u_index.html
A release announcement will be sent to freshmeat.net
shortly.

Changelog for sg3_utils-1.08 [20040831]
   - sg_inq: fix noisy message when EVPD and raw modes set
       - for VPD page 0, list supported page names if known
       - add '-d' option to list version descriptors
   - sg_opcodes: numerically sort list of opcodes unless '-u' given
       - add '-a' to sort alphabetically list of opcode names
       - add '-t' to report supported task management functions
   - sg_persist: add 'register and move" PROUT service action
       - add transportId support, document in sg_persist.8 and example
   - sg_modes: handle subpage code for known pages (e.g. control
       extension)
       - clean up sense buffer handling (allow for descriptor format)
       - SPC-3 draft revision 20a updates
   - sg_write_long: new utility to exercise WRITE LONG command
   - sg_read_long: new utility to exercise READ LONG command
   - sg_err.c: fix compile errors when SG_KERNEL_INCLUDES defined in
       lk 2.6
       - sg_includes.h typedef of u64 for BLKGETSIZE64 ioctl in lk 2.4
       - add safe_strerror(), sg_scsi_normalize_sense(),
         sg_normalize_sense()
         and sg_scsi_sense_desc_find() functions
       - add more sense data descriptor format decoding
       - move multiple implementations of dStrHex() into sg_err.c
   - sg_logs: exit if SCSI INQUIRY fails (e.g. when applied to ATA disk)
   - sginfo: bug fixes and SPC-3 revision 20a updates
       - add '-E' option to access Control Extension mode (sub)page
   - sg_start: change '-d' switch to '-v' (verbose) switch for
       consistency
       - document extra power condition states in man page
   - sg_readcap: output rto_en and prot_en bits from long read
       capacity data
   - add COVERAGE file to list SCSI command coverage

Doug Gilbert
