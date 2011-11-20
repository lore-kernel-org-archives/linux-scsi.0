From: Jesper Juhl <jj@chaosbits.net>
Subject: [PATCH][TRIVIAL] SCSI, qla2xxx: remove redundant semicolon
Date: Sun, 20 Nov 2011 22:34:15 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1111202231550.17395@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-driver@qlogic.com
Cc: linux-kernel@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, trivial@kernel.org
List-Id: linux-scsi@vger.kernel.org

One ';' at the end of the return statement is enough.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/scsi/qla2xxx/qla_nx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 94bded5..b9b3e5a 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -1055,7 +1055,7 @@ ql82xx_rom_lock_d(struct qla_hw_data *ha)
 		    "ROM lock failed.\n");
 		return -1;
 	}
-	return 0;;
+	return 0;
 }
 
 static int
-- 
1.7.7.3


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.
