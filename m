From: Yue Haibing <yuehaibing@huawei.com>
Subject: [PATCH -next] scsi: megaraid_sas: Make megasas_host_device_list_query() static
Date: Sat, 13 Apr 2019 22:21:38 +0800
Message-ID: <20190413142138.33336-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, megaraidlinux.pdl@broadcom.com, YueHaibing <yuehaibing@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

Fix sparse warning:

drivers/scsi/megaraid/megaraid_sas_base.c:4652:1: warning:
 symbol 'megasas_host_device_list_query' was not declared. Should it be static?

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 59a6546..1ec55ef 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -4647,7 +4647,7 @@ megasas_ld_list_query(struct megasas_instance *instance, u8 query_type)
  * Return:			0 if DCMD succeeded
  *				 non-zero if failed
  */
-int
+static int
 megasas_host_device_list_query(struct megasas_instance *instance,
 			       bool is_probe)
 {
-- 
2.7.4
