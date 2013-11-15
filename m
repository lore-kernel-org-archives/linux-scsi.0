From: wenxiong@linux.vnet.ibm.com
Subject: [PATCH 1/1] ipr: Increase msi-x interrupt vectors to 16
Date: Fri, 15 Nov 2013 10:58:15 -0600
Message-ID: <20131115170017.815518174@linux.vnet.ibm.com>
References: <20131115165814.252430802@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [32.97.110.57] ([32.97.110.57]:60034 "HELO
	jupiter1-lp2.austin.ibm.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1751439Ab3KORDF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Nov 2013 12:03:05 -0500
Content-Disposition: inline; filename=increase_msix_vector
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, Wen Xiong <wenxiong@linux.vnet.ibm.com>

This patch increased msix-x interrupts vectors to 16 in ipr driver.

Signed-off-by: Wen Xiong <wenxiong@linux.vnet.ibm.com>
---
 drivers/scsi/ipr.c |    2 +-
 drivers/scsi/ipr.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Index: b/drivers/scsi/ipr.c
===================================================================
--- a/drivers/scsi/ipr.c	2013-11-13 09:51:39.000000000 -0600
+++ b/drivers/scsi/ipr.c	2013-11-13 09:54:17.247765599 -0600
@@ -220,7 +220,7 @@ module_param_named(max_devs, ipr_max_dev
 MODULE_PARM_DESC(max_devs, "Specify the maximum number of physical devices. "
 		 "[Default=" __stringify(IPR_DEFAULT_SIS64_DEVS) "]");
 module_param_named(number_of_msix, ipr_number_of_msix, int, 0);
-MODULE_PARM_DESC(number_of_msix, "Specify the number of MSIX interrupts to use on capable adapters (1 - 5).  (default:2)");
+MODULE_PARM_DESC(number_of_msix, "Specify the number of MSIX interrupts to use on capable adapters (1 - 16).  (default:2)");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(IPR_DRIVER_VERSION);
 
Index: b/drivers/scsi/ipr.h
===================================================================
--- a/drivers/scsi/ipr.h	2013-11-13 09:52:01.000000000 -0600
+++ b/drivers/scsi/ipr.h	2013-11-13 09:53:10.797767407 -0600
@@ -311,7 +311,7 @@ IPR_PCII_NO_HOST_RRQ | IPR_PCII_IOARRIN_
  * Misc literals
  */
 #define IPR_NUM_IOADL_ENTRIES			IPR_MAX_SGLIST
-#define IPR_MAX_MSIX_VECTORS		0x5
+#define IPR_MAX_MSIX_VECTORS		0x10
 #define IPR_MAX_HRRQ_NUM		0x10
 #define IPR_INIT_HRRQ			0x0
 

-- 
