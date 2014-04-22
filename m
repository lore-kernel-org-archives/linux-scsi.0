From: Marek Vasut <marex@denx.de>
Subject: [PATCH V2] [SCSI] esas2r: Fix comment
Date: Tue, 22 Apr 2014 20:23:39 +0200
Message-ID: <1398191019-5018-1-git-send-email-marex@denx.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:60426 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303AbaDVSXq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Apr 2014 14:23:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Marek Vasut <marex@denx.de>, James Bottomley <JBottomley@Parallels.com>, Bradley Grove <bgrove@attotech.com>, Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

Minor fix for a message in the driver so that it matches the function name.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: James Bottomley <JBottomley@Parallels.com>
Cc: Bradley Grove <bgrove@attotech.com>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
---
 drivers/scsi/esas2r/esas2r_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

V2: Post to linux-scsi, tweak the commit message.

diff --git a/drivers/scsi/esas2r/esas2r_main.c b/drivers/scsi/esas2r/esas2r_main.c
index f37f3e3..6504a19 100644
--- a/drivers/scsi/esas2r/esas2r_main.c
+++ b/drivers/scsi/esas2r/esas2r_main.c
@@ -390,7 +390,7 @@ static int esas2r_probe(struct pci_dev *pcid,
 	esas2r_log_dev(ESAS2R_LOG_INFO, &(pcid->dev),
 		       "pci_enable_device() OK");
 	esas2r_log_dev(ESAS2R_LOG_INFO, &(pcid->dev),
-		       "after pci_device_enable() enable_cnt: %d",
+		       "after pci_enable_device() enable_cnt: %d",
 		       pcid->enable_cnt.counter);
 
 	host = scsi_host_alloc(&driver_template, host_alloc_size);
-- 
1.8.5.3

