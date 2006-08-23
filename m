From: Douglas Gilbert <dougg@torque.net>
Subject: [Announce] smp_utils-0.91 available
Date: Wed, 23 Aug 2006 10:10:43 -0400
Message-ID: <44EC61E3.30005@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:34233 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932324AbWHWOKx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Aug 2006 10:10:53 -0400
Received: from ip-155.57.99.216.dsl-cust.ca.inter.net ([216.99.57.155] helo=[192.168.48.80])
	by pentafluge.infradead.org with esmtpsa (Exim 4.62 #1 (Red Hat Linux))
	id 1GFtRU-0005Rj-CB
	for linux-scsi@vger.kernel.org; Wed, 23 Aug 2006 15:10:52 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

smp_utils is a package of command line utilities for invoking
SMP functions to monitor and manage SAS expanders. SMP is the
Serial Attached SCSI (SAS) Management Protocol (SMP). A SAS Host
Bus Adapter (HBA) includes a SMP initiator (along with a SSP and
STP initiator). A SAS expander contains a SMP target. Several
SAS HBAs have a SMP pass through interface that can be used to
send SMP requests and receive the responses. This package targets
the linux kernel (lk) 2.6 and lk 2.4 series.

Two interfaces are available: the "mptctl" pass through used
by MPT Fusion SAS HBAs and the "smp_portal" sysfs attribute
pass through used by at least one aic94xx based Linux driver.

This version adds the smp_phy_test and smp_discover_list
utilities. All SMP functions defined in SAS-1 and SAS-1.1
are now supported with some support to SAS-2 extensions
(see the COVERAGE file). See the CHANGELOG and README files
for more information.

One new feature, borrowed from Luben Tuikov's
expander_conf.c, is to loop over consecutive phys in
smp_discover to produce a summary of what is attached
to an expander:

# smp_discover --multiple --brief
Device <500605b000000af0>, expander (only connected phys shown):
  phy   2:S:attached:[5000c500005208ee:01  t(SSP)]  3 Gbps
  phy   3:S:attached:[5000c500005208ed:00  t(SSP)]  3 Gbps
  phy   4:T:attached:[500605b00006f260:02  i(SSP+STP+SMP)]  3 Gbps
  phy   5:T:attached:[50000d10002dc000:01  i(SSP+STP+SMP)]  3 Gbps
  phy   8:T:attached:[5000c50000520a29:00  t(SSP)]  3 Gbps
  phy   9:T:attached:[5000c50000520a2a:01  t(SSP)]  3 Gbps
  phy  10:T:attached:[500605b000000afa:00  t(SATA)]  1.5 Gbps
  phy  11:T:attached:[500605b000000afb:00  t(SATA)]  1.5 Gbps


A tarball, rpm and deb can be found at (see table 2):
http://www.torque.net/sg/smp_utils.html
For an overview of smp_utils see the same page.


Doug Gilbert
