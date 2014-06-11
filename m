From: Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 1/1] drivers/message/i2o/i2o_block.c: remove unnecessary test on unsigned value
Date: Wed, 11 Jun 2014 20:42:43 +0200
Message-ID: <1402512163-15639-1-git-send-email-fabf@skynet.be>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:46340 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752436AbaFKSoC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Jun 2014 14:44:02 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: aacraid@adaptec.com
Cc: Fabian Frederick <fabf@skynet.be>, linux-scsi@vger.kernel.org

unsigned value is never < 0

Cc: linux-scsi@vger.kernel.org
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/message/i2o/i2o_block.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/message/i2o/i2o_block.c b/drivers/message/i2o/i2o_block.c
index 6fc3866..2b684ec 100644
--- a/drivers/message/i2o/i2o_block.c
+++ b/drivers/message/i2o/i2o_block.c
@@ -671,7 +671,7 @@ static int i2o_block_ioctl(struct block_device *bdev, fmode_t mode,
 		break;
 	case BLKI2OSRSTRAT:
 		ret = -EINVAL;
-		if (arg < 0 || arg > CACHE_SMARTFETCH)
+		if (arg > CACHE_SMARTFETCH)
 			break;
 		dev->rcache = arg;
 		ret = 0;
-- 
1.8.4.5

