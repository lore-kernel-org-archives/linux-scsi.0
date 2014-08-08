From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 1/2] qla2xxx: Move mailbox failure messages to a default debug level.
Date: Fri, 8 Aug 2014 07:38:08 -0400
Message-ID: <1407497889-4814-2-git-send-email-chad.dupuis@qlogic.com>
References: <1407497889-4814-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:24482 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756228AbaHHMKW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Aug 2014 08:10:22 -0400
In-Reply-To: <1407497889-4814-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, hch@lst.de
Cc: giridhar.malavali@qlogic.com

Move the mailbox failure messages to a default debugging level so that
benign failures won't flood the system logs but will still show up if
default debug messaging is enabled (ql2xextended_error_logging=1).

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index d9aafc0..a7a373f 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -373,7 +373,7 @@ premature_exit:
 
 mbx_done:
 	if (rval) {
-		ql_log(ql_log_warn, base_vha, 0x1020,
+		ql_dbg(ql_dbg_disc, base_vha, 0x1020,
 		    "**** Failed mbx[0]=%x, mb[1]=%x, mb[2]=%x, mb[3]=%x, cmd=%x ****.\n",
 		    mcp->mb[0], mcp->mb[1], mcp->mb[2], mcp->mb[3], command);
 	} else {
-- 
1.8.5.2

