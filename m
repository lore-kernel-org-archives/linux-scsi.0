From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 053/103] target: Move task_sg_num next to task_sg in struct se_task
Date: Thu, 21 Jul 2011 00:08:05 -0700
Message-ID: <1311232135-6653-54-git-send-email-nab@linux-iscsi.org>
References: <1311232135-6653-32-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm19-vm0.access.bullet.mail.sp2.yahoo.com ([98.139.44.172]:26280
	"HELO nm19-vm0.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751924Ab1GUHEu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2011 03:04:50 -0400
In-Reply-To: <1311232135-6653-32-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Andy Grover <agrover@redhat.com>

From: Andy Grover <agrover@redhat.com>

Also, remove task_sg_offset, which is unused.

Signed-off-by: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 include/target/target_core_base.h |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index ff1b461..77f570d 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -462,6 +462,7 @@ struct se_transport_task {
 struct se_task {
 	unsigned char	task_sense;
 	struct scatterlist *task_sg;
+	u32		task_sg_num;
 	struct scatterlist *task_sg_bidi;
 	u8		task_scsi_status;
 	u8		task_flags;
@@ -472,8 +473,6 @@ struct se_task {
 	u32		task_no;
 	u32		task_sectors;
 	u32		task_size;
-	u32		task_sg_num;
-	u32		task_sg_offset;
 	enum dma_data_direction	task_data_direction;
 	struct se_cmd *task_se_cmd;
 	struct se_device	*se_dev;
-- 
1.7.6

