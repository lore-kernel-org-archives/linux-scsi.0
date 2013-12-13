From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 04/20] qla2xxx: Use proper message for Non owner reset ACK Timeout.
Date: Fri, 13 Dec 2013 15:03:44 -0500
Message-ID: <1386965040-20611-5-git-send-email-saurav.kashyap@qlogic.com>
References: <1386965040-20611-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:16414 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753284Ab3LMUhG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Dec 2013 15:37:06 -0500
In-Reply-To: <1386965040-20611-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Atul Deshmukh <atul.deshmukh@qlogic.com>

Signed-off-by: Atul Deshmukh <atul.deshmukh@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_nx2.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx2.c b/drivers/scsi/qla2xxx/qla_nx2.c
index b45f4d7..eda7787 100644
--- a/drivers/scsi/qla2xxx/qla_nx2.c
+++ b/drivers/scsi/qla2xxx/qla_nx2.c
@@ -1578,8 +1578,8 @@ qla8044_need_reset_handler(struct scsi_qla_host *vha)
 		do {
 			if (time_after_eq(jiffies, dev_init_timeout)) {
 				ql_log(ql_log_info, vha, 0xb0c4,
-				    "%s: Non Reset owner DEV INIT "
-				    "TIMEOUT!\n", __func__);
+				    "%s: Non Reset owner: "
+				    "Reset Ack Timeout!\n", __func__);
 				break;
 			}
 
-- 
1.7.7

