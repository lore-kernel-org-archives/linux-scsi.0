From: "Moore, Eric Dean" <Emoore@lsil.com>
Subject: FW: [PATCH] 2.6.2-rc2 - MPT Fusion driver 3.00.02 update
Date: Tue, 3 Feb 2004 10:59:26 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E5703D1A34C@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:32688 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S266031AbUBCP7k (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Feb 2004 10:59:40 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@SteelEye.com

I have fixed a minor compilation bug in the 3.00.02 MPT Fusion
driver posted last week.  The bug is shown below in the diff.

You can download full source and 3.00.02 patches here:
ftp://ftp.lsil.com/HostAdapterDrivers/linux/Fusion-MPT/2.6-patches/3.00.02


diff -uarN fusion-reference/mptbase.c fusion/mptbase.c
--- fusion-reference/mptbase.c	2004-02-02 04:33:27.000000000 -0700
+++ fusion/mptbase.c	2004-02-02 11:46:15.117682656 -0700
@@ -1551,7 +1551,7 @@
 	Q_DEL_ITEM(ioc);
 	mpt_adapter_dispose(ioc);
 
-	mptscsih_sync_irq(ioc->irq);
+	mptscsih_sync_irq(pdev->irq);
 	pci_set_drvdata(pdev, NULL);
 }
 

