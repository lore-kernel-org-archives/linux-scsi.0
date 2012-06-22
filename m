From: Dan Williams <dan.j.williams@intel.com>
Subject: [set3 PATCH 6/6] mvsas: remove unused variable in mvs_task_exec()
Date: Thu, 21 Jun 2012 23:36:35 -0700
Message-ID: <20120622063635.21332.61570.stgit@dwillia2-linux.jf.intel.com>
References: <20120622063604.21332.39275.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:15554 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761222Ab2FVGT5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Jun 2012 02:19:57 -0400
In-Reply-To: <20120622063604.21332.39275.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>

From: Dan Carpenter <dan.carpenter@oracle.com>

We don't use "dev" any more after 07ec747a5f ("libsas: remove
ata_port.lock management duties from lldds") and it causes a compile
warning.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/mvsas/mv_sas.c |    1 -
 1 file changed, 1 deletion(-)

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

