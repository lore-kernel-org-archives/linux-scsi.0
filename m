From: Douglas Gilbert <dougg@torque.net>
Subject: [Announce] smp_utils-0.93 available
Date: Sun, 06 Jan 2008 16:12:15 -0500
Message-ID: <4781442F.4060608@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:45837 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692AbYAFVMg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Jan 2008 16:12:36 -0500
Received: from ip-10.57.99.216.dsl-cust.ca.inter.net ([216.99.57.10] helo=rink.bingwo.ca)
	by pentafluge.infradead.org with esmtpsa (Exim 4.68 #1 (Red Hat Linux))
	id 1JBcnK-0002o9-Im
	for linux-scsi@vger.kernel.org; Sun, 06 Jan 2008 21:12:34 +0000
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

smp_utils is a package of command line utilities for invoking
SMP functions to monitor and manage SAS expanders. SMP is the
Serial Attached SCSI (SAS) Management Protocol (SMP). A SAS Host
Bus Adapter (HBA) includes a SMP initiator (along with SSP and
STP initiators). A SAS expander contains a SMP target. Several
SAS HBAs have a SMP pass through interface that can be used to
send SMP requests and receive the responses. This package
targets the linux kernel (lk) 2.6 and lk 2.4 series.

Three interfaces are available: "sgv4", "mptctl" and "smp_portal".
The "sgv4" interface uses the bsg driver and is new in this
version. It requires lk 2.6.24 (or maybe some variants on
lk 2.6.23) or later.

For an overview and examples of smp_utils see:
http://www.torque.net/sg/smp_utils.html
A tarball, rpm and deb can be found in table 2.

CHANGELOG (since version 0.92):
   - sgv4: add new interface
   - smp_phy_control: sync with sas2r10
   - smp_rep_phy_sata: affiliation contexts, added sas2r08
   - smp_discover: add '--list' option for attribute=value output
   - smp_rep_general: sync with sas2r09..12
   - smp_discover, smp_discover_list: sync with sas2r09..12
     - warn if expander's SAS address is different from requested
   - add smp_rep_exp_route_tbl utility
   - abridge output from responses when prior to SAS-2
   - rename this file from CHANGELOG to ChangeLog
   - place code in subversion repository
   - move smp_lib.h into include directory
   - move man pages into doc directory
     - add 'conforms to' section
   - fix FreeBSD build


Doug Gilbert
