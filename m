From: kbuild test robot <fengguang.wu@intel.com>
Subject: [PATCH target] target: se_dev_check_wce() can be static
Date: Tue, 26 May 2015 16:13:20 +0800
Message-ID: <20150526081320.GA111779@lkp-sb04>
References: <201505261605.Y1XY0zLc%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:25006 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751982AbbEZINk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 May 2015 04:13:40 -0400
Content-Disposition: inline
In-Reply-To: <201505261605.Y1XY0zLc%fengguang.wu@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: kbuild-all@01.org, Nicholas Bellinger <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org


Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 target_core_device.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 2321884..1d309ad 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -649,7 +649,7 @@ static u32 se_dev_align_max_sectors(u32 max_sectors, u32 block_size)
 	return aligned_max_sectors;
 }
 
-bool se_dev_check_wce(struct se_device *dev)
+static bool se_dev_check_wce(struct se_device *dev)
 {
 	bool wce = false;
 
