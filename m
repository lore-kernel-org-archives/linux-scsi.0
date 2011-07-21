From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 025/103] target: Misc style cleanups
Date: Thu, 21 Jul 2011 00:05:01 -0700
Message-ID: <1311231979-6631-26-git-send-email-nab@linux-iscsi.org>
References: <1311231979-6631-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm4.bullet.mail.bf1.yahoo.com ([98.139.212.163]:39713 "HELO
	nm4.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752258Ab1GUHHI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2011 03:07:08 -0400
In-Reply-To: <1311231979-6631-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Andy Grover <agrover@redhat.com>

From: Andy Grover <agrover@redhat.com>

Typo

Local variables should be declared on separate lines (simplifies diffs)

Prefer (!foo) over (foo == 0)

Signed-off-by: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index a224010..101bc20 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -644,7 +644,7 @@ static int transport_cmd_check_stop(
 	}
 	/*
 	 * Determine if frontend context caller is requesting the stopping of
-	 * this command for frontend excpections.
+	 * this command for frontend exceptions.
 	 */
 	if (atomic_read(&T_TASK(cmd)->t_transport_stop)) {
 		DEBUG_CS("%s:%d atomic_read(&T_TASK(cmd)->t_transport_stop) =="
@@ -1314,7 +1314,8 @@ int transport_dump_vpd_assoc(
 	int p_buf_len)
 {
 	unsigned char buf[VPD_TMP_BUF_SIZE];
-	int ret = 0, len;
+	int ret = 0;
+	int len;
 
 	memset(buf, 0, VPD_TMP_BUF_SIZE);
 	len = sprintf(buf, "T10 VPD Identifier Association: ");
@@ -1361,7 +1362,8 @@ int transport_dump_vpd_ident_type(
 	int p_buf_len)
 {
 	unsigned char buf[VPD_TMP_BUF_SIZE];
-	int ret = 0, len;
+	int ret = 0;
+	int len;
 
 	memset(buf, 0, VPD_TMP_BUF_SIZE);
 	len = sprintf(buf, "T10 VPD Identifier Type: ");
@@ -2510,7 +2512,7 @@ static int transport_execute_tasks(struct se_cmd *cmd)
 		 * attribute for the tasks of the received struct se_cmd CDB
 		 */
 		add_tasks = transport_execute_task_attr(cmd);
-		if (add_tasks == 0)
+		if (!add_tasks)
 			goto execute_tasks;
 		/*
 		 * This calls transport_add_tasks_from_cmd() to handle
-- 
1.7.6

