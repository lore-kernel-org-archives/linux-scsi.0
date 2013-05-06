From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 4/5] advansys: Remove references to 'last_reset'
Date: Mon,  6 May 2013 09:20:40 +0200
Message-ID: <1367824841-47767-5-git-send-email-hare@suse.de>
References: <1367824841-47767-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38799 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753132Ab3EFHUp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 May 2013 03:20:45 -0400
In-Reply-To: <1367824841-47767-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

The 'last_reset' field is only displayed in logging messages but
never actually used. Remove references to it.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/advansys.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index c67e401..d814588 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -2511,8 +2511,8 @@ static void asc_prt_scsi_host(struct Scsi_Host *s)
 	struct asc_board *boardp = shost_priv(s);
 
 	printk("Scsi_Host at addr 0x%p, device %s\n", s, dev_name(boardp->dev));
-	printk(" host_busy %u, host_no %d, last_reset %d,\n",
-	       s->host_busy, s->host_no, (unsigned)s->last_reset);
+	printk(" host_busy %u, host_no %d,\n",
+	       s->host_busy, s->host_no);
 
 	printk(" base 0x%lx, io_port 0x%lx, irq %d,\n",
 	       (ulong)s->base, (ulong)s->io_port, boardp->irq);
@@ -3345,8 +3345,8 @@ static void asc_prt_driver_conf(struct seq_file *m, struct Scsi_Host *shost)
 		shost->host_no);
 
 	seq_printf(m,
-		   " host_busy %u, last_reset %lu, max_id %u, max_lun %u, max_channel %u\n",
-		   shost->host_busy, shost->last_reset, shost->max_id,
+		   " host_busy %u, max_id %u, max_lun %u, max_channel %u\n",
+		   shost->host_busy, shost->max_id,
 		   shost->max_lun, shost->max_channel);
 
 	seq_printf(m,
-- 
1.7.12.4

