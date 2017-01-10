From: Hanjun Guo <guohanjun@huawei.com>
Subject: [PATCH v2] scsi: remove useless acpi functions in the header file
Date: Tue, 10 Jan 2017 20:16:43 +0800
Message-ID: <1484050603-5246-1-git-send-email-guohanjun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, john.garry@huawei.com, Johannes Thumshirn <jthumshirn@suse.de>, Hanjun Guo <hanjun.guo@linaro.org>
List-Id: linux-scsi@vger.kernel.org

From: Hanjun Guo <hanjun.guo@linaro.org>

commit f1bc1e4c44b1 ("ata: acpi: rework the ata acpi bind support")
removed scsi_register_acpi_bus_type() and scsi_unregister_acpi_bus_type(),
but forgot to remove them in the header file, do it now.

Reviewed-by: John Garry <john.garry@huawei.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
---
v1 -> v2:
 - fix s/head/header
 - add review tags

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
