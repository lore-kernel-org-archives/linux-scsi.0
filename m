From: <nagalakshmi.nandigama@lsi.com>
Subject: [PATCH 03/08] [SCSI]  mpt2sas : Added support for customer
 specific branding
Date: Thu, 1 Dec 2011 07:52:42 +0530
Message-ID: <201112010929.pB19TBCx021166@milmhbs0.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:34461 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751689Ab1LAJ3P (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Dec 2011 04:29:15 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, kashyap.desai@lsi.com, Nagalakshmi.Nandigama@lsi.com, Sathya.Prakash@lsi.com, Eric.Moore@lsi.com
Cc: JBottomley@parallels.com

Added support for customer specific branding

Signed-off-by: Nagalakshmi Nandigama <nagalakshmi.nandigama@lsi.com>
---

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index e78733f..3be6bc4 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -1989,6 +1989,22 @@ _base_display_intel_branding(struct MPT2SAS_ADAPTER *ioc)
 			printk(MPT2SAS_INFO_FMT "%s\n", ioc->name,
 			    MPT2SAS_INTEL_RS25GB008_BRANDING);
 			break;
+		case MPT2SAS_INTEL_RMS25JB080_SSDID:
+			printk(MPT2SAS_INFO_FMT "%s\n", ioc->name,
+			    MPT2SAS_INTEL_RMS25JB080_BRANDING);
+			break;
+		case MPT2SAS_INTEL_RMS25JB040_SSDID:
+			printk(MPT2SAS_INFO_FMT "%s\n", ioc->name,
+			    MPT2SAS_INTEL_RMS25JB040_BRANDING);
+			break;
+		case MPT2SAS_INTEL_RMS25KB080_SSDID:
+			printk(MPT2SAS_INFO_FMT "%s\n", ioc->name,
+			    MPT2SAS_INTEL_RMS25KB080_BRANDING);
+			break;
+		case MPT2SAS_INTEL_RMS25KB040_SSDID:
+			printk(MPT2SAS_INFO_FMT "%s\n", ioc->name,
+			    MPT2SAS_INTEL_RMS25KB040_BRANDING);
+			break;
 		default:
 			break;
 		}
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
index 2c5bdbe..d7590f1 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -157,6 +157,14 @@
 /*
  * Intel HBA branding
  */
+#define MPT2SAS_INTEL_RMS25JB080_BRANDING    \
+				"Intel(R) Integrated RAID Module RMS25JB080"
+#define MPT2SAS_INTEL_RMS25JB040_BRANDING    \
+				"Intel(R) Integrated RAID Module RMS25JB040"
+#define MPT2SAS_INTEL_RMS25KB080_BRANDING    \
+				"Intel(R) Integrated RAID Module RMS25KB080"
+#define MPT2SAS_INTEL_RMS25KB040_BRANDING    \
+				"Intel(R) Integrated RAID Module RMS25KB040"
 #define MPT2SAS_INTEL_RMS2LL080_BRANDING	\
 				"Intel Integrated RAID Module RMS2LL080"
 #define MPT2SAS_INTEL_RMS2LL040_BRANDING	\
@@ -168,6 +176,10 @@
 /*
  * Intel HBA SSDIDs
  */
+#define MPT2SAS_INTEL_RMS25JB080_SSDID         0x3516
+#define MPT2SAS_INTEL_RMS25JB040_SSDID         0x3517
+#define MPT2SAS_INTEL_RMS25KB080_SSDID         0x3518
+#define MPT2SAS_INTEL_RMS25KB040_SSDID         0x3519
 #define MPT2SAS_INTEL_RMS2LL080_SSDID          0x350E
 #define MPT2SAS_INTEL_RMS2LL040_SSDID          0x350F
 #define MPT2SAS_INTEL_RS25GB008_SSDID          0x3000
