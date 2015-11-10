From: kbuild test robot <fengguang.wu@intel.com>
Subject: [RFC PATCH scsi] aacraid: aac_release_resources() can be static
Date: Tue, 10 Nov 2015 13:59:06 +0800
Message-ID: <20151110055906.GA116383@lkp-hsx03>
References: <201511101352.WifvAYu2%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:22511 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751284AbbKJGAc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Nov 2015 01:00:32 -0500
Content-Disposition: inline
In-Reply-To: <201511101352.WifvAYu2%fengguang.wu@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
Cc: kbuild-all@01.org, linux-scsi@vger.kernel.org, James Bottomley <JBottomley@Odin.com>, Tomas Henzl <thenzl@redhat.com>, Murthy Bhat <Murthy.Bhat@pmcs.com>, Karthikeya Sunkesula <Karthikeya.Sunkesula@pmcs.com>


Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 linit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 37375cf..7724583f 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1318,7 +1318,7 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 }
 
 #if (defined(CONFIG_PM))
-void aac_release_resources(struct aac_dev *aac)
+static void aac_release_resources(struct aac_dev *aac)
 {
 	int i;
 
