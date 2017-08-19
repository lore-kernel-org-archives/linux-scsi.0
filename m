From: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH 07/15] mux: make device_type const
Date: Sat, 19 Aug 2017 13:52:18 +0530
Message-ID: <1503130946-2854-8-git-send-email-bhumirks@gmail.com>
References: <1503130946-2854-1-git-send-email-bhumirks@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:37765 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752405AbdHSIZL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Aug 2017 04:25:11 -0400
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
 drivers/mux/mux-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mux/mux-core.c b/drivers/mux/mux-core.c
index 2fe96c4..68bd16d 100644
--- a/drivers/mux/mux-core.c
+++ b/drivers/mux/mux-core.c
@@ -58,7 +58,7 @@ static void mux_chip_release(struct device *dev)
 	kfree(mux_chip);
 }
 
-static struct device_type mux_type = {
+static const struct device_type mux_type = {
 	.name = "mux-chip",
 	.release = mux_chip_release,
 };
-- 
1.9.1
