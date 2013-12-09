From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH][RESEND] [SCSI] aic7xxx: remove duplicate define
Date: Mon,  9 Dec 2013 10:55:56 +0100
Message-ID: <1386582956-4942-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1382524483-3167-1-git-send-email-michael.opdenacker@free-electrons.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from top.free-electrons.com ([176.31.233.9]:34270 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932268Ab3LIJ4B (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Dec 2013 04:56:01 -0500
In-Reply-To: <1382524483-3167-1-git-send-email-michael.opdenacker@free-electrons.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hare@suse.de, JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Michael Opdenacker <michael.opdenacker@free-electrons.com>

Remove duplicate define
in drivers/scsi/aic7xxx/aicasm/aicasm_insformat.h

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
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

