From: James Smart <james.smart@emulex.com>
Subject: [PATCH 06/12] lpfc 8.3.34: Correct typecasts for snprintf messages
Date: Tue, 14 Aug 2012 14:25:59 -0400
Message-ID: <1344968759.4432.21.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:24936 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754521Ab2HNS0W (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Aug 2012 14:26:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Correct typecasts for snprintf messages


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_debugfs.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
--- a/drivers/scsi/lpfc/lpfc_debugfs.c	2012-08-11 12:24:51.385924283 -0400
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c	2012-08-11 12:24:52.203924256 -0400
@@ -2045,7 +2045,7 @@ lpfc_idiag_queinfo_read(struct file *fil
 				"EQ-STAT[max:x%x noE:x%x "
 				"bs:x%x proc:x%llx]\n",
 				qp->q_cnt_1, qp->q_cnt_2,
-				qp->q_cnt_3, qp->q_cnt_4);
+				qp->q_cnt_3, (unsigned long long)qp->q_cnt_4);
 
 			len += snprintf(pbuffer+len,
 				LPFC_QUE_INFO_GET_BUF_SIZE-len,
@@ -2079,7 +2079,7 @@ proc_cq:
 				"xabt:x%x wq:x%llx]\n",
 				qp->assoc_qid,
 				qp->q_cnt_1, qp->q_cnt_2,
-				qp->q_cnt_3, qp->q_cnt_4);
+				qp->q_cnt_3, (unsigned long long)qp->q_cnt_4);
 			len += snprintf(pbuffer+len,
 				LPFC_QUE_INFO_GET_BUF_SIZE-len,
 				"\tCQID[%02d], "
@@ -2109,7 +2109,7 @@ proc_cq:
 				"AssocCQID[%02d]: "
 				"WQ-STAT[oflow:x%x posted:x%llx]\n",
 				qp->assoc_qid,
-				qp->q_cnt_1, qp->q_cnt_4);
+				qp->q_cnt_1, (unsigned long long)qp->q_cnt_4);
 			len += snprintf(pbuffer+len,
 				LPFC_QUE_INFO_GET_BUF_SIZE-len,
 				"\t\tWQID[%02d], "
@@ -2144,7 +2144,8 @@ proc_cq:
 					"xabt:x%x wq:x%llx]\n",
 					qp->assoc_qid,
 					qp->q_cnt_1, qp->q_cnt_2,
-					qp->q_cnt_3, qp->q_cnt_4);
+					qp->q_cnt_3,
+					(unsigned long long)qp->q_cnt_4);
 				len += snprintf(pbuffer+len,
 					LPFC_QUE_INFO_GET_BUF_SIZE-len,
 					"\tCQID[%02d], "
@@ -2198,7 +2199,8 @@ proc_cq:
 					"xabt:x%x wq:x%llx]\n",
 					qp->assoc_qid,
 					qp->q_cnt_1, qp->q_cnt_2,
-					qp->q_cnt_3, qp->q_cnt_4);
+					qp->q_cnt_3,
+					(unsigned long long)qp->q_cnt_4);
 				len += snprintf(pbuffer+len,
 					LPFC_QUE_INFO_GET_BUF_SIZE-len,
 					"\tCQID [%02d], "
@@ -2229,7 +2231,8 @@ proc_cq:
 					" WQ-STAT[oflow:x%x "
 					"posted:x%llx]\n",
 					qp->assoc_qid,
-					qp->q_cnt_1, qp->q_cnt_4);
+					qp->q_cnt_1,
+					(unsigned long long)qp->q_cnt_4);
 				len += snprintf(pbuffer+len,
 					LPFC_QUE_INFO_GET_BUF_SIZE-len,
 					"\t\tWQID[%02d], "
@@ -2259,7 +2262,8 @@ proc_cq:
 					"trunc:x%x rcv:x%llx]\n",
 					qp->assoc_qid,
 					qp->q_cnt_1, qp->q_cnt_2,
-					qp->q_cnt_3, qp->q_cnt_4);
+					qp->q_cnt_3,
+					(unsigned long long)qp->q_cnt_4);
 				len += snprintf(pbuffer+len,
 					LPFC_QUE_INFO_GET_BUF_SIZE-len,
 					"\t\tHQID[%02d], "



