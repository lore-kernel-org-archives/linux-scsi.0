From: kbuild test robot <lkp@intel.com>
Subject: [RFC PATCH] scsi: hisi_sas: hisi_sas_ioremap() can be static
Date: Tue, 13 Oct 2015 01:18:20 +0800
Message-ID: <20151012171820.GA185915@lkp-ib04.intel.com>
References: <201510130106.fyp9Dh3e%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:53976 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751332AbbJLRSu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Oct 2015 13:18:50 -0400
Content-Disposition: inline
In-Reply-To: <1444663237-238302-8-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: kbuild-all@01.org, James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.com, devicetree@vger.kernel.org, arnd@arndb.de, linuxarm@huawei.com, zhangfei.gao@linaro.org, linux-scsi@vger.kernel.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, hare@suse.de, John Garry <john.garry@huawei.com>


Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 hisi_sas_init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_init.c b/drivers/scsi/hisi_sas/hisi_sas_init.c
index 8f1e856..066c339 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_init.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_init.c
@@ -195,7 +195,7 @@ static void hisi_sas_free(struct hisi_hba *hisi_hba)
 				  hisi_hba->sata_breakpoint_dma);
 }
 
-int hisi_sas_ioremap(struct hisi_hba *hisi_hba)
+static int hisi_sas_ioremap(struct hisi_hba *hisi_hba)
 {
 	struct platform_device *pdev = hisi_hba->pdev;
 	struct device *dev = &pdev->dev;
