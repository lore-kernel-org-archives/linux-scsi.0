From: Steffen Weber <steffen.weber@gmail.com>
Subject: Re: [PATCH] scsi: smartpqi: allow static build ("built-in")
Date: Tue,  2 Jan 2018 19:24:09 +0100
Message-ID: <20180102182409.3083-1-steffen.weber@gmail.com>
References: <a6c35114c589429c8e44fae02cb8fecd@microsemi.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34720 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751029AbeABSYr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Jan 2018 13:24:47 -0500
Received: by mail-wm0-f68.google.com with SMTP id y82so17248328wmg.1
        for <linux-scsi@vger.kernel.org>; Tue, 02 Jan 2018 10:24:46 -0800 (PST)
In-Reply-To: <a6c35114c589429c8e44fae02cb8fecd@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: don.brace@microsemi.com, esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org
Cc: Steffen Weber <steffen.weber@gmail.com>

If CONFIG_SCSI_SMARTPQI=y then don't build this driver as a module.

Signed-off-by: Steffen Weber <steffen.weber@gmail.com>
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
