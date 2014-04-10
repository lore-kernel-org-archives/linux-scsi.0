From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 5/6] qla4xxx: Fix smatch warning in func qla4xxx_conn_get_param
Date: Wed, 9 Apr 2014 21:12:28 -0400
Message-ID: <1397092349-25332-6-git-send-email-vikas.chaudhary@qlogic.com>
References: <1397092349-25332-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:29075 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933779AbaDJBvs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Apr 2014 21:51:48 -0400
In-Reply-To: <1397092349-25332-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, giridhar.malavali@qlogic.com, Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>

From: Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_os.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 592f293..9eef7d4 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -2879,7 +2879,6 @@ static int qla4xxx_conn_get_param(struct iscsi_cls_conn *cls_conn,
 	struct iscsi_conn *conn;
 	struct qla_conn *qla_conn;
 	struct sockaddr *dst_addr;
-	int len = 0;
 
 	conn = cls_conn->dd_data;
 	qla_conn = conn->dd_data;
@@ -2893,9 +2892,6 @@ static int qla4xxx_conn_get_param(struct iscsi_cls_conn *cls_conn,
 	default:
 		return iscsi_conn_get_param(cls_conn, param, buf);
 	}
-
-	return len;
-
 }
 
 int qla4xxx_get_ddb_index(struct scsi_qla_host *ha, uint16_t *ddb_index)
-- 
1.8.2.GIT

