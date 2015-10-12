From: kbuild test robot <lkp@intel.com>
Subject: [RFC PATCH] scsi: hisi_sas: hisi_sas_alloc_dev() can be static
Date: Tue, 13 Oct 2015 06:35:11 +0800
Message-ID: <20151012223511.GA35800@lkp-ib04.intel.com>
References: <201510130610.OHuS0tt3%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:54975 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752079AbbJLWgi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Oct 2015 18:36:38 -0400
Content-Disposition: inline
In-Reply-To: <1444663237-238302-17-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: kbuild-all@01.org, James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.com, devicetree@vger.kernel.org, arnd@arndb.de, linuxarm@huawei.com, zhangfei.gao@linaro.org, linux-scsi@vger.kernel.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, hare@suse.de, John Garry <john.garry@huawei.com>


Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 hisi_sas_main.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 44cb9085..f7ee97a 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -355,7 +355,7 @@ void hisi_sas_bytes_dmaed(struct hisi_hba *hisi_hba, int phy_no)
 	sas_ha->notify_port_event(sas_phy, PORTE_BYTES_DMAED);
 }
 
-struct hisi_sas_device *hisi_sas_alloc_dev(struct hisi_hba *hisi_hba)
+static struct hisi_sas_device *hisi_sas_alloc_dev(struct hisi_hba *hisi_hba)
 {
 	int dev_id;
 	struct device *dev = &hisi_hba->pdev->dev;
@@ -373,7 +373,7 @@ struct hisi_sas_device *hisi_sas_alloc_dev(struct hisi_hba *hisi_hba)
 	return NULL;
 }
 
-int hisi_sas_dev_found_notify(struct domain_device *device, int lock)
+static int hisi_sas_dev_found_notify(struct domain_device *device, int lock)
 {
 	unsigned long flags = 0;
 	int res = 0;
@@ -476,7 +476,7 @@ void hisi_sas_phy_init(struct hisi_hba *hisi_hba, int phy_no)
 	sas_phy->lldd_phy = phy;
 }
 
-void hisi_sas_port_notify_formed(struct asd_sas_phy *sas_phy, int lock)
+static void hisi_sas_port_notify_formed(struct asd_sas_phy *sas_phy, int lock)
 {
 	struct sas_ha_struct *sas_ha = sas_phy->ha;
 	struct hisi_hba *hisi_hba = NULL;
