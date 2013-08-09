From: ChinmayVS <cvs268@gmail.com>
Subject: [PATCH 1/1] Updated sd_do_mode_sense() description
Date: Fri,  9 Aug 2013 10:13:22 +0800
Message-ID: <1376014402-16494-1-git-send-email-cvs268@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:36133 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967635Ab3HICMu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Aug 2013 22:12:50 -0400
Received: by mail-pa0-f45.google.com with SMTP id bg4so4392439pad.18
        for <linux-scsi@vger.kernel.org>; Thu, 08 Aug 2013 19:12:49 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: trivial@kernel.org, linux-scsi@vger.kernel.org, sfr@canb.auug.org.au

sd_do_mode_sense() is no longer called with a fixed length buffer.
Updated its description to reflect the same.

Signed-off-by: ChinmayVS <cvs268@gmail.com>
---
 drivers/scsi/sd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index b58e8f8..b183347 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2237,7 +2237,7 @@ got_data:
 	sdkp->device->sector_size = sector_size;
 }
 
-/* called with buffer of length 512 */
+/* called with buffer of length len */
 static inline int
 sd_do_mode_sense(struct scsi_device *sdp, int dbd, int modepage,
 		 unsigned char *buffer, int len, struct scsi_mode_data *data,
-- 
1.8.1.2

