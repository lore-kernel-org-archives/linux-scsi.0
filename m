From: Fabian Frederick <fabf@skynet.be>
Subject: Fw: [PATCH 1/1 RESEND] drivers/scsi/sd.c: remove positive test on
 unsigned value
Date: Sat, 10 May 2014 17:45:14 +0200
Message-ID: <20140510174514.0c21d49738bcc5973724bed6@skynet.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:29183 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752919AbaEJPpU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 May 2014 11:45:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

val is unsigned.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/scsi/sd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index efcbcd1..b54d4f8 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -296,7 +296,7 @@ protection_type_store(struct device *dev, struct device_attribute *attr,
 	if (err)
 		return err;
 
-	if (val >= 0 && val <= SD_DIF_TYPE3_PROTECTION)
+	if (val <= SD_DIF_TYPE3_PROTECTION)
 		sdkp->protection_type = val;
 
 	return count;
-- 
1.8.4.5

