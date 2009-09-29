From: "Ed Lin" <ed.lin@promise.com>
Subject: [PATCH 3/3] stex: update version to 4.6.0000.4
Date: Mon, 28 Sep 2009 22:58:36 -0800
Message-ID: <200909282258362762245@promise.com>
Reply-To: ed.lin@promise.com
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gateway.promise.com ([67.111.72.2]:57248 "EHLO
	nonamew.ptu.promise.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751636AbZI2GNj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Sep 2009 02:13:39 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James.Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, promise_linux <promise_linux@promise.com>

Update version to 4.6.0000.4.

Signed-off-by: Ed Lin <ed.lin@promise.com>
---

 drivers/scsi/stex.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 79216ee..3058bb1 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -36,11 +36,11 @@
 #include <scsi/scsi_eh.h>
 
 #define DRV_NAME "stex"
-#define ST_DRIVER_VERSION "4.6.0000.3"
+#define ST_DRIVER_VERSION "4.6.0000.4"
 #define ST_VER_MAJOR		4
 #define ST_VER_MINOR		6
 #define ST_OEM			0
-#define ST_BUILD_VER		3
+#define ST_BUILD_VER		4
 
 enum {
 	/* MU register offset */
@@ -1488,8 +1488,8 @@ static int stex_set_dma_mask(struct pci_dev * pdev)
 {
 	int ret;
 
-	if (!pci_set_dma_mask(pdev,  DMA_BIT_MASK(64))
-		&& !pci_set_consistent_dma_mask(pdev,  DMA_BIT_MASK(64)))
+	if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(64))
+		&& !pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64)))
 		return 0;
 	ret = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 	if (!ret)


