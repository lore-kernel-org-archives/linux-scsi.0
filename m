From: Steffen Weber <steffen.weber@gmail.com>
Subject: [PATCH] scsi: smartpqi: allow static build ("built-in")
Date: Fri, 22 Dec 2017 18:18:47 +0100
Message-ID: <20171222171847.14006-1-steffen.weber@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:44243 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755826AbdLVRTK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Dec 2017 12:19:10 -0500
Received: by mail-wm0-f50.google.com with SMTP id t8so22994733wmc.3
        for <linux-scsi@vger.kernel.org>; Fri, 22 Dec 2017 09:19:10 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: don.brace@microsemi.com, esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org
Cc: Steffen Weber <steffen.weber@gmail.com>

If CONFIG_SCSI_SMARTPQI=y then don't build this driver as a module.
---
 drivers/scsi/smartpqi/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/smartpqi/Makefile b/drivers/scsi/smartpqi/Makefile
index 0f42a225a..e6b779930 100644
--- a/drivers/scsi/smartpqi/Makefile
+++ b/drivers/scsi/smartpqi/Makefile
@@ -1,3 +1,3 @@
 ccflags-y += -I.
-obj-m		+= smartpqi.o
+obj-$(CONFIG_SCSI_SMARTPQI) += smartpqi.o
 smartpqi-objs := smartpqi_init.o smartpqi_sis.o smartpqi_sas_transport.o
-- 
2.15.1
