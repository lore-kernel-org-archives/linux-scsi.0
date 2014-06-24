From: Andy Grover <agrover@redhat.com>
Subject: [PATCH RESEND] target: Fix a comment in emulate_evpd_86
Date: Mon, 23 Jun 2014 17:02:08 -0700
Message-ID: <1403568128-13929-1-git-send-email-agrover@redhat.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, hch@lst.de, nab@linux-iscsi.org
List-Id: linux-scsi@vger.kernel.org

Fix comment to make it clear that check_dev_wce can return true if
emulation is in use, but also if it's *not* emulated but the underlying
device supports it.

Reviewed-by: Chris Leech <cleech@redhat.com>
Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/target/target_core_spc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index 6cd7222..dea057d 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -489,7 +489,7 @@ spc_emulate_evpd_86(struct se_cmd *cmd, unsigned char *buf)
 	/* Set HEADSUP, ORDSUP, SIMPSUP */
 	buf[5] = 0x07;
 
-	/* If WriteCache emulation is enabled, set V_SUP */
+	/* If WriteCache supported (or emulated), set V_SUP */
 	if (spc_check_dev_wce(dev))
 		buf[6] = 0x01;
 	/* If an LBA map is present set R_SUP */
-- 
1.9.3
