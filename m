From: Colin King <colin.king@canonical.com>
Subject: [PATCH] target: fix spelling mistake and unwrap multi-line text
Date: Mon,  7 Nov 2016 16:31:21 +0000
Message-ID: <20161107163121.23559-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A . Bellinger" <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistake "Obselete" to "Obsolete"
in error message and also turn multi-line text into one
line.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/target/target_core_pr.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 47463c9..0cd38af 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -253,8 +253,7 @@ target_scsi2_reservation_reserve(struct se_cmd *cmd)
 
 	if ((cmd->t_task_cdb[1] & 0x01) &&
 	    (cmd->t_task_cdb[1] & 0x02)) {
-		pr_err("LongIO and Obselete Bits set, returning"
-				" ILLEGAL_REQUEST\n");
+		pr_err("LongIO and Obsolete Bits set, returning ILLEGAL_REQUEST\n");
 		return TCM_UNSUPPORTED_SCSI_OPCODE;
 	}
 	/*
-- 
2.9.3
