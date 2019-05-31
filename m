From: "Enrico Weigelt, metux IT consult" <info@metux.net>
Subject: [PATCH 1/3] drivers: cpufreq: cpufreq-nforce2: remove unnecessary #ifdef MODULE
Date: Fri, 31 May 2019 17:09:02 +0200
Message-ID: <1559315344-10384-2-git-send-email-info@metux.net>
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
 drivers/cpufreq/cpufreq-nforce2.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/cpufreq/cpufreq-nforce2.c b/drivers/cpufreq/cpufreq-nforce2.c
index 33c309a..b8a6c9e 100644
--- a/drivers/cpufreq/cpufreq-nforce2.c
+++ b/drivers/cpufreq/cpufreq-nforce2.c
@@ -374,13 +374,11 @@ static int nforce2_cpu_exit(struct cpufreq_policy *policy)
 	.exit = nforce2_cpu_exit,
 };
 
-#ifdef MODULE
 static const struct pci_device_id nforce2_ids[] = {
 	{ PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE2 },
 	{}
 };
 MODULE_DEVICE_TABLE(pci, nforce2_ids);
-#endif
 
 /**
  * nforce2_detect_chipset - detect the Southbridge which contains FSB PLL logic
-- 
1.9.1
