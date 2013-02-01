From: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
Subject: [PATCH 1/8] [SCSI] mpt2sas : Add support for OEM specific controller
Date: Fri, 1 Feb 2013 21:49:30 +0530
Message-ID: <20130201161930.GA21541@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:45879 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750770Ab3BAFZZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Feb 2013 00:25:25 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@kernel.org, sreekanth.reddy@lsi.com, Nagalakshmi.Nandigama@lsi.com, JBottomley@Parallels.com
Cc: linux-scsi@vger.kernel.org, sathya.prakash@lsi.com

Defined SSDID & HW vendor brand strings. Added entries for SSDID within the function
that prints the brand string.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index ffd85c5..0bb2b30 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -2007,6 +2007,14 @@ _base_display_intel_branding(struct MPT2SAS_ADAPTER *ioc)
 			printk(MPT2SAS_INFO_FMT "%s\n", ioc->name,
 			    MPT2SAS_INTEL_RMS25KB040_BRANDING);
 			break;
+		case MPT2SAS_INTEL_RMS25LB040_SSDID:
+			printk(MPT2SAS_INFO_FMT "%s\n", ioc->name,
+			    MPT2SAS_INTEL_RMS25LB040_BRANDING);
+			break;
+		case MPT2SAS_INTEL_RMS25LB080_SSDID:
+			printk(MPT2SAS_INFO_FMT "%s\n", ioc->name,
+			    MPT2SAS_INTEL_RMS25LB080_BRANDING);
+			break;
 		default:
 			break;
 		}
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
index 543d8d6..b46024c 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -165,6 +165,10 @@
 				"Intel(R) Integrated RAID Module RMS25KB080"
 #define MPT2SAS_INTEL_RMS25KB040_BRANDING    \
 				"Intel(R) Integrated RAID Module RMS25KB040"
+#define MPT2SAS_INTEL_RMS25LB040_BRANDING	\
+				"Intel(R) Integrated RAID Module RMS25LB040"
+#define MPT2SAS_INTEL_RMS25LB080_BRANDING	\
+				"Intel(R) Integrated RAID Module RMS25LB080"
 #define MPT2SAS_INTEL_RMS2LL080_BRANDING	\
 				"Intel Integrated RAID Module RMS2LL080"
 #define MPT2SAS_INTEL_RMS2LL040_BRANDING	\
@@ -180,6 +184,8 @@
 #define MPT2SAS_INTEL_RMS25JB040_SSDID         0x3517
 #define MPT2SAS_INTEL_RMS25KB080_SSDID         0x3518
 #define MPT2SAS_INTEL_RMS25KB040_SSDID         0x3519
+#define MPT2SAS_INTEL_RMS25LB040_SSDID         0x351A
+#define MPT2SAS_INTEL_RMS25LB080_SSDID         0x351B
 #define MPT2SAS_INTEL_RMS2LL080_SSDID          0x350E
 #define MPT2SAS_INTEL_RMS2LL040_SSDID          0x350F
 #define MPT2SAS_INTEL_RS25GB008_SSDID          0x3000
