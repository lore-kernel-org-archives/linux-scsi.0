From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 8/9] mpt3sas: Enable new EH timeout handler
Date: Mon,  2 Sep 2013 09:13:04 +0200
Message-ID: <1378105985-79686-9-git-send-email-hare@suse.de>
References: <1378105985-79686-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38452 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758100Ab3IBHNO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Sep 2013 03:13:14 -0400
In-Reply-To: <1378105985-79686-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Joern Engel <joern@logfs.org>, James Smart <james.smart@emulex.com>, Bart Van Assche <bvanassche@acm.org>, Roland Dreier <roland@purestorage.com>, Hannes Reinecke <hare@suse.de>

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index a961fe1..b893383 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -7237,6 +7237,7 @@ static struct scsi_host_template scsih_driver_template = {
 	.scan_start			= _scsih_scan_start,
 	.change_queue_depth		= _scsih_change_queue_depth,
 	.change_queue_type		= _scsih_change_queue_type,
+	.eh_timed_out			= scsi_abort_command,
 	.eh_abort_handler		= _scsih_abort,
 	.eh_device_reset_handler	= _scsih_dev_reset,
 	.eh_target_reset_handler	= _scsih_target_reset,
-- 
1.7.12.4

