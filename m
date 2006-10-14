From: Sergey Kononenko <sergk@center.hqhost.net>
Subject: [PATCH 1/2] aic94xx: Supermicro motherboards support (PCI id)
Date: Sun, 15 Oct 2006 02:34:44 +0300
Message-ID: <20061015023444.44468dc7@manowar.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ukrtel-nat.ua-online.net ([213.179.225.5]:46035 "EHLO
	center.hqhost.net") by vger.kernel.org with ESMTP id S1752235AbWJNXer
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 14 Oct 2006 19:34:47 -0400
Received: from manowar.localnet (Debian-exim@[10.20.30.81])
	by center.hqhost.net (8.13.6/8.13.6/Debian-1) with ESMTP id k9ENZNH3030696
	for <linux-scsi@vger.kernel.org>; Sun, 15 Oct 2006 02:35:23 +0300
Received: from localhost
	([127.0.0.1] helo=manowar.localnet ident=sergk)
	by manowar.localnet with esmtp (Exim 4.63)
	(envelope-from <sergk@center.hqhost.net>)
	id 1GYt1g-00032Z-VR
	for linux-scsi@vger.kernel.org; Sun, 15 Oct 2006 02:34:46 +0300
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Add PCI id.

Signed-off-by: Sergey Kononenko <sergk@sergk.org.ua>

diff -urN linux-2.6.19-rc2/drivers/scsi/aic94xx/aic94xx_hwi.h \
        linux-2.6.19-rc2.patched/drivers/scsi/aic94xx/aic94xx_hwi.h
--- linux-2.6.19-rc2/drivers/scsi/aic94xx/aic94xx_hwi.h 2006-10-14 \
        21:11:59.000000000 +0000
+++ linux-2.6.19-rc2.patched/drivers/scsi/aic94xx/aic94xx_hwi.h \
        2006-10-14 02:15:16.000000000 +0000
@@ -46,6 +46,7 @@
 #define PCI_DEVICE_ID_ADAPTEC2_RAZOR10 0x410
 #define PCI_DEVICE_ID_ADAPTEC2_RAZOR12 0x412
 #define PCI_DEVICE_ID_ADAPTEC2_RAZOR1E 0x41E
+#define PCI_DEVICE_ID_ADAPTEC2_RAZOR1F 0x41F
 #define PCI_DEVICE_ID_ADAPTEC2_RAZOR30 0x430
 #define PCI_DEVICE_ID_ADAPTEC2_RAZOR32 0x432
 #define PCI_DEVICE_ID_ADAPTEC2_RAZOR3E 0x43E
diff -urN linux-2.6.19-rc2/drivers/scsi/aic94xx/aic94xx_init.c \
        linux-2.6.19-rc2.patched/drivers/scsi/aic94xx/aic94xx_init.c
--- linux-2.6.19-rc2/drivers/scsi/aic94xx/aic94xx_init.c 2006-10-14 \
        21:11:59.000000000 +0000
+++ linux-2.6.19-rc2.patched/drivers/scsi/aic94xx/aic94xx_init.c
2006-10-14 \ 02:15:16.000000000 +0000
@@ -814,6 +814,8 @@
         0, 0, 1},
        {PCI_DEVICE(PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_RAZOR1E),
         0, 0, 1},
+       {PCI_DEVICE(PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_RAZOR1F),
+        0, 0, 1},
        {PCI_DEVICE(PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_RAZOR30),
         0, 0, 2},
        {PCI_DEVICE(PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_RAZOR32),

--
Sergey Kononenko
