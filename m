From: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH 01/15] EDAC: make device_type const
Date: Sat, 19 Aug 2017 13:52:12 +0530
Message-ID: <1503130946-2854-2-git-send-email-bhumirks__46126.208760734$1503131016$gmane$org@gmail.com>
References: <1503130946-2854-1-git-send-email-bhumirks@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:35504 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751808AbdHSIXN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Aug 2017 04:23:13 -0400
In-Reply-To: <1503130946-2854-1-git-send-email-bhumirks@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: julia.lawall@lip6.fr, bp@alien8.de, mchehab@kernel.org, daniel.vetter@intel.com, jani.nikula@linux.intel.com, seanpaul@chromium.org, airlied@linux.ie, g.liakhovetski@gmx.de, tomas.winkler@intel.com, dwmw2@infradead.org, computersforpeace@gmail.com, boris.brezillon@free-electrons.com, marek.vasut@gmail.com, richard@nod.at, cyrille.pitchen@wedev4u.fr, peda@axentia.se, kishon@ti.com, bhelgaas@google.com, thierry.reding@gmail.com, jonathanh@nvidia.com, dvhart@infradead.org, andy@infradead.org, ohad@wizery.com, bjorn.andersson@linaro.org, freude@de.ibm.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, jth@kernel.org, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, lduncan@suse.com, cleech@redhat.com, johan@kernel.org, elder@kernel.org, gregkh@linuxfoundation.orgheik
Cc: Bhumika Goyal <bhumirks@gmail.com>

Make these const as they are only stored in the type field of a device
structure, which is const.
Done using Coccinelle.

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/edac/edac_mc_sysfs.c | 8 ++++----
 drivers/edac/i7core_edac.c   | 4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index dbc6446..e4fcfa8 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -304,7 +304,7 @@ static void csrow_attr_release(struct device *dev)
 	kfree(csrow);
 }
 
-static struct device_type csrow_attr_type = {
+static const struct device_type csrow_attr_type = {
 	.groups		= csrow_attr_groups,
 	.release	= csrow_attr_release,
 };
@@ -644,7 +644,7 @@ static void dimm_attr_release(struct device *dev)
 	kfree(dimm);
 }
 
-static struct device_type dimm_attr_type = {
+static const struct device_type dimm_attr_type = {
 	.groups		= dimm_attr_groups,
 	.release	= dimm_attr_release,
 };
@@ -920,7 +920,7 @@ static void mci_attr_release(struct device *dev)
 	kfree(mci);
 }
 
-static struct device_type mci_attr_type = {
+static const struct device_type mci_attr_type = {
 	.groups		= mci_attr_groups,
 	.release	= mci_attr_release,
 };
@@ -1074,7 +1074,7 @@ static void mc_attr_release(struct device *dev)
 	kfree(dev);
 }
 
-static struct device_type mc_attr_type = {
+static const struct device_type mc_attr_type = {
 	.release	= mc_attr_release,
 };
 /*
diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
index d36cc84..c16c3b9 100644
--- a/drivers/edac/i7core_edac.c
+++ b/drivers/edac/i7core_edac.c
@@ -1094,7 +1094,7 @@ static void addrmatch_release(struct device *device)
 	kfree(device);
 }
 
-static struct device_type addrmatch_type = {
+static const struct device_type addrmatch_type = {
 	.groups		= addrmatch_groups,
 	.release	= addrmatch_release,
 };
@@ -1125,7 +1125,7 @@ static void all_channel_counts_release(struct device *device)
 	kfree(device);
 }
 
-static struct device_type all_channel_counts_type = {
+static const struct device_type all_channel_counts_type = {
 	.groups		= all_channel_counts_groups,
 	.release	= all_channel_counts_release,
 };
-- 
1.9.1
