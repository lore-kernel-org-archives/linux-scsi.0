From: kbuild test robot <lkp@intel.com>
Subject: [RFC PATCH] scsi: hisi_sas: hisi_sas_bytes_dmaed() can be static
Date: Tue, 13 Oct 2015 06:03:44 +0800
Message-ID: <20151012220343.GA181125@lkp-ib04.intel.com>
References: <201510130540.gVjgsIWc%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:44707 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752105AbbJLWER (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Oct 2015 18:04:17 -0400
Content-Disposition: inline
In-Reply-To: <1444663237-238302-14-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: kbuild-all@01.org, James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.com, devicetree@vger.kernel.org, arnd@arndb.de, linuxarm@huawei.com, zhangfei.gao@linaro.org, linux-scsi@vger.kernel.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, hare@suse.de, John Garry <john.garry@huawei.com>


Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 hisi_sas_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 72831db..08b2af8 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -28,7 +28,7 @@ void hisi_sas_slot_index_init(struct hisi_hba *hisi_hba)
 }
 
 
-void hisi_sas_bytes_dmaed(struct hisi_hba *hisi_hba, int phy_no)
+static void hisi_sas_bytes_dmaed(struct hisi_hba *hisi_hba, int phy_no)
 {
 	struct hisi_sas_phy *phy = &hisi_hba->phy[phy_no];
 	struct asd_sas_phy *sas_phy = &phy->sas_phy;
