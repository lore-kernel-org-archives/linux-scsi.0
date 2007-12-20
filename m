From: Douglas Gilbert <dougg@torque.net>
Subject: smp_utils 0.93 beta, adds sgv4 interface
Date: Wed, 19 Dec 2007 23:46:35 -0500
Message-ID: <4769F3AB.6050405@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:50055 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753759AbXLTEqj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Dec 2007 23:46:39 -0500
Received: from ip-191.61.99.216.dsl-cust.ca.inter.net ([216.99.61.191] helo=rink.bingwo.ca)
	by pentafluge.infradead.org with esmtpsa (Exim 4.68 #1 (Red Hat Linux))
	id 1J5DIs-0007FI-5j
	for linux-scsi@vger.kernel.org; Thu, 20 Dec 2007 04:46:38 +0000
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

smp_utils is a package of command line utilities for invoking
SMP functions to monitor and manage SAS expanders. SMP is the
Serial Attached SCSI (SAS) Management Protocol (SMP). A SAS Host
Bus Adapter (HBA) includes a SMP initiator (along with a SSP and
STP initiator). A SAS expander contains a SMP target.

Previous versions have supported two interfaces: the "mptctl"
pass through used by MPT Fusion SAS HBAs and the "smp_portal"
sysfs attribute pass through used by Luben's aic94xx driver.

This beta adds preliminary support for an interface based on
the scsi generic version 4 ("sgv4") interface. It works, apart
from a few shortcomings, with the MPT Fusion SAS driver found
in lk 2.6.24-rc4 . My aic94xx based hardware refuses to
work with the mainline driver (but works with Luben's
driver) so I'm unable to test it with the "sgv4" interface. I
would be grateful if someone would test it and tell me how it
fairs. Since the sgv4 interface essentially talks to the
linux SAS transport layer, other SAS HBAs may work as well.

For an overview and examples of smp_utils see:
http://www.torque.net/sg/smp_utils.html
A tarball can be found in table 2.

Version 0.93 ChangeLog:
Changelog for smp_utils-0.93 [20071211]
  - sgv4: add new interface
  - smp_phy_control: sync with sas2r10
  - smp_rep_phy_sata: affiliation contexts, added sas2r08
  - smp_discover: add '--list' option for attribute=value output
  - smp_rep_general: sync with sas2r09..12
  - smp_discover, smp_discover_list: sync with sas2r09..12
    - warn if expander's SAS address is different from requested
  - add smp_rep_exp_route_tbl utility
  - rename this file from CHANGELOG to ChangeLog
  - place code in subversion repository
  - move smp_lib.h into include directory
  - move man pages into doc directory


Doug Gilbert
