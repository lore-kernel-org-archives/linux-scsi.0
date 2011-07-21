From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 056/103] target: Remove unused members of se_cmd
Date: Thu, 21 Jul 2011 00:08:08 -0700
Message-ID: <1311232135-6653-57-git-send-email-nab@linux-iscsi.org>
References: <1311232135-6653-32-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm22-vm0.access.bullet.mail.sp2.yahoo.com ([98.139.44.178]:24906
	"HELO nm22-vm0.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751925Ab1GUHFE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2011 03:05:04 -0400
In-Reply-To: <1311232135-6653-32-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Andy Grover <agrover@redhat.com>

From: Andy Grover <agrover@redhat.com>

t_tasks_check
t_tasks_no (only incremented, never used)

Signed-off-by: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |    1 -
 include/target/target_core_base.h      |    2 --
 2 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 537d8f5..afb453c 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1669,7 +1669,6 @@ transport_generic_get_task(struct se_cmd *cmd,
 	INIT_LIST_HEAD(&task->t_execute_list);
 	INIT_LIST_HEAD(&task->t_state_list);
 	init_completion(&task->task_stop_comp);
-	task->task_no = cmd->t_tasks_no++;
 	task->task_se_cmd = cmd;
 	task->se_dev = dev;
 	task->task_data_direction = data_direction;
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 3bac5e0..d2b1067 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -491,8 +491,6 @@ struct se_cmd {
 	int			t_tasks_fua;
 	bool			t_tasks_bidi;
 	u32			t_task_cdbs;
-	u32			t_tasks_check;
-	u32			t_tasks_no;
 	u32			t_tasks_se_num;
 	u32			t_tasks_se_bidi_num;
 	u32			t_tasks_sg_chained_no;
-- 
1.7.6

