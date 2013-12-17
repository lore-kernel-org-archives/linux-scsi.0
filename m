From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH V2 06/20] qla2xxx: Select correct request queue for error type IOCB for ISPFX00.
Date: Mon, 16 Dec 2013 22:28:29 -0500
Message-ID: <1387250923-1041-7-git-send-email-saurav.kashyap@qlogic.com>
References: <1387250923-1041-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:57105 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752736Ab3LQECK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Dec 2013 23:02:10 -0500
In-Reply-To: <1387250923-1041-1-git-send-email-saurav.kashyap@qlogic.com>
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

