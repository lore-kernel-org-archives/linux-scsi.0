From: Andi Kleen <ak@muc.de>
Subject: [PATCH] Mark Workbit NinjaSCSI driver non 64bit
Date: Thu, 1 Jan 2004 22:58:35 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040101215835.GA3001@averell>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pD9526784.dip.t-dialin.net ([217.82.103.132]:30080 "EHLO
	fred.muc.de") by vger.kernel.org with ESMTP id S265450AbUAAV6i
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Jan 2004 16:58:38 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: gotom@debian.or.jp


Judging from the warnings it spews out on a 64bit compilation on AMD64
it is not 64bit clean.  Mark it as such in Kconfig.

Better would be of course to fix it.

-Andi

diff -burpN -X ../KDIFX linux-2.6.1-rc1/drivers/scsi/Kconfig linux-2.6.1-rc1-amd64/drivers/scsi/Kconfig
--- linux-2.6.1-rc1/drivers/scsi/Kconfig	2004-01-01 06:25:23.000000000 +0100
+++ linux-2.6.1-rc1-amd64/drivers/scsi/Kconfig	2004-01-01 06:56:50.000000000 +0100
@@ -1388,7 +1388,7 @@ config SCSI_ULTRASTOR
 
 config SCSI_NSP32
 	tristate "Workbit NinjaSCSI-32Bi/UDE support"
-	depends on PCI && SCSI
+	depends on PCI && SCSI && !64BIT
 	help
 	  This is support for the Workbit NinjaSCSI-32Bi/UDE PCI/Cardbus
 	  SCSI host adapter. Please read the SCSI-HOWTO, available from
