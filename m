From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH v2 01/11] qla2xxx: Remove unneeded link offline message.
Date: Wed, 27 Jan 2016 12:03:28 -0500
Message-ID: <1453914218-380-2-git-send-email-himanshu.madhani@qlogic.com>
References: <1453914218-380-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:36954 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933720AbcA0RqA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Jan 2016 12:46:00 -0500
In-Reply-To: <1453914218-380-1-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: giridhar.malavali@qlogic.com, himanshu.madhani@qlogic.com, linux-scsi@vger.kernel.org

From: Chad Dupuis <chad.dupuis@qlogic.com>

Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c |    1 +
 drivers/scsi/qla2xxx/qla_isr.c |    4 ----
 2 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index cd0d94e..9e714cc 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -27,6 +27,7 @@
  * |                              |                    | 0x303a		|
  * | DPC Thread                   |       0x4023       | 0x4002,0x4013  |
  * | Async Events                 |       0x5089       | 0x502b-0x502f  |
+ * |                              |                    | 0x505e         |
  * |                              |                    | 0x5084,0x5075	|
  * |                              |                    | 0x503d,0x5044  |
  * |                              |                    | 0x507b,0x505f	|
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index d4d65eb..edd97de 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -934,10 +934,6 @@ skip_rio:
 			break;
 
 global_port_update:
-			/* Port unavailable. */
-			ql_log(ql_log_warn, vha, 0x505e,
-			    "Link is offline.\n");
-
 			if (atomic_read(&vha->loop_state) != LOOP_DOWN) {
 				atomic_set(&vha->loop_state, LOOP_DOWN);
 				atomic_set(&vha->loop_down_timer,
-- 
1.7.7

