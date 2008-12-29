From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [Announce] smp_utils-0.94 available
Date: Mon, 29 Dec 2008 18:43:55 -0500
Message-ID: <495960BB.1040103@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:34660 "EHLO
	elrond2.infotech.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987AbYL2XoD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Dec 2008 18:44:03 -0500
Received: from localhost (localhost [127.0.0.1])
	by elrond2.infotech.no (Postfix) with ESMTP id 4F1B21BF24
	for <linux-scsi@vger.kernel.org>; Tue, 30 Dec 2008 00:44:00 +0100 (CET)
Received: from elrond2.infotech.no ([127.0.0.1])
	by localhost (elrond2.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HoOp-A217mKt for <linux-scsi@vger.kernel.org>;
	Tue, 30 Dec 2008 00:43:58 +0100 (CET)
Received: from [192.168.48.87] (ip-72.61.99.216.dsl-cust.ca.inter.net [216.99.61.72])
	by elrond2.infotech.no (Postfix) with ESMTP id E2AAA1BF23
	for <linux-scsi@vger.kernel.org>; Tue, 30 Dec 2008 00:43:57 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>

smp_utils is a package of command line utilities for invoking
SMP functions to monitor and manage SAS expanders. SMP is the
Serial Attached SCSI (SAS) Management Protocol. A SAS Host
Bus Adapter (HBA) includes a SMP initiator (along with SSP and
STP initiators). A SAS expander contains a SMP target. Many
SAS HBAs have a SMP pass through interface that can be used to
send SMP requests and receive the responses. This package
should work with the linux kernel (lk) 2.6 series, the lk 2.4
series, and builds on FreeBSD.

Three interfaces are available: "sgv4", "mptctl" and "smp_portal".
The "sgv4" interface uses the bsg driver. It requires lk 2.6.24
or later.

SAS-2 ratification is approaching and this smp_utils version
syncs various important commands with what should be the last
SAS-2 draft (revision 15):
     http://www.t10.org/cgi-bin/ac.pl?t=f&f=sas2r15.pdf
This package implements 14 of the 27 SMP functions defined in
sas2r15. Support for zoning functions is weak.

For an overview and examples of smp_utils see:
http://sg.danny.cz/sg/smp_utils.html
A tarball, rpm and deb can be found in table 2.

Changelog for smp_utils-0.94 [20081229] [svn:r40]
   - smp_discover: sync to sas2r15
   - smp_discover_list: sync to sas2r15
   - smp_rep_general: sync to sas2r15
   - smp_rep_exp_route_tbl: sync to sas2r15
   - smp_lib: sync to sas2r15
   - sgv4: more detail in error messages
   - sgv4: drop scsi.h include, gives problems with lk 2.6.27
   - mpt: allow either /dev/mptctl or /dev/mpt2ctl [10;220-221]
     - warn if target SAS address is 0x00000000 when -v given

Changelog for smp_utils-0.93 [20080106] [svn:r7]
...

Doug Gilbert
