From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: target: fix spelling mistake "Uknown" -> "Unknown"
Date: Sat, 26 May 2018 16:02:29 +0100
Message-ID: <20180526150229.10416-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A . Bellinger" <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistake in pr_err message text

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/target/target_core_transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index bde14f46ed5b..f0e8f0f4ccb4 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -3366,7 +3366,7 @@ static void target_tmr_work(struct work_struct *work)
 		tmr->response = TMR_FUNCTION_REJECTED;
 		break;
 	default:
-		pr_err("Uknown TMR function: 0x%02x.\n",
+		pr_err("Unknown TMR function: 0x%02x.\n",
 				tmr->function);
 		tmr->response = TMR_FUNCTION_REJECTED;
 		break;
-- 
2.17.0
