From: Jon Mason <jdmason@kudzu.us>
Subject: [PATCH 5/5] gdt: remove unnecessary #defines
Date: Mon, 27 Jun 2011 13:04:40 -0500
Message-ID: <1309197880-16961-1-git-send-email-jdmason@kudzu.us>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33350 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997Ab1F0SEp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jun 2011 14:04:45 -0400
Received: by pzk9 with SMTP id 9so3114692pzk.19
        for <linux-scsi@vger.kernel.org>; Mon, 27 Jun 2011 11:04:45 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Achim Leubner <achim_leubner@adaptec.com>
Cc: linux-scsi@vger.kernel.org

Remove PCI vendor IDs, as they are already defined in pci_ids.h.

Signed-off-by: Jon Mason <jdmason@kudzu.us>
---
 drivers/scsi/gdth.h |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/gdth.h b/drivers/scsi/gdth.h
index d969855..c1b0108 100644
--- a/drivers/scsi/gdth.h
+++ b/drivers/scsi/gdth.h
@@ -49,15 +49,6 @@
 /* GDT_ISA */
 #define GDT2_ID         0x0120941c              /* GDT2000/2020 */
 
-/* vendor ID, device IDs (PCI) */
-/* these defines should already exist in <linux/pci.h> */
-#ifndef PCI_VENDOR_ID_VORTEX
-#define PCI_VENDOR_ID_VORTEX            0x1119  /* PCI controller vendor ID */
-#endif
-#ifndef PCI_VENDOR_ID_INTEL
-#define PCI_VENDOR_ID_INTEL             0x8086  
-#endif
-
 #ifndef PCI_DEVICE_ID_VORTEX_GDT60x0
 /* GDT_PCI */
 #define PCI_DEVICE_ID_VORTEX_GDT60x0    0       /* GDT6000/6020/6050 */
-- 
1.7.5.4

