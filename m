From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH 10/19] sd: Fix indentation
Date: Wed, 23 Aug 2017 14:40:00 -0700
Message-ID: <20170823214009.15015-11-bart.vanassche@wdc.com>
References: <20170823214009.15015-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:60815 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750962AbdHWVmj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Aug 2017 17:42:39 -0400
In-Reply-To: <20170823214009.15015-1-bart.vanassche@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>

This patch avoids that smatch reports the following:

drivers/scsi/sd.c:3540: sd_suspend_common() warn: inconsistent indenting

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/sd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index a88639fbedb3..8b3d7994e182 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3537,7 +3537,7 @@ static int sd_suspend_common(struct device *dev, bool ignore_stop_errors)
 			 * doesn't support sync. There's not much to do and
 			 * suspend shouldn't fail.
 			 */
-			 ret = 0;
+			ret = 0;
 		}
 	}
 
-- 
2.14.0
