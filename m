From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 02/22] aha152x: Remove #ifdef 0 section
Date: Thu, 28 Aug 2014 19:33:16 +0200
Message-ID: <1409247216-76074-3-git-send-email-hare@suse.de>
References: <1409247216-76074-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60156 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958AbaH1Rdj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Aug 2014 13:33:39 -0400
In-Reply-To: <1409247216-76074-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Ewan Milne <emilne@redhat.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliot <elliot@hp.com>, Yoshihiro Yunomae <yoshihiro.ynomae.ez@hitachi.com>, Hannes Reinecke <hare@suse.de>

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/aha152x.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index e77b72f..4da3a3b 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -1553,13 +1553,6 @@ static void busfree_run(struct Scsi_Host *shpnt)
 			struct scsi_cmnd *cmd = HOSTDATA(shpnt)->done_SC;
 			struct aha152x_scdata *sc = SCDATA(cmd);
 
-#if 0
-			if(HOSTDATA(shpnt)->debug & debug_eh) {
-				printk(ERR_LEAD "received sense: ", CMDINFO(DONE_SC));
-				scsi_print_sense("bh", DONE_SC);
-			}
-#endif
-
 			scsi_eh_restore_cmnd(cmd, &sc->ses);
 
 			cmd->SCp.Status = SAM_STAT_CHECK_CONDITION;
-- 
1.8.5.2

