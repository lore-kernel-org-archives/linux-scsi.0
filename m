From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [RFC 1/8] stex driver BROKEN
Date: Thu, 05 Jul 2007 16:43:24 +0300
Message-ID: <468CF57C.60002@panasas.com>
References: <468CDB3C.4060500@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:27064 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756609AbXGENnq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Jul 2007 09:43:46 -0400
In-Reply-To: <468CDB3C.4060500@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>


  I just comment out the code, but now user-mode is broken
  what to do ??
---
 drivers/scsi/stex.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index adda296..935e2a6 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -719,8 +719,8 @@ static void stex_ys_commands(struct st_hba *hba,
 
 	if (ccb->cmd->cmnd[0] == MGT_CMD &&
 		resp->scsi_status != SAM_STAT_CHECK_CONDITION) {
-		scsi_bufflen(ccb->cmd) =
-			le32_to_cpu(*(__le32 *)&resp->variable[0]);
+/*		scsi_bufflen(ccb->cmd) =
+			le32_to_cpu(*(__le32 *)&resp->variable[0]);*/
 		return;
 	}
 
-- 
1.5.2.2.249.g45fd


