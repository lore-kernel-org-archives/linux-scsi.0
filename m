From: Hanjun Guo <guohanjun@huawei.com>
Subject: [PATCH] scsi: remove useless acpi functions in the head file
Date: Tue, 10 Jan 2017 16:14:04 +0800
Message-ID: <1484036044-9514-1-git-send-email-guohanjun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([58.251.152.64]:17843 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965683AbdAJISL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Jan 2017 03:18:11 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, john.garry@huawei.com, Hanjun Guo <hanjun.guo@linaro.org>

From: Hanjun Guo <hanjun.guo@linaro.org>

commit f1bc1e4c44b1 ("ata: acpi: rework the ata acpi bind support")
removed scsi_register_acpi_bus_type() and scsi_unregister_acpi_bus_type(),
but forgot to remove them in the head file, do it now.

Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
---
 include/scsi/scsi.h | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 8ec7c30..a1e1930 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -29,16 +29,6 @@ enum scsi_timeouts {
  */
 #define SCAN_WILD_CARD	~0
 
-#ifdef CONFIG_ACPI
-struct acpi_bus_type;
-
-extern int
-scsi_register_acpi_bus_type(struct acpi_bus_type *bus);
-
-extern void
-scsi_unregister_acpi_bus_type(struct acpi_bus_type *bus);
-#endif
-
 /** scsi_status_is_good - check the status return.
  *
  * @status: the status passed up from the driver (including host and
-- 
1.7.12.4

