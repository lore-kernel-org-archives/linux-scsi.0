From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] [SCSI] mvsas: remove unused variable in mvs_task_exec()
Date: Thu, 8 Mar 2012 10:26:33 +0300
Message-ID: <20120308072633.GB27713@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:43230 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487Ab2CHH1A (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Mar 2012 02:27:00 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Xiangliang Yu <yuxiangl@marvell.com>, James Bottomley <James.Bottomley@suse.de>, Jack Wang <jack_wang@usish.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

We don't use "dev" any more after 07ec747a5f ("libsas: remove
ata_port.lock management duties from lldds") and it causes a compile
warning.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index 7d46c1a..4539d59 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -885,7 +885,6 @@ static int mvs_task_exec(struct sas_task *task, const int num, gfp_t gfp_flags,
 				struct completion *completion, int is_tmf,
 				struct mvs_tmf_task *tmf)
 {
-	struct domain_device *dev = task->dev;
 	struct mvs_info *mvi = NULL;
 	u32 rc = 0;
 	u32 pass = 0;
