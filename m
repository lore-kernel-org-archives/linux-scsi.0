From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 16/21] qla2xxx: Remove unused member (dma_handle) from srb_t structure.
Date: Thu,  3 Apr 2008 13:13:27 -0700
Message-ID: <1207253612-15538-16-git-send-email-andrew.vasquez@qlogic.com>
References: <20080403201152.GB8033@plap4.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:6416 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932074AbYDCUNn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Apr 2008 16:13:43 -0400
In-Reply-To: <20080403201152.GB8033@plap4.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

The member is not needed as there's no non-scatter-gather
list I/Os submitted by the upper-layers.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index b2f0764..094d95f 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -193,9 +193,6 @@ typedef struct srb {
 
 	uint16_t flags;
 
-	/* Single transfer DMA context */
-	dma_addr_t dma_handle;
-
 	uint32_t request_sense_length;
 	uint8_t *request_sense_ptr;
 } srb_t;
-- 
1.5.5.rc2

