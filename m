From: Colin King <colin.king@canonical.com>
Subject: [PATCH] iscsi-target: fix spelling mistake "Unsolicitied" -> "Unsolicited"
Date: Fri,  2 Sep 2016 15:30:34 +0100
Message-ID: <20160902143034.28990-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A . Bellinger" <nab@linux-iscsi.org>, Varun Prakash <varun@chelsio.com>, Sagi Grimberg <sagi@grimberg.me>, Bart Van Assche <bart.vanassche@sandisk.com>, Herbert Xu <herbert@gondor.apana.org.au>, Feng Li <lifeng1519@gmail.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistakes in pr_debug message and comments

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/target/iscsi/iscsi_target.c       | 2 +-
 drivers/target/iscsi/iscsi_target_login.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 39b928c..1aaf1f3 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -2982,7 +2982,7 @@ iscsit_build_nopin_rsp(struct iscsi_cmd *cmd, struct iscsi_conn *conn,
 
 	pr_debug("Built NOPIN %s Response ITT: 0x%08x, TTT: 0x%08x,"
 		" StatSN: 0x%08x, Length %u\n", (nopout_response) ?
-		"Solicitied" : "Unsolicitied", cmd->init_task_tag,
+		"Solicited" : "Unsolicited", cmd->init_task_tag,
 		cmd->targ_xfer_tag, cmd->stat_sn, cmd->buf_ptr_size);
 }
 EXPORT_SYMBOL(iscsit_build_nopin_rsp);
diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index e1b4caf..78b0d5e 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -434,7 +434,7 @@ static int iscsi_login_zero_tsih_s2(
 
 		/*
 		 * Make MaxRecvDataSegmentLength PAGE_SIZE aligned for
-		 * Immediate Data + Unsolicitied Data-OUT if necessary..
+		 * Immediate Data + Unsolicited Data-OUT if necessary..
 		 */
 		param = iscsi_find_param_from_key("MaxRecvDataSegmentLength",
 						  conn->param_list);
@@ -646,7 +646,7 @@ static void iscsi_post_login_start_timers(struct iscsi_conn *conn)
 {
 	struct iscsi_session *sess = conn->sess;
 	/*
-	 * FIXME: Unsolicitied NopIN support for ISER
+	 * FIXME: Unsolicited NopIN support for ISER
 	 */
 	if (conn->conn_transport->transport_type == ISCSI_INFINIBAND)
 		return;
-- 
2.9.3
