From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 024/103] target: Fix comment in __transport_execute_tasks()
Date: Thu, 21 Jul 2011 00:05:00 -0700
Message-ID: <1311231979-6631-25-git-send-email-nab@linux-iscsi.org>
References: <1311231979-6631-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm15.bullet.mail.bf1.yahoo.com ([98.139.212.174]:36526 "HELO
	nm15.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752028Ab1GUHGp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2011 03:06:45 -0400
In-Reply-To: <1311231979-6631-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Andy Grover <agrover@redhat.com>

From: Andy Grover <agrover@redhat.com>

cmd->transport_emulate_cdb is used for a variety of purposes beyond
REPORT_LUNS currently, so update the comment explaining its use to
reflect this.

Signed-off-by: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index acb5ef7..a224010 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2576,7 +2576,7 @@ check_depth:
 	spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
 	/*
 	 * The struct se_cmd->transport_emulate_cdb() function pointer is used
-	 * to grab REPORT_LUNS CDBs before they hit the
+	 * to grab REPORT_LUNS and other CDBs we want to handle before they hit the
 	 * struct se_subsystem_api->do_task() caller below.
 	 */
 	if (cmd->transport_emulate_cdb) {
-- 
1.7.6

