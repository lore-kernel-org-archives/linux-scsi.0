From: Miguel Bernal Marin <miguel.bernal.marin@linux.intel.com>
Subject: [PATCH] scsi: storvsc: remove return at end of void function
Date: Thu, 16 Mar 2017 00:59:57 -0600
Message-ID: <20170316065957.13405-1-miguel.bernal.marin@linux.intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:22909 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751093AbdCPHAI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Mar 2017 03:00:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "K. Y. Srinivasan" <kys@microsoft.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, devel@linuxdriverproject.org, Haiyang Zhang <haiyangz@microsoft.com>, Stephen Hemminger <sthemmin@microsoft.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>

storvsc_on_channel_callback is a void function and the return
statement at the end is not useful.

Found with checkpatch.

Signed-off-by: Miguel Bernal Marin <miguel.bernal.marin@linux.intel.com>
---
 drivers/scsi/storvsc_drv.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 3d70d1cf49a3..538f3e131275 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1191,8 +1191,6 @@ static void storvsc_on_channel_callback(void *context)
 			break;
 		}
 	} while (1);
-
-	return;
 }
 
 static int storvsc_connect_to_vsp(struct hv_device *device, u32 ring_size,
-- 
2.12.0
