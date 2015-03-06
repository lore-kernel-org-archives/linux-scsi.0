From: Tapasweni Pathak <tapaswenipathak@gmail.com>
Subject: [PATCH] drivers: scsi: Remove null check on sdkp
Date: Fri, 6 Mar 2015 08:06:49 +0530
Message-ID: <20150306023649.GA6316@kt-Inspiron-3542>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:44355 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168AbbCFCgz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Mar 2015 21:36:55 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr, tapaswenipathak@gmail.com

Remove null check on sdkp as it won't be null at this line.

Signed-off-by: Tapasweni Pathak <tapaswenipathak@gmail.com>
Acked-by; Julia Lawall <julia.lawall@lip6.fr>
---
 drivers/scsi/sd_dif.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/scsi/sd_dif.c b/drivers/scsi/sd_dif.c
index 14c7d42..2190639 100644
--- a/drivers/scsi/sd_dif.c
+++ b/drivers/scsi/sd_dif.c
@@ -77,9 +77,6 @@ void sd_dif_config_host(struct scsi_disk *sdkp)

 		disk->integrity->flags |= BLK_INTEGRITY_DEVICE_CAPABLE;

-		if (!sdkp)
-			return;
-
 		if (type == SD_DIF_TYPE3_PROTECTION)
 			disk->integrity->tag_size = sizeof(u16) + sizeof(u32);
 		else
--
1.7.9.5

