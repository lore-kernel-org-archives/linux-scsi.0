From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 06/20] qla2xxx: Select correct request queue for error type IOCB for ISPFX00.
Date: Fri, 13 Dec 2013 15:03:46 -0500
Message-ID: <1386965040-20611-7-git-send-email-saurav.kashyap@qlogic.com>
References: <1386965040-20611-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:24400 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753164Ab3LMUhG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Dec 2013 15:37:06 -0500
In-Reply-To: <1386965040-20611-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_mr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index 4542247..9839da8 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -2794,7 +2794,7 @@ qlafx00_error_entry(scsi_qla_host_t *vha, struct rsp_que *rsp,
 	srb_t *sp;
 	struct qla_hw_data *ha = vha->hw;
 	const char func[] = "ERROR-IOCB";
-	uint16_t que = MSW(pkt->handle);
+	uint16_t que = 0;
 	struct req_que *req = NULL;
 	int res = DID_ERROR << 16;
 
-- 
1.7.7

