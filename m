From: "Enrico Weigelt, metux IT consult" <info@metux.net>
Subject: [PATCH 3/3] drivers: hwmon: i5k_amb: remove unnecessary #ifdef MODULE
Date: Fri, 31 May 2019 17:09:04 +0200
Message-ID: <1559315344-10384-4-git-send-email-info@metux.net>
References: <1559315344-10384-1-git-send-email-info@metux.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1559315344-10384-1-git-send-email-info@metux.net>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: rjw@rjwysocki.net, viresh.kumar@linaro.org, jdelvare@suse.com, linux@roeck-us.net, khalid@gonehiking.org, jejb@linux.ibm.com, martin.petersen@oracle.com, aacraid@microsemi.com, linux-pm@vger.kernel.org, linux-hwmon@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The MODULE_DEVICE_TABLE() macro already checks for MODULE defined,
so the extra check here is not necessary.

Signed-off-by: Enrico Weigelt <info@metux.net>
---
 drivers/hwmon/i5k_amb.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/hwmon/i5k_amb.c b/drivers/hwmon/i5k_amb.c
index 2cf73d8..622405b 100644
--- a/drivers/hwmon/i5k_amb.c
+++ b/drivers/hwmon/i5k_amb.c
@@ -495,14 +495,12 @@ static int i5k_channel_probe(u16 *amb_present, unsigned long dev_id)
 	{ 0, 0 }
 };
 
-#ifdef MODULE
 static const struct pci_device_id i5k_amb_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_5000_ERR) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_5400_ERR) },
 	{ 0, }
 };
 MODULE_DEVICE_TABLE(pci, i5k_amb_ids);
-#endif
 
 static int i5k_amb_probe(struct platform_device *pdev)
 {
-- 
1.9.1
