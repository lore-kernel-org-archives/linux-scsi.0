From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 1/2] qla2xxx: Fix sparse warnings in qlafx00_fxdisc_iocb function.
Date: Fri, 12 Jul 2013 14:47:50 -0400
Message-ID: <1373654871-29081-2-git-send-email-saurav.kashyap@qlogic.com>
References: <1373654871-29081-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:23788
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753009Ab3GLTOs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Jul 2013 15:14:48 -0400
Received: from mail53-ch1 (localhost [127.0.0.1])	by mail53-ch1-R.bigfish.com
 (Postfix) with ESMTP id 2157A4008BC	for <linux-scsi@vger.kernel.org>; Fri, 12
 Jul 2013 19:14:47 +0000 (UTC)
Received: from CH1EHSMHS036.bigfish.com (snatpool1.int.messaging.microsoft.com
 [10.43.68.245])	by mail53-ch1.bigfish.com (Postfix) with ESMTP id 06612300049
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jul 2013 19:14:45 +0000 (UTC)
In-Reply-To: <1373654871-29081-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_mr.h |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mr.h b/drivers/scsi/qla2xxx/qla_mr.h
index 1a092af..179f8e4 100644
--- a/drivers/scsi/qla2xxx/qla_mr.h
+++ b/drivers/scsi/qla2xxx/qla_mr.h
@@ -434,9 +434,11 @@ struct qla_mt_iocb_rqst_fx00 {
 
 	__le32 dataword_extra;
 
-	__le32 req_len;
+	__le16 req_len;
+	__le16 reserved_2;
 
-	__le32 rsp_len;
+	__le16 rsp_len;
+	__le16 reserved_3;
 };
 
 struct qla_mt_iocb_rsp_fx00 {
-- 
1.7.7


