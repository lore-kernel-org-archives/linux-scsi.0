From: Thierry Reding <thierry.reding@gmail.com>
Subject: [PATCH] mptfusion: Fix up kerneldoc
Date: Fri,  8 Aug 2014 12:54:14 +0200
Message-ID: <1407495254-18886-1-git-send-email-thierry.reding@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>
Cc: MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

Commit c9834c70efba ("mptfusion: make adapter prod_name[] a pointer")
removed the prod_name argument from the mpt_get_product_name() function
but didn't update the kerneldoc comment.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/message/fusion/mptbase.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index a896d948b79e..dd61cbab2de6 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -1400,7 +1400,6 @@ mpt_verify_adapter(int iocid, MPT_ADAPTER **iocpp)
  *	@vendor: pci vendor id
  *	@device: pci device id
  *	@revision: pci revision id
- *	@prod_name: string returned
  *
  *	Returns product string displayed when driver loads,
  *	in /proc/mpt/summary and /sysfs/class/scsi_host/host<X>/version_product
-- 
2.0.4
