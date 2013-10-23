From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] [SCSI] aic7xxx: remove duplicate define
Date: Wed, 23 Oct 2013 12:34:43 +0200
Message-ID: <1382524483-3167-1-git-send-email-michael.opdenacker@free-electrons.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: hare@suse.de, JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Michael Opdenacker <michael.opdenacker@free-electrons.com>
List-Id: linux-scsi@vger.kernel.org

Remove duplicate define
in drivers/scsi/aic7xxx/aicasm/aicasm_insformat.h

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 drivers/scsi/aic7xxx/aicasm/aicasm_insformat.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/aic7xxx/aicasm/aicasm_insformat.h b/drivers/scsi/aic7xxx/aicasm/aicasm_insformat.h
index 9df9e2c..8373447 100644
--- a/drivers/scsi/aic7xxx/aicasm/aicasm_insformat.h
+++ b/drivers/scsi/aic7xxx/aicasm/aicasm_insformat.h
@@ -209,7 +209,6 @@ struct instruction {
 #define AIC_OP_JC16	0x9105
 #define AIC_OP_JNC16	0x9205
 #define AIC_OP_CALL16	0x9305
-#define AIC_OP_CALL16	0x9305
 
 /* Page extension is low three bits of second opcode byte. */
 #define AIC_OP_JMPF	0xA005
-- 
1.8.1.2
