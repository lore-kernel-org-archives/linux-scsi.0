From: Roel Kluin <12o3l@tiscali.nl>
Subject: [PATCH 1/1][] Test opcode, not definition in type_check(), drivers/scsi/aic7xxx/aicasm/aicasm_gram.y
Date: Mon, 28 Jan 2008 14:09:54 +0100
Message-ID: <479DD422.60006@tiscali.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:48833 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825AbYA1NJ5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Jan 2008 08:09:57 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hare@suse.de
Cc: linux-scsi@vger.kernel.org

drivers/scsi/aic7xxx_old/sequencer.h:130:#define AIC_OP_JZ 0xf
--
Test opcode, not definition

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/scsi/aic7xxx/aicasm/aicasm_gram.y b/drivers/scsi/aic7xxx/aicasm/aicasm_gram.y
index 6066998..702e2db 100644
--- a/drivers/scsi/aic7xxx/aicasm/aicasm_gram.y
+++ b/drivers/scsi/aic7xxx/aicasm/aicasm_gram.y
@@ -1837,7 +1837,7 @@ type_check(symbol_t *symbol, expression_t *expression, int opcode)
 	int and_op;
 
 	and_op = FALSE;
-	if (opcode == AIC_OP_AND || opcode == AIC_OP_JNZ || AIC_OP_JZ)
+	if (opcode == AIC_OP_AND || opcode == AIC_OP_JNZ || opcode == AIC_OP_JZ)
 		and_op = TRUE;
 
 	/*
