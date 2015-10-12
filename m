From: kbuild test robot <lkp@intel.com>
Subject: [RFC PATCH] scsi: hisi_sas: hisi_sas_do_release_task() can be static
Date: Tue, 13 Oct 2015 06:49:58 +0800
Message-ID: <20151012224958.GA216198@lkp-ib04.intel.com>
References: <201510130647.HK3md76n%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:64398 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752445AbbJLWvS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Oct 2015 18:51:18 -0400
Content-Disposition: inline
In-Reply-To: <1444663237-238302-19-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: kbuild-all@01.org, James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.com, devicetree@vger.kernel.org, arnd@arndb.de, linuxarm@huawei.com, zhangfei.gao@linaro.org, linux-scsi@vger.kernel.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, hare@suse.de, John Garry <john.garry@huawei.com>


Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 hisi_sas_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 36ef8cd..38f581f 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -514,7 +514,7 @@ void hisi_sas_port_notify_formed(struct asd_sas_phy *sas_phy, int lock)
 		spin_unlock_irqrestore(&hisi_hba->lock, flags);
 }
 
-void hisi_sas_do_release_task(struct hisi_hba *hisi_hba,
+static void hisi_sas_do_release_task(struct hisi_hba *hisi_hba,
 		int phy_no, struct domain_device *device)
 {
 	struct hisi_sas_phy *phy;
