From: Rob Evers <revers@redhat.com>
Subject: [PATCH RFC] increase ST_MAX_TAPES from 128 to 1024
Date: Fri, 17 Aug 2012 10:50:24 -0400
Message-ID: <1345215024-5883-1-git-send-email-revers@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46480 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755359Ab2HQOud (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Aug 2012 10:50:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai.Makisara@kolumbus.fi
Cc: jeffm@suse.com, lduncan@suse.com, linux-scsi@vger.kernel.org

Wondering if this would be an acceptable interim solution
to increasing the limit on the number of tape drives
while http://marc.info/?l=linux-scsi&m=134212042809524&w=2
gets sorted out.

Signed-off-by: Rob Evers <revers@redhat.com>
---
 drivers/scsi/st.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/st.h b/drivers/scsi/st.h
index b548923..408d24f 100644
--- a/drivers/scsi/st.h
+++ b/drivers/scsi/st.h
@@ -76,7 +76,7 @@ struct st_modedef {
 #define ST_MODE_SHIFT (7 - ST_NBR_MODE_BITS)
 #define ST_MODE_MASK ((ST_NBR_MODES - 1) << ST_MODE_SHIFT)
 
-#define ST_MAX_TAPES 128
+#define ST_MAX_TAPES 1024
 #define ST_MAX_TAPE_ENTRIES  (ST_MAX_TAPES << (ST_NBR_MODE_BITS + 1))
 
 /* The status related to each partition */
-- 
1.7.11.2

