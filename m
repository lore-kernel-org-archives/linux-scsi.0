From: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH 09/15] phy: tegra: make device_type const
Date: Sat, 19 Aug 2017 13:52:20 +0530
Message-ID: <1503130946-2854-10-git-send-email-bhumirks__22657.7793284834$1503131184$gmane$org@gmail.com>
References: <1503130946-2854-1-git-send-email-bhumirks@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:36704 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751990AbdHSIZu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Aug 2017 04:25:50 -0400
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
 drivers/phy/tegra/xusb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/phy/tegra/xusb.c b/drivers/phy/tegra/xusb.c
index 3cbcb25..bd3f1b6 100644
--- a/drivers/phy/tegra/xusb.c
+++ b/drivers/phy/tegra/xusb.c
@@ -155,7 +155,7 @@ static void tegra_xusb_pad_release(struct device *dev)
 	pad->soc->ops->remove(pad);
 }
 
-static struct device_type tegra_xusb_pad_type = {
+static const struct device_type tegra_xusb_pad_type = {
 	.release = tegra_xusb_pad_release,
 };
 
@@ -512,7 +512,7 @@ static void tegra_xusb_port_release(struct device *dev)
 {
 }
 
-static struct device_type tegra_xusb_port_type = {
+static const struct device_type tegra_xusb_port_type = {
 	.release = tegra_xusb_port_release,
 };
 
-- 
1.9.1
