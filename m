From: <sreekanth.reddy@lsi.com>
Subject: [PATCH] MAINTAINERS : update LSILOGIC MPT FUSION DRIVERS
 (FC/SAS/SPI) maintainers
Date: Tue, 9 Oct 2012 11:04:22 +0530
Message-ID: <20121009053422.GA6398@dhcp-135-24-192-117.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog130.obsmtp.com ([74.125.149.143]:45935 "EHLO
	na3sys009aog130.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751278Ab2JILay (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Oct 2012 07:30:54 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, jejb@kernel.org, Nagalakshmi.Nandigama@lsi.com, sreekanth.reddy@lsi.com
Cc: Sathya.Prakash@lsi.com

Updating the MAINTAINERS file for the entry LSILOGIC MPT FUSION
DRIVERS

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
---

diff --git a/MAINTAINERS b/MAINTAINERS
index 14bc707..de4a3a8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4282,13 +4282,16 @@ S:	Maintained
 F:	fs/logfs/
 
 LSILOGIC MPT FUSION DRIVERS (FC/SAS/SPI)
-M:	Eric Moore <Eric.Moore@lsi.com>
+M:	Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>
+M:	Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
 M:	support@lsi.com
 L:	DL-MPTFusionLinux@lsi.com
 L:	linux-scsi@vger.kernel.org
 W:	http://www.lsilogic.com/support
 S:	Supported
 F:	drivers/message/fusion/
+F:	drivers/scsi/mpt2sas/
+F:	drivers/scsi/mpt3sas/
 
 LSILOGIC/SYMBIOS/NCR 53C8XX and 53C1010 PCI-SCSI drivers
 M:	Matthew Wilcox <matthew@wil.cx>
