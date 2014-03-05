From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] [RESEND] [SCSI] aic7xxx: remove duplicate define
Date: Wed,  5 Mar 2014 06:18:36 +0100
Message-ID: <1393996716-3670-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1386582956-4942-1-git-send-email-michael.opdenacker@free-electrons.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1386582956-4942-1-git-send-email-michael.opdenacker@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Michael Opdenacker <michael.opdenacker@free-electrons.com>
List-Id: linux-scsi@vger.kernel.org

Remove duplicate define
in drivers/scsi/aic7xxx/aicasm/aicasm_insformat.h

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Acked-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/aic7xxx/aicasm/aicasm_insformat.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/aic7xxx/aicasm/aicasm_insformat.h b/drivers/scsi/aic7xxx/aicasm/aicasm_insformat.h
index 9df9e2ce3538..8373447bd7d3 100644
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
1.8.3.2
