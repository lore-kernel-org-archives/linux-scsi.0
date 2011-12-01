From: <nagalakshmi.nandigama@lsi.com>
Subject: [PATCH 03/07] [SCSI] mpt2sas : Adding support for customer
 specific branding
Date: Thu, 1 Dec 2011 07:43:00 +0530
Message-ID: <201112010919.pB19JS19018189@milmhbs0.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:44723 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751193Ab1LAJTd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Dec 2011 04:19:33 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, kashyap.desai@lsi.com, Nagalakshmi.Nandigama@lsi.com, Sathya.Prakash@lsi.com, Eric.Moore@lsi.com
Cc: JBottomley@parallels.com

Added support for customer specific branding

Signed-off-by: Nagalakshmi Nandigama <nagalakshmi.nandigama@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index 40c270a..a289c1c 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -1976,6 +1976,10 @@ _base_display_intel_branding(struct MPT2SAS_ADAPTER *ioc)
 			printk(MPT2SAS_INFO_FMT "%s\n", ioc->name,
 			    MPT2SAS_INTEL_RMS2LL040_BRANDING);
 			break;
+		case MPT2SAS_INTEL_RAMSDALE_SSDID:
+			printk(MPT2SAS_INFO_FMT "%s\n", ioc->name,
+			    MPT2SAS_INTEL_RAMSDALE_BRANDING);
+			break;
 		default:
 			break;
 		}
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
index 61e5b24..c19982b 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -163,14 +163,15 @@
 				"Intel Integrated RAID Module RMS2LL040"
 #define MPT2SAS_INTEL_RS25GB008_BRANDING       \
 				"Intel(R) RAID Controller RS25GB008"
-
+#define MPT2SAS_INTEL_RAMSDALE_BRANDING        \
+				"Intel 720 Series SSD"
 /*
  * Intel HBA SSDIDs
  */
 #define MPT2SAS_INTEL_RMS2LL080_SSDID          0x350E
 #define MPT2SAS_INTEL_RMS2LL040_SSDID          0x350F
 #define MPT2SAS_INTEL_RS25GB008_SSDID          0x3000
-
+#define MPT2SAS_INTEL_RAMSDALE_SSDID           0x3700
 
 /*
  * HP HBA branding
