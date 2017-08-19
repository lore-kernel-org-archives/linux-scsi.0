From: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH 10/15] platform/x86: wmi: make device_type const
Date: Sat, 19 Aug 2017 13:52:21 +0530
Message-ID: <1503130946-2854-11-git-send-email-bhumirks__28480.9241573841$1503131194$gmane$org@gmail.com>
References: <1503130946-2854-1-git-send-email-bhumirks@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:34754 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751101AbdHSI0K (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Aug 2017 04:26:10 -0400
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
 drivers/platform/x86/wmi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/wmi.c b/drivers/platform/x86/wmi.c
index e32ba57..a37c253 100644
--- a/drivers/platform/x86/wmi.c
+++ b/drivers/platform/x86/wmi.c
@@ -810,19 +810,19 @@ static int wmi_dev_remove(struct device *dev)
 	.remove = wmi_dev_remove,
 };
 
-static struct device_type wmi_type_event = {
+static const struct device_type wmi_type_event = {
 	.name = "event",
 	.groups = wmi_event_groups,
 	.release = wmi_dev_release,
 };
 
-static struct device_type wmi_type_method = {
+static const struct device_type wmi_type_method = {
 	.name = "method",
 	.groups = wmi_method_groups,
 	.release = wmi_dev_release,
 };
 
-static struct device_type wmi_type_data = {
+static const struct device_type wmi_type_data = {
 	.name = "data",
 	.groups = wmi_data_groups,
 	.release = wmi_dev_release,
-- 
1.9.1
