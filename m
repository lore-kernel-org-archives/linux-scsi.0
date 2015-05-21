From: james.smart@avagotech.com (James Smart)
Subject: [PATCH v2 14/15] lpfc: Change buffer pool empty message to
 miscellaneous category
Date: Thu, 21 May 2015 13:55:30 -0400
Message-ID: <555e1c12.xDeQ/xMo+I/wxFzX%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qg0-f53.google.com ([209.85.192.53]:35784 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964810AbbEURzf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 May 2015 13:55:35 -0400
Received: by qgew3 with SMTP id w3so45155839qge.2
        for <linux-scsi@vger.kernel.org>; Thu, 21 May 2015 10:55:34 -0700 (PDT)
Received: from myfc17 (c-75-67-235-135.hsd1.nh.comcast.net. [75.67.235.135])
        by mx.google.com with ESMTPSA id m73sm4783011qkh.26.2015.05.21.10.55.34
        for <linux-scsi@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Thu, 21 May 2015 10:55:34 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Change buffer pool empty message to miscellaneous category

Signed-off-by: Dick Kennedy <dick.kennedy@avagotech.com>
Signed-off-by: James Smart <james.smart@avagotech.com>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index c140f99..116df9c 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -4537,7 +4537,7 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 	if (lpfc_cmd == NULL) {
 		lpfc_rampdown_queue_depth(phba);
 
-		lpfc_printf_vlog(vport, KERN_INFO, LOG_FCP,
+		lpfc_printf_vlog(vport, KERN_INFO, LOG_MISC,
 				 "0707 driver's buffer pool is empty, "
 				 "IO busied\n");
 		goto out_host_busy;
-- 
1.7.11.7

