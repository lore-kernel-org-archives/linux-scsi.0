From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 6/6] target: tcm_loop: Use seq_puts() in tcm_loop_show_info()
Date: Mon, 11 Dec 2017 11:48:29 +0100
Message-ID: <0ea85e80-f7a7-eeff-18c2-206281b74ea5@users.sourceforge.net>
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
Date: Mon, 11 Dec 2017 11:01:57 +0100

The script "checkpatch.pl" pointed information out like the following.

WARNING: Prefer seq_puts to seq_printf

Thus fix the affected source code place.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/target/loopback/tcm_loop.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index ec01070bbb40..9cd4ffe76c07 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -64,7 +64,7 @@ static void tcm_loop_release_cmd(struct se_cmd *se_cmd)
 
 static int tcm_loop_show_info(struct seq_file *m, struct Scsi_Host *host)
 {
-	seq_printf(m, "tcm_loop_proc_info()\n");
+	seq_puts(m, "tcm_loop_proc_info()\n");
 	return 0;
 }
 
-- 
2.15.1
