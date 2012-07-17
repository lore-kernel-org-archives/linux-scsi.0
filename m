From: <sreekanth.reddy@lsi.com>
Subject: [PATCH 02/09] [SCSI] mpt2sas : To include more Intel Branding
Date: Tue, 17 Jul 2012 15:56:05 +0530
Message-ID: <20120717102605.GA7340@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:46002 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754735Ab2GQKZV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Jul 2012 06:25:21 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Sathya.Prakash@lsi.com, Nagalakshmi.Nandigama@lsi.com, sreekanth.reddy@lsi.com
Cc: jejb@kernel.org

Updating the customer branding string for "SSD 910 Series" controller

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@lsi.com>
---

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index e68deff..ffa32ad 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -1971,9 +1971,9 @@ _base_display_intel_branding(struct MPT2SAS_ADAPTER *ioc)
 			printk(MPT2SAS_INFO_FMT "%s\n", ioc->name,
 			    MPT2SAS_INTEL_RMS2LL040_BRANDING);
 			break;
-		case MPT2SAS_INTEL_RAMSDALE_SSDID:
+		case MPT2SAS_INTEL_SSD910_SSDID:
 			printk(MPT2SAS_INFO_FMT "%s\n", ioc->name,
-			    MPT2SAS_INTEL_RAMSDALE_BRANDING);
+			    MPT2SAS_INTEL_SSD910_BRANDING);
 			break;
 		default:
 			break;
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
index 64ac0c6..401c8ac 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -171,8 +171,8 @@
 				"Intel Integrated RAID Module RMS2LL040"
 #define MPT2SAS_INTEL_RS25GB008_BRANDING       \
 				"Intel(R) RAID Controller RS25GB008"
-#define MPT2SAS_INTEL_RAMSDALE_BRANDING        \
-				"Intel 720 Series SSD"
+#define MPT2SAS_INTEL_SSD910_BRANDING          \
+				"Intel(R) SSD 910 Series"
 /*
  * Intel HBA SSDIDs
  */
@@ -183,7 +183,7 @@
 #define MPT2SAS_INTEL_RMS2LL080_SSDID          0x350E
 #define MPT2SAS_INTEL_RMS2LL040_SSDID          0x350F
 #define MPT2SAS_INTEL_RS25GB008_SSDID          0x3000
-#define MPT2SAS_INTEL_RAMSDALE_SSDID           0x3700
+#define MPT2SAS_INTEL_SSD910_SSDID             0x3700
 
 /*
  * HP HBA branding
