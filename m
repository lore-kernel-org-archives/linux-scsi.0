From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [Announce] smp_utils-0.95 available
Date: Fri, 19 Nov 2010 15:31:47 -0500
Message-ID: <4CE6DEB3.80506@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:46079 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752953Ab0KSUbw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Nov 2010 15:31:52 -0500
Received: from localhost (localhost [127.0.0.1])
	by smtp.infotech.no (Postfix) with ESMTP id 34DC7316E9
	for <linux-scsi@vger.kernel.org>; Fri, 19 Nov 2010 21:31:51 +0100 (CET)
Received: from smtp.infotech.no ([127.0.0.1])
	by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ml9LmC4k1cX0 for <linux-scsi@vger.kernel.org>;
	Fri, 19 Nov 2010 21:31:49 +0100 (CET)
Received: from [192.168.48.95] (ip-70.51.99.216.dsl-cust.ca.inter.net [216.99.51.70])
	by smtp.infotech.no (Postfix) with ESMTPA id 14002316E8
	for <linux-scsi@vger.kernel.org>; Fri, 19 Nov 2010 21:31:48 +0100 (CET)
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
The "sgv4" interface uses the bsg driver.

This version fixes a problem accessing mpt2sas HBAs
when used with the mptctl interface.

For an overview and examples of smp_utils see:
http://sg.danny.cz/sg/smp_utils.html
A tarball, rpm and deb can be found in table 2.

Changelog for smp_utils-0.95 [20101116] [svn:r47]
   - place link to smp_utils.html examples in man pages
   - alter Makefile for non-root users
   - add spl-r04 discover changes (spl is upper layers of sas-2.1)
   - mpt: cope with mpt2 ioctl that uses a different magic number


Doug Gilbert
