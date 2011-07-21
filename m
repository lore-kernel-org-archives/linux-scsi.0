From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 058/103] target: Fix some spelling
Date: Thu, 21 Jul 2011 00:08:10 -0700
Message-ID: <1311232135-6653-59-git-send-email-nab@linux-iscsi.org>
References: <1311232135-6653-32-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm11-vm0.access.bullet.mail.sp2.yahoo.com ([98.139.44.124]:36767
	"HELO nm11-vm0.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751957Ab1GUHFS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2011 03:05:18 -0400
In-Reply-To: <1311232135-6653-32-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Andy Grover <agrover@redhat.com>

From: Andy Grover <agrover@redhat.com>

contiguous.

Signed-off-by: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 39e4b29..33e5275 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -3955,7 +3955,7 @@ int transport_generic_map_mem_to_cmd(
 			return -ENOSYS;
 		}
 		/*
-		 * For incoming CDBs using a contiguous buffer internall with TCM,
+		 * For incoming CDBs using a contiguous buffer internal with TCM,
 		 * save the passed struct scatterlist memory.  After TCM storage object
 		 * processing has completed for this struct se_cmd, TCM core will call
 		 * transport_memcpy_[write,read]_contig() as necessary from
@@ -4325,7 +4325,7 @@ int transport_map_mem_to_sg(
 
 	while (task_size != 0) {
 		/*
-		 * Setup the contigious array of scatterlists for
+		 * Setup the contiguous array of scatterlists for
 		 * this struct se_task.
 		 */
 		sg_assign_page(sg, se_mem->se_page);
@@ -4429,7 +4429,7 @@ void transport_do_task_sg_chain(struct se_cmd *cmd)
 	}
 	/*
 	 * Walk the struct se_task list and setup scatterlist chains
-	 * for each contiguosly allocated struct se_task->task_sg[].
+	 * for each contiguously allocated struct se_task->task_sg[].
 	 */
 	list_for_each_entry(task, &cmd->t_task_list, t_list) {
 		if (!(task->task_sg) || !(task->task_padded_sg))
@@ -4907,7 +4907,7 @@ static int transport_generic_write_pending(struct se_cmd *cmd)
 	/*
 	 * For the TCM control CDBs using a contiguous buffer, do the memcpy
 	 * from the passed Linux/SCSI struct scatterlist located at
-	 * se_cmd->t_task_pt_buf to the contiguous buffer at
+	 * se_cmd->t_task_pt_sgl to the contiguous buffer at
 	 * se_cmd->t_task_buf.
 	 */
 	if (cmd->se_cmd_flags & SCF_PASSTHROUGH_CONTIG_TO_SG)
-- 
1.7.6

