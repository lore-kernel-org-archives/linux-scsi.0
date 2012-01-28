From: Jing Huang <huangj@brocade.com>
Subject: [PATCH] bfa: add readme file
Date: Fri, 27 Jan 2012 16:51:51 -0800
Message-ID: <1327711911-8661-1-git-send-email-huangj@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:44320 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751975Ab2A1BQd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jan 2012 20:16:33 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com
Cc: adapter_linux_open_src_team@brocade.com, Jing Huang <huangj@brocade.com>

This patch add bfa driver readme file to Documentation/scsi

Signed-off-by: Jing Huang <huangj@brocade.com>
---
 Documentation/scsi/bfa.txt |   82 ++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 82 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/scsi/bfa.txt

diff --git a/Documentation/scsi/bfa.txt b/Documentation/scsi/bfa.txt
new file mode 100644
index 0000000..62c02e0
--- /dev/null
+++ b/Documentation/scsi/bfa.txt
@@ -0,0 +1,82 @@
+Linux driver for Brocade FC/FCOE adapters
+
+
+Supported Hardware
+------------------
+
+bfa 3.0.2.2 driver supports all Brocade FC/FCOE adapters. Below is a list of 
+adapter models with corresponding PCIIDs.
+
+	PCIID		  	Model		
+
+	1657:0013:1657:0014	425 4Gbps dual port FC HBA
+	1657:0013:1657:0014	825 8Gbps PCIe dual port FC HBA
+	1657:0013:103c:1742	HP 82B 8Gbps PCIedual port FC HBA
+	1657:0013:103c:1744	HP 42B 4Gbps dual port FC HBA
+	1657:0017:1657:0014	415 4Gbps single port FC HBA
+	1657:0017:1657:0014	815 8Gbps single port FC HBA
+	1657:0017:103c:1741	HP 41B 4Gbps single port FC HBA
+	1657:0017:103c 1743	HP 81B 8Gbps single port FC HBA
+	1657:0021:103c:1779	804 8Gbps FC HBA for HP Bladesystem c-class
+
+	1657:0014:1657:0014	1010 10Gbps single port CNA - FCOE
+	1657:0014:1657:0014	1020 10Gbps dual port CNA - FCOE
+	1657:0014:1657:0014	1007 10Gbps dual port CNA - FCOE
+	1657:0014:1657:0014	1741 10Gbps dual port CNA - FCOE
+
+	1657:0022:1657:0024	1860 16Gbps FC HBA
+	1657:0022:1657:0022	1860 10Gbps CNA - FCOE
+
+
+Firmware download
+-----------------
+
+The latest Firmware package for 3.0.2.2 bfa driver can be found at:
+
+http://www.brocade.com/services-support/drivers-downloads/adapters/Linux.page
+
+and then click following respective util package link:
+
+	Version			Link 
+
+	v3.0.0.0	Linux Adapter Firmware package for RHEL 6.2, SLES 11SP2
+
+
+Configuration & Management utility download
+-------------------------------------------
+
+The latest driver configuration & management utility for 3.0.2.2 bfa driver can
+be found at: 
+
+http://www.brocade.com/services-support/drivers-downloads/adapters/Linux.page
+
+and then click following respective util pacakge link
+
+	Version			Link			
+
+	v3.0.2.0	Linux Adapter Firmware package for RHEL 6.2, SLES 11SP2
+
+
+Documentation
+-------------
+
+The latest Administration's Guide, Installation and Reference Manual,
+Troubleshooting Guide, and Release Notes for the corresponding out-of-box
+driver can be found at:
+
+http://www.brocade.com/services-support/drivers-downloads/adapters/Linux.page
+
+and use the following inbox and out-of-box driver version mapping to find
+the corresponding documentation:
+
+	Inbox Version		Out-of-box Version 
+
+	v3.0.2.2		v3.0.0.0
+
+
+Support
+-------
+
+For general product and support info, go to the Brocade website at:
+
+http://www.brocade.com/services-support/index.page
-- 
1.6.5.2

