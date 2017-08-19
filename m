From: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH 08/15] PCI: make device_type const
Date: Sat, 19 Aug 2017 13:52:19 +0530
Message-ID: <1503130946-2854-9-git-send-email-bhumirks__28684.523367747$1503131145$gmane$org@gmail.com>
References: <1503130946-2854-1-git-send-email-bhumirks@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:38176 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751853AbdHSIZb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Aug 2017 04:25:31 -0400
In-Reply-To: <1503130946-2854-1-git-send-email-bhumirks@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: julia.lawall@lip6.fr, bp@alien8.de, mchehab@kernel.org, daniel.vetter@intel.com, jani.nikula@linux.intel.com, seanpaul@chromium.org, airlied@linux.ie, g.liakhovetski@gmx.de, tomas.winkler@intel.com, dwmw2@infradead.org, computersforpeace@gmail.com, boris.brezillon@free-electrons.com, marek.vasut@gmail.com, richard@nod.at, cyrille.pitchen@wedev4u.fr, peda@axentia.se, kishon@ti.com, bhelgaas@google.com, thierry.reding@gmail.com, jonathanh@nvidia.com, dvhart@infradead.org, andy@infradead.org, ohad@wizery.com, bjorn.andersson@linaro.org, freude@de.ibm.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, jth@kernel.org, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, lduncan@suse.com, cleech@redhat.com, johan@kernel.org, elder@kernel.org, gregkh@linuxfoundation.orgheik
Cc: Bhumika Goyal <bhumirks@gmail.com>

Make this const as it is only stored in the type field of a device
structure, which is const.
Done using Coccinelle.

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/pci/endpoint/pci-epf-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/endpoint/pci-epf-core.c b/drivers/pci/endpoint/pci-epf-core.c
index 6877d6a..9d0de12 100644
--- a/drivers/pci/endpoint/pci-epf-core.c
+++ b/drivers/pci/endpoint/pci-epf-core.c
@@ -27,7 +27,7 @@
 #include <linux/pci-ep-cfs.h>
 
 static struct bus_type pci_epf_bus_type;
-static struct device_type pci_epf_type;
+static const struct device_type pci_epf_type;
 
 /**
  * pci_epf_linkup() - Notify the function driver that EPC device has
@@ -275,7 +275,7 @@ static void pci_epf_dev_release(struct device *dev)
 	kfree(epf);
 }
 
-static struct device_type pci_epf_type = {
+static const struct device_type pci_epf_type = {
 	.release	= pci_epf_dev_release,
 };
 
-- 
1.9.1
