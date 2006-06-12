From: Douglas Gilbert <dougg@torque.net>
Subject: [Announce] smp_utils-0.90 available
Date: Sun, 11 Jun 2006 20:58:49 -0400
Message-ID: <448CBC49.8030305@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:15059 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751197AbWFLA6s (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 11 Jun 2006 20:58:48 -0400
Received: from toronto-hse-ppp3737739.sympatico.ca ([67.68.54.166] helo=[192.168.1.104])
	by pentafluge.infradead.org with esmtpsa (Exim 4.62 #1 (Red Hat Linux))
	id 1FpalT-0000rk-Eo
	for linux-scsi@vger.kernel.org; Mon, 12 Jun 2006 01:58:47 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

smp_utils is a package of command line utilities for sending
SMP functions to devices. SMP is the management protocol
for Serial Attached SCSI (SAS). Several SAS HBAs have a SMP
pass through interface that can be used to initiate SMP
requests. SMP targets are typically SAS expanders.
This package targets the linux kernel (lk) 2.6 and lk 2.4
series.

This is the initial version. Two interfaces are available,
the "mptctl" pass through used by MPT Fusion SAS HBAs
and the "smp_portal" sysfs attribute pass through used
by at least one aic94xx based Linux driver.
See the CHANGELOG and README files for more information.

A tarball, rpm and deb can be found at (see table 2):
http://www.torque.net/sg/smp_utils.html
For an overview of smp_utils see the same page.

A changelog can be found at:
http://www.torque.net/sg/p/smp_utils.CHANGELOG


Doug Gilbert

