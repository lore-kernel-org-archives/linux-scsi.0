From: ChinmayVS <cvs268@gmail.com>
Subject: [PATCH 1/1] Trivial cleanup : Updated sd_do_mode_sense() description
Date: Tue, 30 Jul 2013 20:12:40 +0800
Message-ID: <1375186360-16605-1-git-send-email-cvs268@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f53.google.com ([209.85.160.53]:41379 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287Ab3G3MNG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Jul 2013 08:13:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: trivial@kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

sd_do_mode_sense() is no longer called with a fixed length buffer.
Updated the descriptive comment to reflect the same.

Signed-off-by: ChinmayVS <cvs268@gmail.com>
---
 drivers/scsi/sd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index c1c5552..7890bec 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2231,7 +2231,7 @@ got_data:
 	sdkp->device->sector_size = sector_size;
 }
 
-/* called with buffer of length 512 */
+/* called with buffer of length len */
 static inline int
 sd_do_mode_sense(struct scsi_device *sdp, int dbd, int modepage,
 		 unsigned char *buffer, int len, struct scsi_mode_data *data,
-- 
1.8.1.2

