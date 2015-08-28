From: kbuild test robot <fengguang.wu@intel.com>
Subject: [PATCH scsi] mpt3sas: mpt3sas_base_unmap_resources can be static
Date: Fri, 28 Aug 2015 09:20:22 +0800
Message-ID: <20150828012022.GA6922@ivytown2>
References: <201508280958.jLBYjhIZ%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:14367 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751449AbbH1BV6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Aug 2015 21:21:58 -0400
Content-Disposition: inline
In-Reply-To: <201508280958.jLBYjhIZ%fengguang.wu@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: kbuild-all@01.org, James Bottomley <JBottomley@Odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Johannes Thumshirn <jthumshirn@suse.de>, linux-scsi@vger.kernel.org


Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 mpt3sas_base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 7e8ede2..6ee54dd 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -1816,7 +1816,7 @@ _base_enable_msix(struct MPT3SAS_ADAPTER *ioc)
  * mpt3sas_base_unmap_resources - free controller resources
  * @ioc: per adapter object
  */
-void
+static void
 mpt3sas_base_unmap_resources(struct MPT3SAS_ADAPTER *ioc)
 {
 	struct pci_dev *pdev = ioc->pdev;
