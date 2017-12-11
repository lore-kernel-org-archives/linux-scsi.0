From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 5/6] target: tcm_loop: Delete an unnecessary return statement
 in tcm_loop_submission_work()
Date: Mon, 11 Dec 2017 11:46:51 +0100
Message-ID: <9643f835-78e6-51cc-3d07-7a43a3c5eb07@users.sourceforge.net>
References: <42f13f0c-ae1d-ec1e-fd9d-62dd15aeba8c@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <42f13f0c-ae1d-ec1e-fd9d-62dd15aeba8c@users.sourceforge.net>
Content-Language: en-GB
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 11 Dec 2017 10:58:33 +0100

The script "checkpatch.pl" pointed information out like the following.

WARNING: void function return statements are not generally useful

Thus remove such a statement in the affected function.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/target/loopback/tcm_loop.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 08dbf5b4ff15..ec01070bbb40 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -166,7 +166,6 @@ static void tcm_loop_submission_work(struct work_struct *work)
 out_done:
 	kmem_cache_free(tcm_loop_cmd_cache, tl_cmd);
 	sc->scsi_done(sc);
-	return;
 }
 
 /*
-- 
2.15.1
