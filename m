From: Colin King <colin.king@canonical.com>
Subject: [PATCH][next] scsi: megaraid_sas: fix spelling mistake "megarid_sas" -> "megaraid_sas"
Date: Sat, 20 Jul 2019 22:58:40 +0100
Message-ID: <20190720215840.23831-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Kashyap Desai <kashyap.desai@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Fix spelling mistake in kernel warning message and replace
printk with with pr_warn.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index b2339d04a700..2590746c81e3 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -8763,7 +8763,7 @@ static int __init megasas_init(void)
 
 	if ((event_log_level < MFI_EVT_CLASS_DEBUG) ||
 	    (event_log_level > MFI_EVT_CLASS_DEAD)) {
-		printk(KERN_WARNING "megarid_sas: provided event log level is out of range, setting it to default 2(CLASS_CRITICAL), permissible range is: -2 to 4\n");
+		pr_warn("megaraid_sas: provided event log level is out of range, setting it to default 2(CLASS_CRITICAL), permissible range is: -2 to 4\n");
 		event_log_level = MFI_EVT_CLASS_CRITICAL;
 	}
 
-- 
2.20.1
